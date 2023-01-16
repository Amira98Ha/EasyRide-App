import 'Bolt.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class BoltTimeEstimates {
  var start_latitude;
  var start_longitude;

  BoltTimeEstimates(){}


  Future<Map<String, dynamic>> getTime(var start_latitude, var start_longitude) async {
    final timeFile = await rootBundle.loadString('json/BoltTimeEstimates1.json');
    final Map<String, dynamic> timeJson =  jsonDecode(timeFile);
    return timeJson;
  }

}