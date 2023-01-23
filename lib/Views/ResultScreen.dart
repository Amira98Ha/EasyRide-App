import '../Models/UberAPI/Uber.dart';
import '../Models/UberAPI/UberPrices.dart';
import '../Models/UberAPI/UberTimes.dart';
import '../Models/BoltAPI/Bolt.dart';
import '../Models/BoltAPI/BoltPrices.dart';
import '../Models/BoltAPI/BoltTimes.dart';
import '../Models/RideResult.dart';

import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var start_latitude = 21.580948130893006;
  var start_longitude = 39.1806807119387;
  var end_latitude = 21.627725155960892;
  var end_longitude = 39.11108797417971;

  // list to display result
  List<RideResult> rideResultList = [];

  // for uber app
  Uber uberOpject = new Uber();
  List<UberPrices> uberPriceList = [];
  List<UberTimes> uberTimeList = [];

  // for bolt app
  Bolt boltOpject = new Bolt();
  List<BoltPrices> boltPriceList = [];
  List<BoltTimes> boltTimeList = [];


  // Price Estimates for uber app
  void getUberPriceEstimates() async {
    uberPriceList = await uberOpject.uberPriceEstimates
        .getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for uber app
  void getUberTimeEstimates() async {
    uberTimeList = await uberOpject.uberTimeEstimates
        .getTime(start_latitude, start_longitude);
  }

  // Price Estimates for bolt app
  void getBoltPriceEstimates() async {
    boltPriceList = await boltOpject.boltPriceEstimates
        .getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for bolt app
  void getBoltTimeEstimates() async {
    boltTimeList = await boltOpject.boltTimeEstimates
        .getTime(start_latitude, start_longitude);
  }

  // join price list and time list
  void joinList(var app_name, List priceList, List timeList) {
    for (var i = 0; i < priceList.length; i++) {
      for (var j = 0; j < timeList.length; j++) {
        // check if product id identical
        if (priceList[i].product_id == timeList[j].product_id) {
          // create new rideResult object
          RideResult rideResultObject = RideResult(app_name, priceList[i].product_id,
              priceList[i].display_name,
              priceList[i].estimate,
              timeList[j].estimate);

          // add objet to rideResultList
          rideResultList.add(rideResultObject);

          // remove object from uberTimeList
          timeList.removeAt(j);
        }
      } // end for
    } // end for
  }
  // for test
  void printList() {
    print(rideResultList.length);
    for (var i = 0; i < rideResultList.length; i++) {
      print(rideResultList[i].app_name + " " + rideResultList[i].product_id
          + " " + rideResultList[i].estimate_price + " " + rideResultList[i].estimate_time.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    getUberPriceEstimates() ;
    getUberTimeEstimates();
    getBoltPriceEstimates() ;
    getBoltTimeEstimates();
    print("This uberrrr");
    joinList("Uber", uberPriceList, uberTimeList);
    joinList("Bolt", boltPriceList, boltTimeList);
    print("This bmooot");
    // for test
    printList();

    return Scaffold(
      //Check if there is available rides or not
      body: rideResultList.length > 0
          ? ListView.separated(
              itemCount: rideResultList.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  //if app name == Bolt present bolt img
                  leading:  rideResultList[index].app_name.toString() == "Bolt" ?
                  const CircleAvatar(
                    radius: 23,
                    backgroundImage: AssetImage("assets/Bolt_Logo.png",),
                  )
                  //if app name == Uber present uber img
                  : const CircleAvatar(
                    radius: 23,
                    backgroundImage: AssetImage("assets/Uber_Logo.png",),
                  ),
                  title: Text(rideResultList[index].app_name),
                  trailing: Text("${rideResultList[index].estimate_price} SAR"),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.white,
              ),
            )
          : const Center(child: Text("Sorry,There is no available rides right now :("),),
    );
  }
}
