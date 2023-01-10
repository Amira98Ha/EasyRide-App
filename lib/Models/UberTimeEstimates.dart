import 'Uber.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UberTimeEstimates {
  var start_latitude;
  var start_longitude;


  UberTimeEstimates(var start_latitude , var start_longitude){
    this.start_longitude = start_longitude;
    this.start_longitude = start_longitude;
  }

  Future<List> getTime() async {
    final timeFile = await rootBundle.loadString('json/UberTimeEstimates1.json');
    final List timeJson = jsonDecode(timeFile);
    return timeJson;
  }

}