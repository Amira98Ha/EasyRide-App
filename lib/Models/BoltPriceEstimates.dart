import 'Bolt.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class BoltPriceEstimates {
  var start_latitude;
  var start_longitude;
  var end_latitude;
  var end_longitude;

  BoltPriceEstimates() {}



  Future<Map<String, dynamic>> getPrice(var start_latitude, var start_longitude, var end_latitude, var end_longitude) async {
    final priceFile = await rootBundle.loadString('json/BoltPriceEstimates1.json');
    final Map<String, dynamic> priceJson =  jsonDecode(priceFile);
    return priceJson;
  }

}