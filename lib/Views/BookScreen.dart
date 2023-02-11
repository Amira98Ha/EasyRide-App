import 'package:flutter/material.dart';
import '../Models/RideResult.dart';
import 'package:external_app_launcher/external_app_launcher.dart';





class BookScreen extends StatelessWidget {
  final RideResult rideResult;
  final num time;

  const BookScreen({Key? key, required this.rideResult, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Ride"),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
        centerTitle: true,
      ),
      body:Center(
        child : Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(19.0),
              //if app name == Bolt present bolt img
              child:
              rideResult.app_name.toString() == "Bolt"
                  ? const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(
                  "assets/Bolt_Logo.png",
                ),
              )
              //if app name == Uber present uber img
                  : const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(
                  "assets/Uber_Logo.png",
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(rideResult.display_name,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Divider(
              thickness: 2, //thickness of divier line
              indent: 50, //spacing at the start of divider
              endIndent: 50, //spacing at the end of divider
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("${time.toInt()} min to arrive",style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Divider(
              thickness: 2, //thickness of divier line
              indent: 50, //spacing at the start of divider
              endIndent: 50, //spacing at the end of divider
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("${rideResult.estimate_price} SAR",style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
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
                child: Text("Book", style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: () async {
                  if (rideResult.app_name.toString() == "Uber")
                    await LaunchApp.openApp(
                      androidPackageName: 'com.ubercab&hl=ar&gl=US',
                    );
                  else
                    await LaunchApp.openApp(
                      androidPackageName: 'ee.mtakso.client&hl=en_US&gl=US',
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  } //wh
}//class

