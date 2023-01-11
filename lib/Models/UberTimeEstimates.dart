import 'Uber.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UberTimeEstimates {
  var start_latitude;
  var start_longitude;

  UberTimeEstimates(){}

  // UberTimeEstimates(var start_latitude , var start_longitude){
  //   this.start_longitude = start_longitude;
  //   this.start_longitude = start_longitude;
  // }
  Future<Map<String, dynamic>> getTime(var start_latitude, var start_longitude) async {
    final timeFile = await rootBundle.loadString('json/UberTimeEstimates1.json');
    final Map<String, dynamic> timeJson =  jsonDecode(timeFile);
    // List<dynamic> data = priceJson["prices"];
    return timeJson;
  }

}