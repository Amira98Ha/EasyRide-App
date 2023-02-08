import 'package:easy_ride_app/Views/CheapestRideScreen.dart';
import 'package:easy_ride_app/Views/FastestRideScreen.dart';
import 'package:easy_ride_app/Views/ResultScreen.dart';
import 'package:flutter/material.dart';

class TapsScreen extends StatelessWidget {
  const TapsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Rides Result"),
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              //1-tap
              Tab(
                child: Text(
                  "Cheapest",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Brand Bold",
                  ),
                ),
              ),

              //3-tap
              Tab(
                child: Text(
                  "Fastest",
                  style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CheapestRideScreen(),
            FastestRideScreen(),
          ],
        ),
      ),
    );
  }

}

