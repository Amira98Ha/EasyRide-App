import 'dart:math';

import '../Models/UberAPI/Uber.dart';
import '../Models/UberAPI/UberPrices.dart';
import '../Models/UberAPI/UberTimes.dart';
import '../Models/BoltAPI/Bolt.dart';
import '../Models/BoltAPI/BoltPrices.dart';
import '../Models/BoltAPI/BoltTimes.dart';
import '../Models/RideResult.dart';

import 'package:flutter/material.dart';

class CheapestRideScreen extends StatefulWidget {
  CheapestRideState createState() => CheapestRideState();
}

class CheapestRideState extends State<CheapestRideScreen> {
  late Future<void> _future;

  var start_latitude = 21.580948130893006;
  var start_longitude = 39.1806807119387;
  var end_latitude = 21.627725155960892;
  var end_longitude = 39.11108797417971;

  // list to display result
  List<RideResult> rideResultList = [];
  var optimalChoiceId = "";

  // for uber app
  Uber uberObject = new Uber();
  List<UberPrices> uberPriceList = [];
  List<UberTimes> uberTimeList = [];

  // for bolt app
  Bolt boltObject = new Bolt();
  List<BoltPrices> boltPriceList = [];
  List<BoltTimes> boltTimeList = [];

  @override
  void initState() {
    _future = searchRides();
    super.initState();
  }

  Future<void> searchRides() async {
    await getUberPriceEstimates();
    await getUberTimeEstimates();
    await getBoltPriceEstimates();
    await getBoltTimeEstimates();
    print("UBER display---------");
    joinList("Uber", uberPriceList, uberTimeList);
    print("BOLT display---------");
    joinList("Bolt", boltPriceList, boltTimeList);
    print("PRICE display---------");
    optimalChoice();
    priceCompare();
  }

