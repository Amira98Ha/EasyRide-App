import 'package:easy_ride_app/Models/BoltAPI/BoltTimes.dart';
import 'Bolt.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class BoltTimeEstimates {
  var start_latitude;
  var start_longitude;
  List<BoltTimes> timesList = [];

  BoltTimeEstimates(){}

  Future<List<BoltTimes>> getTime(var start_latitude, var start_longitude) async {
    var timeFile;
    var timeJson;

    // calculate distance
    double distanceInMeters = Geolocator.distanceBetween(start_latitude, start_longitude,
        21.580948130893006, 39.1806807119387);

    // check distance
    if (distanceInMeters <= 5000) {
      // parsing json file
      timeFile = await rootBundle.loadString('json/BoltTimeEstimates1.json');
      timeJson = jsonDecode(timeFile);
    }
    else if (distanceInMeters > 5000) {
      // parsing json file
      timeFile = await rootBundle.loadString('json/BoltTimeEstimates2.json');
      timeJson = jsonDecode(timeFile);
    }

    // create list of BoltTimes
    for (var i in timeJson['times']) {
      BoltTimes temp = BoltTimes.fromJson(i);
      timesList.add(temp);
    }
    return timesList;
  }

}