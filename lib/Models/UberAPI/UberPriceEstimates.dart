import 'Uber.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UberPriceEstimates {
  var start_latitude;
  var start_longitude;
  var end_latitude;
  var end_longitude;

  UberPriceEstimates() {}

 

  Future<Map<String, dynamic>> getPrice(var start_latitude, var start_longitude, var end_latitude, var end_longitude) async {
    final priceFile = await rootBundle.loadString('json/UberPriceEstimates1.json');
    final Map<String, dynamic> priceJson =  jsonDecode(priceFile);
    // List<dynamic> data = priceJson["prices"];
    return priceJson;
  }

}