import 'package:easy_ride_app/Models/BoltAPI/BoltPrices.dart';

import 'Bolt.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class BoltPriceEstimates {
  var start_latitude;
  var start_longitude;
  var end_latitude;
  var end_longitude;
  List<BoltPrices> pricesList = [];

  BoltPriceEstimates() {}

  Future<List<BoltPrices>> getPrice(var start_latitude, var start_longitude, var end_latitude, var end_longitude) async {
    var priceFile;
    var priceJson;

    // calculate distance
    double distanceInMeters = Geolocator.distanceBetween(start_latitude, start_longitude,
        end_latitude, end_longitude);

    // check distance
    if (distanceInMeters <= 10000) {
      // parsing json file
      priceFile = await rootBundle.loadString('json/BoltPriceEstimates2.json');
      priceJson = jsonDecode(priceFile);
    }
    else if (distanceInMeters > 10000) {
      // parsing json file
      priceFile = await rootBundle.loadString('json/BoltPriceEstimates2.json');
      priceJson = jsonDecode(priceFile);
    }

    // create list of BoltPrices
    for (var i in priceJson['prices']) {
      BoltPrices temp = BoltPrices.fromJson(i);
      pricesList.add(temp);
    }

    return pricesList;
  }

}