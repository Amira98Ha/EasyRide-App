import 'package:easy_ride_app/Models/BoltAPI/BoltTimes.dart';

import 'Bolt.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class BoltTimeEstimates {
  var start_latitude;
  var start_longitude;
  List<BoltTimes> timesList = [];

  BoltTimeEstimates(){}

  Future<List<BoltTimes>> getTime(var start_latitude, var start_longitude) async {
    // parsing json file
    final timeFile = await rootBundle.loadString('json/UberTimeEstimates1.json');
    final timeJson =  jsonDecode(timeFile);

    // create list of BoltTimes
    for (var i in timeJson['times']) {
      BoltTimes temp = BoltTimes.fromJson(i);
      timesList.add(temp);
    }
    return timesList;
  }

}