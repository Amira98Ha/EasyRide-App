import 'dart:async';
import 'dart:convert';

import 'package:easy_ride_app/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Assistants/assistantMethods.dart';
import 'locationService.dart';
import 'package:flutter/services.dart';
import 'ride.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  //const MainScreen({Key? key}) : super(key: key);
 //FirebaseService _service = FirebaseService();


//try lbs Amira
  double _latitude=0;
  double _longtitude=0;
  @override
  _MainScreenState createState() => _MainScreenState();
}

void getRide(BuildContext context) async {
  final rideAppFile1 = await rootBundle.loadString('json/rideapp_1.json');
  final rideAppFile2 = await rootBundle.loadString('json/rideapp_2.json');
  final rideAppFile3 = await rootBundle.loadString('json/rideapp_3.json');

  final json1 = jsonDecode(rideAppFile1);
  final json2 = jsonDecode(rideAppFile2);
  final json3 = jsonDecode(rideAppFile3);

  checkRideDistance(json1, 'Bolt');
  checkRideDistance(json2, 'Uber');
  checkRideDistance(json3, 'Careem');
}

void checkRideDistance(json, appName) async {
  var userLocation_lat = 21.817434554305592;
  var userLocation_lng = 39.174088106291514;

  var data = json["data"];
  print('Ride app (' + appName + ')');
  for( var i in data ) {
    double distanceInMeters = Geolocator.distanceBetween(userLocation_lat, userLocation_lng, i['locationLat'], i['locationLng']);
    if (distanceInMeters <= 5000) {
      print('\t Car id = ' + i['car_id']);
      print('\t Distance = ' + distanceInMeters.toString());
    }
  }
}

class _MainScreenState extends State<MainScreen> {
//Banner for Search to close and open nav
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

//From google_maps_flutter
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  late Position currentPosition;
  var geoLocator = Geolocator();

  //bool drawerOpen = true;
   //late String address;



  //To get Current Location
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);
    //animation
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //address = AssistantMethods.searchCoordinateAddress(currentPosition, context) as String;
    //print("------------**************************-------------------------***This is your address:: $address");
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.485811, 39.1925048),
    zoom: 14.4746,
  );



  //try amira
  //locationService _locationService = locationService();
  //_locationService.sendLocationToDataBase(context);
  //_locationService.goToMaps(_latitude, _longitude);


  //PIN Marker
  final List<Marker> _markers = const <Marker>[
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(21.485811, 39.1925048),
      infoWindow: InfoWindow(
        title: 'the title of the marker'
      )
    )
  ];

  @override
  Widget build(BuildContext context) {
    // test json
    getRide(context);
   //AssistantMethods.searchCoordinateAddress(currentPosition, context);
    return Scaffold(

    // floatingActionButton: FloatingActionButton(
      // onPressed:(){
        //  _locationService.sendLocationToDataBase(context);
       //};
     //)



      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              locatePosition();
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

            },
          ),
         
         
         
         //Search Navigation UI
         //The Box Style 
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            //Anamition
            child: AnimatedSize(
              //vsync: this,
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
                  
                  //The Box Shadow Style
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ]
                ),
                //End Box Style 


                //Box Detiles Style
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: [
                      SizedBox(height: 6.0),
                      Text("Hi there,", style: TextStyle(fontSize: 12.0),),
                      Text("Where to go?", style: TextStyle(fontSize: 20.0, fontFamily:
                        "Brand Bold"),),
                      SizedBox(height: 20,),


                      // To display searchScreen on tap drop off label
                      GestureDetector(
                        onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
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
                                offset: Offset(0.6,.6),
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
                        )
                        ),
                      ),
                     
                     
                     
                     //Add Home BOX
                      SizedBox(height: 24.0),
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey),
                          SizedBox(width:12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Home"),
                              SizedBox(height: 4.0),
                              Text("Your living home address",
                                style: TextStyle(color: Colors.black54,
                                fontSize: 12),)
                            ],
                          )
                        ],
                      ),
                      
                      
                      //Add Work BOX (Have the Same Row)
                      SizedBox(height: 10,),
                      Divider(),
                      SizedBox(height: 16.0,),
                      Row(
                        children: [
                          Icon(Icons.work, color: Colors.grey),
                          SizedBox(width:12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Work"),
                              SizedBox(height: 4.0),
                              Text("your work",
                                style: TextStyle(color: Colors.black54,
                                    fontSize: 12),)
                            ],
                          )
                        ],
                      ),
                    ],

                  ),
                ),
              ),
            )
          )

        





        ],
      ),
    );
  }
}
