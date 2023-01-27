import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'SearchScreen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newGoogleMapController;
  late Position currentPosition;
  Set<Marker> markers = {};
  var geoLocator = Geolocator();

  var currentAddress = "";

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(21.580529960492743, 39.18089494603335),
    zoom: 14.4746,
  );

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera((CameraUpdate.newCameraPosition(cameraPosition)));

    markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude)));

    getAddress();
  }

  void getAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    setState(() {
      currentAddress = placemarks.reversed.last.street.toString();
    });
  }

  //
  //
  // LatLng currentLocation = _initialPositionOfCamera.target;
  //
  //
  // void getRide(BuildContext context) async {
  //   final boltAppFile = await rootBundle.loadString('json/bolt_app.json');
  //   final uberAppFile = await rootBundle.loadString('json/uber_app.json');
  //   final careemAppFile = await rootBundle.loadString('json/careem_app.json');
  //
  //   final boltJson = jsonDecode(boltAppFile);
  //   final uberJson = jsonDecode(uberAppFile);
  //   final careemJson = jsonDecode(careemAppFile);
  //
  //   checkRideDistance(boltJson, 'Bolt');
  //   checkRideDistance(uberJson, 'Uber');
  //   checkRideDistance(careemJson, 'Careem');
  // }
  //
  // void checkRideDistance(jsonFile, appName) async {
  //   var data = jsonFile["data"];
  //
  //   List<String> ridesList = [];
  //
  //   for( var i in data ) {
  //     double distanceInMeters = Geolocator.distanceBetween(currentLocation.latitude,
  //         currentLocation.longitude, i['locationLat'], i['locationLng']);
  //
  //     if (distanceInMeters <= 5000) {
  //       String s = '\tCar id = ' + i['car_id'] + '\n\tDistance = ' + distanceInMeters.toString();
  //       ridesList.add(s);
  //     }
  //   }
  //
  //   print('Ride app (' + appName + ')');
  //
  //   if (ridesList.isNotEmpty) {
  //     for ( var i in ridesList) {
  //       print(i);
  //     }
  //   }
  //   else {
  //     print('\t There is no car available in your area');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // getRide(context);
    return Scaffold(
      body: Stack(
        children: [
          //Google Map Widget
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            markers: markers,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;
              locatePosition();
            },
          ),

          //Search Navigation UI
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              //Animation
              child: AnimatedSize(
                curve: Curves.bounceIn,
                duration: const Duration(milliseconds: 160),
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
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

                  //Box Details Style
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6.0),
                        const Text(
                          "Hi there,",
                          style: TextStyle(fontSize: 12.0),
                        ),
                        const Text(
                          "Where to go?",
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: "Brand Bold"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        // To display searchScreen on tap drop off label
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => SearchScreen(currentAddress: currentAddress)));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: const [
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
                                  children: const [
                                    Icon(Icons.search, color: Colors.grey),
                                    SizedBox(width: 10.0),
                                    Text("Search Drop Off"),
                                    //Text(currentAddress),
                                  ],
                                ),
                              )),
                        ),

                        //Add Home BOX
                        const SizedBox(height: 24.0),
                        Row(
                          children: [
                            const Icon(Icons.home, color: Colors.grey),
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
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
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.work, color: Colors.grey),
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
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
