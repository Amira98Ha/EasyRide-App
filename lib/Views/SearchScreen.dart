import 'dart:async';

import 'package:easy_ride_app/Views/MapScreen.dart';
import 'package:easy_ride_app/Views/ResultScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import '../Models/MapsConstants.dart';
import 'ResultScreen.dart';


class SearchScreen extends StatefulWidget {
  SearchScreen({required this.currentPosition});
  final Position currentPosition;
  @override
  _SearchScreenState createState() {
    return _SearchScreenState(currentPosition);
  }
}
class _SearchScreenState extends State<SearchScreen> {
  final Position currentPosition;
  var currentAddress = "";

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
  FocusNode endFocusNode = FocusNode();

  //To be send to ResultScreen
  var start_latitude;
  var start_longitude;
  var end_latitude;
  var end_longitude;

  _SearchScreenState(this.currentPosition);

  @override
  void initState() {
    super.initState();
    getAddress().whenComplete(() {
      _currentAddressController.text = currentAddress;
      _startSearchFieldController.text = _currentAddressController.text;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
  }

  Future<void> getAddress() async {
    // Convert position to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    currentAddress = placemarks.reversed.last.street.toString();
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
                                          _startSearchFieldController.clear();
                                          startPosition = null;});
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
                                          _endSearchFieldController.clear();
                                          endPosition = null;});
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
                    }
                  },
                );
              }),
           ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(327, 50),
                primary: Colors.black,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                )
              ),

                onPressed: (){
                  // if start point = current location
                  if (_startSearchFieldController.text == currentAddress && endPosition != null ) {
                  // start point
                  start_latitude = currentPosition.latitude;
                  start_longitude = currentPosition.longitude;
                  // end point
                  end_latitude = endPosition?.geometry?.location?.lat;
                  end_longitude = endPosition?.geometry?.location?.lng;

                  //Next Page
                  print("start point = current location and end point NOT NULL");
                  Navigator.push( context,  MaterialPageRoute(
                  builder: (context) => ResultScreen(
                      start_latitude: start_latitude,
                      start_longitude: start_longitude,
                      end_latitude: end_latitude,
                      end_longitude: end_longitude), //RideResult Screen
                  ),);
                  }

                  //To check all position NOT NULL before search AND start point = current location
                  else if ((_startSearchFieldController.text == currentAddress && endPosition == null) || (startPosition == null || endPosition == null) ){
                    //Next Page
                    print("start point OR end pont -NULL----");
                    showDialog(context:context, builder: (context){
                      return AlertDialog(
                        title:Text("Error Message"),
                        titleTextStyle: TextStyle(color: Colors.red, fontWeight:FontWeight.bold, fontSize: 20 ),
                        content: Text("Please, Enter start-point and end-point location"),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("ok")),
                        ],
                      );
                    });
                  }
                  //To check all position NOT NULL before search AND start point = current location
                  if (_startSearchFieldController.text == _endSearchFieldController.text ){
                    //Next Page
                    print("EQUAL:)) ");
                    showDialog(context:context, builder: (context){
                      return AlertDialog(
                        title:Text("Error Message"),
                        titleTextStyle: TextStyle(color: Colors.red, fontWeight:FontWeight.bold, fontSize: 20 ),
                        content: Text("Please, Enter Valid Location"),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("ok")),
                        ],
                      );
                    });
                  }

                  //To check user selected all position before search
                  else if (startPosition != null && endPosition != null) {
                    // start point
                    start_latitude = currentPosition.latitude;
                    start_longitude = currentPosition.longitude;
                    // end point
                    end_latitude = endPosition?.geometry?.location?.lat;
                    end_longitude = endPosition?.geometry?.location?.lng;

                    //Next Page
                    print("start point and end pont NOT NULL");
                    Navigator.push( context,  MaterialPageRoute(
                      builder: (context) => ResultScreen(
                          start_latitude: start_latitude,
                          start_longitude: start_longitude,
                          end_latitude: end_latitude,
                          end_longitude: end_longitude), //RideResult Screen
                    ),);
                  }

                }, //onPressed

                child: const Text("Search" , style: TextStyle(fontWeight: FontWeight.bold),)
            ),

        ],

      ),

    );
  }

}




