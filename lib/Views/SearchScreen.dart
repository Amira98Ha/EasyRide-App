import 'dart:async';

import 'package:easy_ride_app/Views/MapScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import '../Models/MapsConstants.dart';


class SearchScreen extends StatefulWidget {
  SearchScreen({required this.currentAddress});
  final String currentAddress;
  @override
  _SearchScreenState createState() {
    return _SearchScreenState(currentAddress);
  }
}
class _SearchScreenState extends State<SearchScreen> {
  final String currentAddress;
  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();
  TextEditingController _currentAddressController = new TextEditingController();

  GooglePlace googlePlace = GooglePlace(apiKey);
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;

  DetailsResult? startPosition;
  DetailsResult? endPosition;

  //To track which text filed focus
  FocusNode startFocusNode = FocusNode();
  FocusNode endFocusNode = FocusNode() ;

  _SearchScreenState(this.currentAddress);
  @override
  void initState() {
    super.initState();
    _currentAddressController.text = currentAddress;
    _startSearchFieldController.text = _currentAddressController.text;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
  }

  //Method to auto Complete Search by using google_place package
  void autoCompleteSearch(String val) async {
    var result = await googlePlace.autocomplete.get(val);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ]),
            child: Padding(
              padding: EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 25.0,),
                    Stack(
                      children: [
                        //to go back to MainScreen Page
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back),
                        ),
                        Center(
                          child: Text(
                            "Set Drop Off",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16.0,),
                    //START POINT
                    Row(
                      children: [
                        Icon(Icons.gps_fixed),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                //CALL findPlace Method
                               onChanged: (val) {
                                 //Use debounce to be search more fast
                                 if (_debounce?.isActive ?? false) _debounce!.cancel();
                                 _debounce = Timer(const Duration(milliseconds: 1000), (){
                                   //Start check of entry address
                                   if(val.isNotEmpty){
                                     //API Places
                                     autoCompleteSearch(val);
                                   }
                                   else{
                                     //Clear Result
                                     setState(() {
                                       predictions = [];
                                       startPosition = null;
                                     });
                                   }
                                 });
                               },
                                controller: _startSearchFieldController,
                                focusNode: startFocusNode,
                                decoration: InputDecoration(
                                hintText: "PickUp Location",
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                suffixIcon: _startSearchFieldController.text.isNotEmpty ?
                                IconButton(
                                onPressed: () {
                                setState(() {
                                predictions = [];
                                _startSearchFieldController.clear();});
                                },
                                icon: Icon(Icons.clear_outlined),
                                )
                              : null
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                //CALL findPlace Method
                                 onChanged: (val) {
                                   //Use debounce to be search more fast
                                   if (_debounce?.isActive ?? false) _debounce!.cancel();
                                   _debounce = Timer(const Duration(milliseconds: 1000), (){
                                     //Start check of entry address
                                     if(val.isNotEmpty){
                                       //API Places
                                       autoCompleteSearch(val);
                                     }
                                     else{
                                       //Clear Result
                                       setState(() {
                                         predictions = [];
                                         endPosition = null;
                                       });
                                     }
                                   });
                                 },
                                controller: _endSearchFieldController,
                                focusNode: endFocusNode,
                                decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                suffixIcon: _endSearchFieldController.text.isNotEmpty ?
                                IconButton(
                                  onPressed: () {
                                  setState(() {
                                  predictions = [];
                                  _endSearchFieldController.clear();});
                                  },
                                   icon: Icon(Icons.clear_outlined),
                                )
                              : null
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*SizedBox(
            height: 10.0,
          ),*/
          ListView.builder(
              shrinkWrap: true,
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.location_on, color: Colors.black,),
                  title: Text(
                    predictions[index].description.toString(),
                  ),

                  onTap: () async {
                    final placeId = predictions[index].placeId!;
                    final details = await googlePlace.details.get(placeId);
                    if (details != null && details.result != null && mounted ) {
                      //To determine which node(TextField) has been selected
                      if (startFocusNode.hasFocus) {
                        setState(() {
                          //To save the selected place on (startPosition)
                          startPosition = details.result;
                          _startSearchFieldController.text = details.result!.name!;
                          //to remove predictions after selected
                          predictions = [];
                        });
                      } else {
                        setState(() {
                          //To save the selected place on (endPosition)
                          endPosition = details.result;
                          _endSearchFieldController.text = details.result!.name!;
                          //to remove predictions after selected
                          predictions = [];
                        });
                      }
                      //To check user selected all position before search
                      if (startPosition != null && endPosition != null) {
                        print('navigate');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(), //RideResult Scree
                          ),
                        );
                      }
                    }
                  },
                );
              })
        ],
      ),
    );
  }
}


