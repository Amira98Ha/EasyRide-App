import 'package:flutter/material.dart';
import '../Models/UberPriceEstimates.dart';
import '../Models/UberTimeEstimates.dart';
import '../Models/Uber.dart';
import '../Models/BoltPriceEstimates.dart';
import '../Models/BoltTimeEstimates.dart';
import '../Models/Bolt.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();

}

class _ResultScreenState extends State<ResultScreen> {

  var start_latitude = 21.580948130893006;
  var start_longitude = 39.1806807119387;
  var end_latitude = 21.627725155960892;
  var end_longitude = 39.11108797417971;


  // Price Estimates for uber app
  void getUberPriceEstimates() async {

    Uber uberOpject = new Uber();
    Map<String, dynamic> priceEstimatesList = await uberOpject.uberPriceEstimates.getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
    var prices = priceEstimatesList["prices"];
    print(prices);

  }
  // Time Estimates for uber app
  void getUberTimeEstimates() async {

    Uber uberOpject = new Uber();
    Map<String, dynamic> timeEstimatesList = await uberOpject.uberTimeEstimates.getTime(start_latitude, start_longitude);
    var times = timeEstimatesList["times"];
    print(times);

  }
  // Price Estimates for bolt app
  void getBoltPriceEstimates() async {

    Bolt boltOpject = new Bolt();
    Map<String, dynamic> priceEstimatesList = await boltOpject.boltPriceEstimates.getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
    var prices = priceEstimatesList["prices"];
    print(prices);

  }
  // Time Estimates for bolt app
  void getBoltTimeEstimates() async {

    Bolt boltOpject = new Bolt();
    Map<String, dynamic> timeEstimatesList = await boltOpject.boltTimeEstimates.getTime(start_latitude, start_longitude);
    var times = timeEstimatesList["times"];
    print(times);

  }


  @override
  Widget build(BuildContext context) {
    getUberPriceEstimates() ;
    getUberTimeEstimates();
    getBoltPriceEstimates() ;
    getBoltTimeEstimates();

    return new Scaffold(
    );
  }

} 


