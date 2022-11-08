import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'SearchScreen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}



class _MapScreenState extends State<MapScreen> {
  //To control the map
  Completer<GoogleMapController> _googleMapcontroller = Completer();

  LatLng currentLocation = _initialPositionOfCamera.target;

  //The first Position of Camera
  static final CameraPosition _initialPositionOfCamera = CameraPosition(
    target: LatLng(21.5799, 39.1808), //latitude, longitude
    zoom: 14.4746,
  );
  void getRide(BuildContext context) async {
    final boltAppFile = await rootBundle.loadString('json/bolt_app.json');
    final uberAppFile = await rootBundle.loadString('json/uber_app.json');
    final careemAppFile = await rootBundle.loadString('json/careem_app.json');

    final boltJson = jsonDecode(boltAppFile);
    final uberJson = jsonDecode(uberAppFile);
    final careemJson = jsonDecode(careemAppFile);

    checkRideDistance(boltJson, 'Bolt');
    checkRideDistance(uberJson, 'Uber');
    checkRideDistance(careemJson, 'Careem');
  }

  void checkRideDistance(jsonFile, appName) async {

    var data = jsonFile["data"];

    List<String> ridesList = [];

    for( var i in data ) {
      double distanceInMeters = Geolocator.distanceBetween(
          currentLocation.latitude, currentLocation.longitude, i['locationLat'], i['locationLng']);
      if (distanceInMeters <= 5000) {
        String s = '\tCar id = ' + i['car_id'] + '\n\tDistance =' + distanceInMeters.toString();
        ridesList.add(s);
      }
    }

    print('Ride app (' + appName + ')');

    if (ridesList.isNotEmpty) {
      for ( var i in ridesList) {
        print(i);
      }
    }
    else {
      print('\t There is no car available in your area');
    }
  }
  @override
  Widget build(BuildContext context) {
    //test JISON
    getRide(context);
    return new Scaffold(
      body: Stack(
        children: [
          //Google Map Widget
          GoogleMap(
              initialCameraPosition: _initialPositionOfCamera,
              mapType: MapType.normal,
              onMapCreated: (controller) => _googleMapcontroller.complete(controller),
              onCameraMove: (CameraPosition newPosition) {
                currentLocation = newPosition.target;
              } //onCameraMove
              ),

          //Search Navigation UI
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              //Anamition
              child: AnimatedSize(
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ]),

                  //Box Detiles Style
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 18.0
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.0),
                        Text(
                          "Hi there,",
                          style: TextStyle(fontSize: 12.0),
                        ),
                        Text(
                          "Where to go?",
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: "Brand Bold"),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // To display searchScreen on tap drop off label
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 11.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.6, .6),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.search, color: Colors.grey),
                                    SizedBox(width: 10.0),
                                    Text("Search Drop Off"),
                                  ],
                                ),
                              )),
                        ),

                        //Add Home BOX
                        SizedBox(height: 24.0),
                        Row(
                          children: [
                            Icon(Icons.home, color: Colors.grey),
                            SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add Home"),
                                SizedBox(height: 4.0),
                                Text(
                                  "Your living home address",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),

                        //Add Work BOX (Have the Same Row)
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          children: [
                            Icon(Icons.work, color: Colors.grey),
                            SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add Work"),
                                SizedBox(height: 4.0),
                                Text(
                                  "your work",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  } //Widget
} //_MapScreenState
