import 'dart:math';

import '../Models/UberAPI/Uber.dart';
import '../Models/UberAPI/UberPrices.dart';
import '../Models/UberAPI/UberTimes.dart';
import '../Models/BoltAPI/Bolt.dart';
import '../Models/BoltAPI/BoltPrices.dart';
import '../Models/BoltAPI/BoltTimes.dart';
import '../Models/RideResult.dart';

class SearchController {
  var start_latitude = 21.580948130893006;
  var start_longitude = 39.1806807119387;
  var end_latitude = 21.627725155960892;
  var end_longitude = 39.11108797417971;

  // to display result
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

  Future<List<RideResult>> searchRides() async {
    await getUberPriceEstimates();
    await getUberTimeEstimates();
    await getBoltPriceEstimates();
    await getBoltTimeEstimates();
    print("UBER display---------");
    joinList("Uber", uberPriceList, uberTimeList);
    print("BOLT display---------");
    joinList("Bolt", boltPriceList, boltTimeList);
    print("PRICE display---------");

    return rideResultList;
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

  String optimalChoice(List<RideResult> list) {
    //sort time descending
    list.sort((a, b) => a.estimate_time.compareTo(b.estimate_time));
    // get less time
    int lessTime = list[0].estimate_time;

    //sort price ascending
    list.sort((a, b) => a.estimate_price.compareTo(b.estimate_price));
    // get less price
    int lessPrice = list[0].low_estimate;

    // set index 0 as optimal
    optimalChoiceId = list[0].product_id;
    double lessDistance = calculateDistance(list[0].low_estimate, lessPrice,
        list[0].estimate_time, lessTime);

    // find optimal
    for (var i = 0; i < list.length; i++) {
      double distance = calculateDistance(list[i].low_estimate, lessPrice,
          list[i].estimate_time, lessTime);

      if (distance < lessDistance) {
        lessDistance = distance;
        optimalChoiceId = list[i].product_id;
      }
    }

    // print result
    print("optimalChoiceId = " + optimalChoiceId);
    return optimalChoiceId;
  }

  double calculateDistance(int x1, int x2, int y1, int y2) {
    // Distance Between Two Points
    return sqrt(pow((x2 - x1),2) + pow((y2 - y1),2));
  }

  // sort list in term of cheapest
  List<RideResult> priceCompare(List<RideResult> list) {
    List<RideResult> newList = List.from(list);
    //sort price ascending
    newList.sort((a, b) => a.estimate_price.compareTo(b.estimate_price));
    return newList;
  }

  // sort list in term of fastest
  List<RideResult> timeCompare(List<RideResult> list) {
    List<RideResult> newList = List.from(list);
    //sort time descending
    newList.sort((a, b) => a.estimate_time.compareTo(b.estimate_time));
    return newList;
  }

  // filter standard rides
  List<RideResult> standardRides(List<RideResult> list) {
    List<RideResult> newList = [];

    for (var i = 0; i < list.length; i++) {
      if ((list[i].display_name.toString() != "VIP") &&
          (list[i].display_name.toString() != "XL") &&
          (list[i].display_name.toString() != "BLACK") &&
          (list[i].display_name.toString() != "uberXL")) {
        newList.add(list[i]);
      }
    }

    return newList;
  }

  // filter family rides
  List<RideResult> familyRides(List<RideResult> list) {
    List<RideResult> newList = [];

    for (var i = 0; i < list.length; i++) {
      if ((list[i].display_name.toString() == "XL") ||
          (list[i].display_name.toString() == "uberXL")) {
        newList.add(list[i]);
      }
    }

    return newList;
  }

  // filter luxury rides
  List<RideResult> luxuryRides(List<RideResult> list) {
    List<RideResult> newList = [];

    for (var i = 0; i < list.length; i++) {
      if ((list[i].display_name.toString() == "VIP") ||
          (list[i].display_name.toString() == "BLACK")) {
        newList.add(list[i]);
      }
    }

    return newList;
  }

}