import 'package:flutter/material.dart';
import '../Models/UberPriceEstimates.dart';

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

    UberPriceEstimates priceEstimates = new UberPriceEstimates(start_latitude, start_longitude, end_latitude, end_longitude);
    Future<Map<String, dynamic>> priceEstimatesList = priceEstimates.getPrice();
    print(priceEstimatesList);

  }



  @override
  Widget build(BuildContext context) {
    getPriceEstimates();
    return new Scaffold(
    );
  }

} 


