import 'package:flutter/material.dart';
import '../Models/UberPriceEstimates.dart';
import '../Models/Uber.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();

}

class _ResultScreenState extends State<ResultScreen> {
  void getPriceEstimates() async {
    var start_latitude = 21.580948130893006;
    var start_longitude = 39.1806807119387;
    var end_latitude = 21.627725155960892;
    var end_longitude = 39.11108797417971;

    Uber uberOpject = new Uber();
    Map<String, dynamic> priceEstimatesList = await uberOpject.uberPriceEstimates.getPrice(start_latitude, start_longitude, end_latitude, end_longitude);

    var prices = priceEstimatesList["prices"];
    print(prices);

  }
  void getTimeEstimates() async {
    var start_latitude = 21.580948130893006;
    var start_longitude = 39.1806807119387;

    Uber uberOpject = new Uber();
    Map<String, dynamic> timeEstimatesList = await uberOpject.uberTimeEstimates.getTime(start_latitude, start_longitude);

    var times = timeEstimatesList["times"];
    print(times);

  }


  @override
  Widget build(BuildContext context) {
    getPriceEstimates();
    getTimeEstimates();
    return new Scaffold(
    );
  }

} 


