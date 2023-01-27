import '../Models/UberAPI/Uber.dart';
import '../Models/UberAPI/UberPrices.dart';
import '../Models/UberAPI/UberTimes.dart';
import '../Models/BoltAPI/Bolt.dart';
import '../Models/BoltAPI/BoltPrices.dart';
import '../Models/BoltAPI/BoltTimes.dart';
import '../Models/RideResult.dart';

import 'package:flutter/material.dart';


class ResultController extends StatefulWidget{
  @override
  ResultControllerState createState() => ResultControllerState();
}
class ResultControllerState extends State<ResultController>
{
  var start_latitude = 21.580948130893006;
  var start_longitude = 39.1806807119387;
  var end_latitude = 21.627725155960892;
  var end_longitude = 39.11108797417971;

  // list to display result
  static List<RideResult> rideResultList = [];

  // for uber app
  Uber uberOpject = new Uber();
  List<UberPrices> uberPriceList = [];
  List<UberTimes> uberTimeList = [];

  // for bolt app
  Bolt boltOpject = new Bolt();
  List<BoltPrices> boltPriceList = [];
  List<BoltTimes> boltTimeList = [];


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
    priceCompare();
  }

  // Price Estimates for uber app
  Future<void> getUberPriceEstimates() async {
    uberPriceList = await uberOpject.uberPriceEstimates
        .getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for uber app
  Future<void> getUberTimeEstimates() async {
    uberTimeList = await uberOpject.uberTimeEstimates
        .getTime(start_latitude, start_longitude);
  }

  // Price Estimates for bolt app
  Future<void> getBoltPriceEstimates() async {
    boltPriceList = await boltOpject.boltPriceEstimates
        .getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for bolt app
  Future<void> getBoltTimeEstimates() async {
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

  //Sort list in term of cheapest
  static priceCompare() async {
    //sort price ascending
    rideResultList.sort((a, b) => a.estimate_price.compareTo(b.estimate_price));

    //choose first index for cheapest
    // var cheapRide= rideResultList[0].low_estimate;
    // for(var i = 0; i < rideResultList.length; i++){
    //   if(rideResultList[i].low_estimate < cheapRide) {
    //     //store the cheapest ride using its product it
    //     cheapRide= rideResultList[i].product_id;
    //     rideResultList.add(cheapRide);
    //   }
    //   else if(rideResultList[i].low_estimate == cheapRide){
    //     //check later
    //
    //   }
    // }

  }

  static timeCompare() {
    //sort time descending
    rideResultList.sort((a, b) => b.estimate_time.compareTo(a.estimate_time));
    var fastestRide = rideResultList[0].estimate_time;
    for (var i = 0; i < rideResultList.length; i++) {
      if (rideResultList[i].estimate_time > fastestRide) {
        fastestRide = rideResultList[i].product_id;
      }
    }
  }

  static OptimalChoice() {

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: searchRides(), // function to search for rides
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // if searchRides() has not finish
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        }
        else {
          // if searchRides() has error
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            // if searchRides() finish successfully
            return Scaffold(
              //Check if there is available rides or not
              body: rideResultList.length > 0
                  ? ListView.separated(
                itemCount: rideResultList.length,
                itemBuilder: (context, int index) {
                  num time = rideResultList[index].estimate_time / 60;
                  return ListTile(
                    //if app name == Bolt present bolt img
                    leading: rideResultList[index].app_name.toString() == "Bolt"
                        ?
                    const CircleAvatar(
                      radius: 23,
                      backgroundImage: AssetImage("assets/Bolt_Logo.png",),
                    )
                    //if app name == Uber present uber img
                        : const CircleAvatar(
                      radius: 23,
                      backgroundImage: AssetImage("assets/Uber_Logo.png",),
                    ),
                    title: Text(rideResultList[index].display_name),
                    subtitle: Text("${time.toInt()} min to arrive"),
                    trailing: Text(
                        "${rideResultList[index].estimate_price} SAR"),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  color: Colors.white,
                ),
              )
                  : const Center(
                child: Text("Sorry,There is no available rides right now :("),),
            );
          } // else
        } // else
      },
    );
  } // build

} // ResultScreen
