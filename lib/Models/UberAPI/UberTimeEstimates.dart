import 'package:easy_ride_app/Models/UberAPI/UberTimes.dart';
import 'Uber.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class UberTimeEstimates {
  var start_latitude;
  var start_longitude;
  List<UberTimes> timesList = [];

  UberTimeEstimates(){}

  Future<List<UberTimes>> getTime(var start_latitude, var start_longitude) async {
    var timeFile;
    var timeJson;

    // calculate distance
    double distanceInMeters = Geolocator.distanceBetween(start_latitude, start_longitude,
        21.580948130893006, 39.1806807119387);

    // check distance
    if (distanceInMeters <= 5000) {
      // parsing json file
      timeFile = await rootBundle.loadString('json/UberTimeEstimates1.json');
      timeJson = jsonDecode(timeFile);
    }
    else if (distanceInMeters > 5000) {
      // parsing json file
      timeFile = await rootBundle.loadString('json/UberTimeEstimates2.json');
      timeJson = jsonDecode(timeFile);
    }

    // create list of UberTimes
    for (var i in timeJson['times']) {
      UberTimes temp = UberTimes.fromJson(i);
      timesList.add(temp);
    }
    return timesList;
  }

}