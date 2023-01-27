import 'package:easy_ride_app/Views/CheapestRideScreen.dart';
import 'package:easy_ride_app/Views/FastestRideScreen.dart';
import 'package:easy_ride_app/Views/ResultScreen.dart';
import 'package:flutter/material.dart';

class TapsScreen extends StatelessWidget {
  const TapsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ride Result"),
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              //1-tap
              Tab(
                text: "Optimal Choice",
              ),

              //2-tap
              Tab(
                text: "Fastest",
              ),

              //3-tap
              Tab(
                text: "Cheapest",
              ),
            ],
          ),
        ),
        body: TabBarView(
            children: [
            ResultScreen(),
            FastestRideScreen(),
            CheapestRideScreen(),

          ],

        ),
      ),
    );
  }
}