  // Price Estimates for uber app
  Future<void> getUberPriceEstimates() async {
    uberPriceList = await uberObject.uberPriceEstimates
        .getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for uber app
  Future<void> getUberTimeEstimates() async {
    uberTimeList = await uberObject.uberTimeEstimates
        .getTime(start_latitude, start_longitude);
  }

  // Price Estimates for bolt app
  Future<void> getBoltPriceEstimates() async {
    boltPriceList = await boltObject.boltPriceEstimates
        .getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for bolt app
  Future<void> getBoltTimeEstimates() async {
    boltTimeList = await boltObject.boltTimeEstimates
        .getTime(start_latitude, start_longitude);
  }

  // join price list and time list
  void joinList(var app_name, List priceList, List timeList) {
    for (var i = 0; i < priceList.length; i++) {
      for (var j = 0; j < timeList.length; j++) {
        // check if product id identical
        if (priceList[i].product_id == timeList[j].product_id) {
          // create new rideResult object
          RideResult rideResultObject = RideResult(
              app_name,
              priceList[i].product_id,
              priceList[i].display_name,
              priceList[i].estimate,
              timeList[j].estimate,
              priceList[i].low_estimate,
              priceList[i].high_estimate);

          // add objet to rideResultList
          rideResultList.add(rideResultObject);

          // remove object from uberTimeList
          timeList.removeAt(j);

          // exit timeList
          break;
        }
      } // end for
    } // end for
  }

  void optimalChoice() async {
    //sort time descending
    rideResultList.sort((a, b) => a.estimate_time.compareTo(b.estimate_time));
    // get less time
    int lessTime = rideResultList[0].estimate_time;

    //sort price ascending
    rideResultList.sort((a, b) => a.estimate_price.compareTo(b.estimate_price));
    // get less price
    int lessPrice = rideResultList[0].low_estimate;

    optimalChoiceId = rideResultList[0].product_id;
    double lessDistance = await calculateDistance(rideResultList[0].low_estimate, lessPrice,
        rideResultList[0].estimate_time, lessTime);


    for (var i = 0; i < rideResultList.length; i++) {
      double distance = await calculateDistance(rideResultList[i].low_estimate, lessPrice,
          rideResultList[i].estimate_time, lessTime);

      if (distance < lessDistance) {
        lessDistance = distance;
        optimalChoiceId = rideResultList[i].product_id;
      }
    }

    print("optimalChoiceId = " + optimalChoiceId);
  }

  Future<double> calculateDistance(int x1, int x2, int y1, int y2) async {
    // Distance Between Two Points
    return sqrt(pow((x2 - x1),2) + pow((y2 - y1),2));
  }

  //Sort list in term of cheapest
  void priceCompare() async {
    //sort price ascending
    rideResultList.sort((a, b) => a.estimate_price.compareTo(b.estimate_price));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future, // function to search for rides
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // if searchRides() has not finish
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          // if searchRides() has error
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            //Display Nested Tap Bar
            return DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: AppBar(
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      indicatorColor: Colors.black,
                      tabs: <Widget>[
                        //1- Tap
                        Tab(
                          child: Text(
                            "All",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),

                        //1- Tap
                        Tab(
                          child: Text(
                            "Standard",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),

                        //1- Tap
                        Tab(
                          child: Text(
                            "Family",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),

                        //1- Tap
                        Tab(
                          child: Text(
                            "Luxury",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    AllRides(),
                    StandardRides(),
                    FamilyRides(),
                    LuxuryRides(),
                  ],
                ),
              ),
            );
          } // else
        } // else
      },
    );
  }

  //Method Display All Rides
  AllRides() {
    return Scaffold(
      //Check if there is available rides or not
      body: rideResultList.isNotEmpty
          ? ListView.builder(
              itemCount: rideResultList.length,
              itemBuilder: (context, int index) {
                num time = rideResultList[index].estimate_time / 60;

                return ListTile(
                  //if app name == Bolt present bolt img
                  leading: rideResultList[index].app_name.toString() == "Bolt"
                      ? const CircleAvatar(
                          radius: 23,
                          backgroundImage: AssetImage(
                            "assets/Bolt_Logo.png",
                          ),
                        )
                      //if app name == Uber present uber img
                      : const CircleAvatar(
                          radius: 23,
                          backgroundImage: AssetImage(
                            "assets/Uber_Logo.png",
                          ),
                        ),
                  title: Text(rideResultList[index].display_name),
                  subtitle: Text("${time.toInt()} min to arrive"),
                  trailing: rideResultList[index].product_id == optimalChoiceId ?
                    Text("${rideResultList[index].estimate_price} SAR\nOptimal choice")
                        : Text("${rideResultList[index].estimate_price} SAR"),

                  // Display optimal choice
                  tileColor: rideResultList[index].product_id == optimalChoiceId ? Colors.grey : null,
                );
              },
              // separatorBuilder: (BuildContext context, int index) =>
              //     const Divider(
              //   color: Colors.white,
              // ),
            )
          : const Center(
              child: Text("Sorry,There is no available rides right now :("),
            ),
    );
  } // build

  //Method Display Only Standard Rides
  StandardRides() {
    return Scaffold(
      //Check if there is available rides or not
      body: rideResultList.isNotEmpty
          ? ListView.builder(
              itemCount: rideResultList.length,
              itemBuilder: (context, int index) {
                num time = rideResultList[index].estimate_time / 60;
                if ((rideResultList[index].display_name.toString() != "VIP") &&
                    (rideResultList[index].display_name.toString() != "XL") &&
                    (rideResultList[index].display_name.toString() !=
                        "BLACK") &&
                    (rideResultList[index].display_name.toString() !=
                        "uberXL")) {
                  return ListTile(
                    //if app name == Bolt present bolt img
                    leading: rideResultList[index].app_name.toString() == "Bolt"
                        ? const CircleAvatar(
                            radius: 23,
                            backgroundImage: AssetImage(
                              "assets/Bolt_Logo.png",
                            ),
                          )
                        //if app name == Uber present uber img
                        : const CircleAvatar(
                            radius: 23,
                            backgroundImage: AssetImage(
                              "assets/Uber_Logo.png",
                            ),
                          ),
                    title: Text(rideResultList[index].display_name),
                    subtitle: Text("${time.toInt()} min to arrive"),
                    trailing:
                        Text("${rideResultList[index].estimate_price} SAR"),
                  );
                }
                return SizedBox(height: 0);
              },
              // separatorBuilder: (BuildContext context, int index) =>
              // const Divider(
              //   color: Colors.white,
              // ),
            )
          : const Center(
              child: Text("Sorry,There is no available rides right now :("),
            ),
    );
  }

  // Method Display Only Family Rides
  FamilyRides() {
    return Scaffold(
      //Check if there is available rides or not
      body: rideResultList.isNotEmpty
          ? ListView.builder(
              itemCount: rideResultList.length,
              itemBuilder: (context, int index) {
                num time = rideResultList[index].estimate_time / 60;
                if ((rideResultList[index].display_name.toString() == "XL") ||
                    (rideResultList[index].display_name.toString() ==
                        "uberXL")) {
                  return ListTile(
                    //if app name == Bolt present bolt img
                    leading: rideResultList[index].app_name.toString() == "Bolt"
                        ? const CircleAvatar(
                            radius: 23,
                            backgroundImage: AssetImage(
                              "assets/Bolt_Logo.png",
                            ),
                          )
                        //if app name == Uber present uber img
                        : const CircleAvatar(
                            radius: 23,
                            backgroundImage: AssetImage(
                              "assets/Uber_Logo.png",
                            ),
                          ),
                    title: Text(rideResultList[index].display_name),
                    subtitle: Text("${time.toInt()} min to arrive"),
                    trailing:
                        Text("${rideResultList[index].estimate_price} SAR"),
                  );
                }
                return SizedBox(height: 0);
              },
              // separatorBuilder: (BuildContext context, int index) =>
              // const Divider(
              //   color: Colors.white,
              // ),
            )
          : const Center(
              child: Text("Sorry,There is no available rides right now :("),
            ),
    );
  } // build

  // Method Display Only Luxury Rides
  LuxuryRides() {
    return Scaffold(
      //Check if there is available rides or not
      body: rideResultList.isNotEmpty
          ? ListView.builder(
              itemCount: rideResultList.length,
              itemBuilder: (context, int index) {
                num time = rideResultList[index].estimate_time / 60;
                if ((rideResultList[index].display_name.toString() == "VIP") ||
                    (rideResultList[index].display_name.toString() ==
                        "BLACK")) {
                  return ListTile(
                    //if app name == Bolt present bolt img
                    leading: rideResultList[index].app_name.toString() == "Bolt"
                        ? const CircleAvatar(
                            radius: 23,
                            backgroundImage: AssetImage(
                              "assets/Bolt_Logo.png",
                            ),
                          )
                        //if app name == Uber present uber img
                        : const CircleAvatar(
                            radius: 23,
                            backgroundImage: AssetImage(
                              "assets/Uber_Logo.png",
                            ),
                          ),
                    title: Text(rideResultList[index].display_name),
                    subtitle: Text("${time.toInt()} min to arrive"),
                    trailing:
                        Text("${rideResultList[index].estimate_price} SAR"),
                  );
                }
                return SizedBox(height: 0);
              },
              // separatorBuilder: (BuildContext context, int index) =>
              // const Divider(
              //   color: Colors.white,
              // ),
            )
          : const Center(
              child: Text("Sorry,There is no available rides right now :("),
            ),
    );
  } // build

} // cheapestScreen
