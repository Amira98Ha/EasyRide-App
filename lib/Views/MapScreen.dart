import 'dart:async';
import 'package:easy_ride_app/Views/Profile.dart';
import 'package:easy_ride_app/Views/signin_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Controllers/GeolocatorController.dart';
import 'SearchScreen.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();

}
class NavigationDrawer extends StatelessWidget {
   NavigationDrawer({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Drawer(
       child: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: <Widget>[
             buildHeader(context),
             buildMenuItems(context),
           ],
         ),
       ),
     );

   }
}
//sidebar Details Style
Widget buildHeader(BuildContext context) => Container(
  padding: EdgeInsets.only(
    top: MediaQuery.of(context).padding.top,
  ),
);

//sidebar items
Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(35),
    child: Wrap(
  runSpacing: 16,
    children: [
    ListTile(
      leading: const Icon(Icons.home_outlined),
      title: const Text("Home"),
      onTap: (){Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder:
          (context) => MapScreen()
      ));},
    ),
    ListTile(
      leading: const Icon(Icons.account_circle_outlined ),
      title: const Text("My Profile"),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder:
            (context) => MyProfile()
        ));
      }
    ),
    const Divider(color: Colors.black),

      ListTile(
        leading: const Icon(Icons.exit_to_app),
        title: const Text("Logout"),
        onTap: (){
          FirebaseAuth.instance.signOut().then(
              (value){
              print("signed out");
               Navigator.push(context, MaterialPageRoute(builder: (context)=> SigninSignUp()));
});
        },
      ),
  ],
    ),
);

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newGoogleMapController;
  late Position currentPosition;
  Set<Marker> markers = {};
  var geoLocator = Geolocator();

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(21.580529960492743, 39.18089494603335),
    zoom: 14.4746,
  );

  void locatePosition() async {
    try {
      // check location permissions
      // get user current location
      GeoLocatorController geoLocatorController = GeoLocatorController();
      currentPosition = await geoLocatorController.determinePosition();

      LatLng latLngPosition = LatLng(currentPosition.latitude, currentPosition.longitude);

      // change camera position to user location
      CameraPosition cameraPosition =
      new CameraPosition(target: latLngPosition, zoom: 14);
      newGoogleMapController
          .animateCamera((CameraUpdate.newCameraPosition(cameraPosition)));

      setState(() {
        // add marker
        markers.add(Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(currentPosition.latitude, currentPosition.longitude)));
      });
    }

    catch (error) {
      // close app
      print(error);
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // getRide(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
      ),
      drawer: NavigationDrawer(),
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
                                    builder: (context) => SearchScreen(currentPosition: currentPosition)));
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

