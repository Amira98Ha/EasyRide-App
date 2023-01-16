import '../Models/UberAPI/Uber.dart';
import '../Models/UberAPI/UberPrices.dart';
import '../Models/UberAPI/UberTimes.dart';
import '../Models/BoltAPI/Bolt.dart';
import '../Models/BoltAPI/BoltPrices.dart';
import '../Models/BoltAPI/BoltTimes.dart';

import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();

}

//
//

class _ResultScreenState extends State<ResultScreen> {

  var start_latitude = 21.580948130893006;
  var start_longitude = 39.1806807119387;
  var end_latitude = 21.627725155960892;
  var end_longitude = 39.11108797417971;

  // for uber app
  Uber uberOpject = new Uber();
  List<UberPrices> uberPriceList = [];
  List<UberTimes> uberTimeList = [];

  // for bolt app
  Bolt boltOpject = new Bolt();
  List<BoltPrices> boltPriceList = [];
  List<BoltTimes> boltTimeList = [];


  // test for elaf and amera
  void test() {
    List<String> testList = [];
    for (var i in uberPriceList) {
      testList.add(uberPriceList[0].currency_code);
    }

    print("----------------");
    print(testList);
    print("----------------");
  }

  // Price Estimates for uber app
  void getUberPriceEstimates() async {
    uberPriceList = await uberOpject.uberPriceEstimates.getPrice(start_latitude, start_longitude, end_latitude, end_longitude);

    // test
    print("----------------");
    print(uberPriceList[0].display_name);
    print("----------------");
  }
  // Time Estimates for uber app
  void getUberTimeEstimates() async {
    uberTimeList = await uberOpject.uberTimeEstimates.getTime(start_latitude, start_longitude);
  }

  // Price Estimates for bolt app
  void getBoltPriceEstimates() async {
    boltPriceList = await boltOpject.boltPriceEstimates.getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for bolt app
  void getBoltTimeEstimates() async {
    boltTimeList = await boltOpject.boltTimeEstimates.getTime(start_latitude, start_longitude);
  }


  @override
  Widget build(BuildContext context) {
    getUberPriceEstimates() ;
    getUberTimeEstimates();
    // for test
    test();
    getBoltPriceEstimates() ;
    getBoltTimeEstimates();

    return new Scaffold(
    );
  }

} 


