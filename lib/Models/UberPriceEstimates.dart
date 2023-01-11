import 'Uber.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UberPriceEstimates {
  var start_latitude;
  var start_longitude;
  var end_latitude;
  var end_longitude;

  UberPriceEstimates() {}

  // UberPriceEstimates(var start_latitude, var start_longitude, var end_latitude, var end_longitude) {
  //   this.start_latitude = start_latitude;
  //   this.start_longitude = start_longitude;
  //   this.end_latitude = end_latitude;
  //   this.end_longitude = end_longitude;
  // }

  Future<Map<String, dynamic>> getPrice(var start_latitude, var start_longitude, var end_latitude, var end_longitude) async {
    final priceFile = await rootBundle.loadString('json/UberPriceEstimates1.json');
    final Map<String, dynamic> priceJson =  jsonDecode(priceFile);
    // List<dynamic> data = priceJson["prices"];
    return priceJson;
  }

}