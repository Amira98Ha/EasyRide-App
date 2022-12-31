import 'package:easy_ride_app/Controllers/RequestController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/MapsConstants.dart';
import '../Models/PlacesPredictions.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({required this.currentAddress});
  final String currentAddress;
  @override
  _SearchScreenState createState() {
    return _SearchScreenState(this.currentAddress);
  }
}

class _SearchScreenState extends State<SearchScreen> {
  final String currentAddress;
  _SearchScreenState(this.currentAddress);

  String API_KEY = MapsConstants.apiKey;
  List<PlacesPredictions> placesPredictionsList = [];

  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = currentAddress;
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
              child: Column(
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  Stack(
                    children: [
                      //to go back to mainscreen Page
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back),
                      ),
                      Center(
                        child: Text(
                          "Set Drop Off",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bold"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.gps_fixed),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: _controller,
                              onChanged: (val) {
                                findPlace(val);
                              },
                              decoration: InputDecoration(
                                hintText: "PickUp Location",
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
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
          /*SizedBox(
            height: 10.0,
          ),*/

          //Display PredictionsTile Class
          (placesPredictionsList.length > 0)
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      return PredictionsTile(
                        placesPredictions: placesPredictionsList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemCount: placesPredictionsList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  //Method to autocomplete places from google map
  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteURL =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$API_KEY&sessiontoken=1234567890&components=country:sa";

      var res = await RequestController.getRequest(autoCompleteURL);

      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];

        var placesList = (predictions as List)
            .map((e) => PlacesPredictions.formJson(e))
            .toList();

        setState(() {
          placesPredictionsList = placesList;
        });
      }
    }
  }
}

//Widget to display Place Predictions
class PredictionsTile extends StatelessWidget {
  final PlacesPredictions placesPredictions;
  PredictionsTile({Key? key, required this.placesPredictions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            width: 10.0,
          ),
          Row(
            children: [
              Icon(Icons.add_location),
              SizedBox(
                width: 14.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 8.0,),
                    Text(
                      placesPredictions.main_text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      placesPredictions.secondary_text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    //SizedBox(height: 8.0,),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            width: 14.0,
          ),
        ],
      ),
    );
  }
}
