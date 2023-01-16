import 'package:easy_ride_app/Models/UberAPI/UberTimes.dart';

import 'Uber.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UberTimeEstimates {
  var start_latitude;
  var start_longitude;
  List<UberTimes> timesList = [];

  UberTimeEstimates(){}

  Future<List<UberTimes>> getTime(var start_latitude, var start_longitude) async {
    // parsing json file
    final timeFile = await rootBundle.loadString('json/UberTimeEstimates1.json');
    final timeJson =  jsonDecode(timeFile);

    // create list of UberTimes
    for (var i in timeJson['times']) {
      UberTimes temp = UberTimes.fromJson(i);
      timesList.add(temp);
    }
    return timesList;
  }

}