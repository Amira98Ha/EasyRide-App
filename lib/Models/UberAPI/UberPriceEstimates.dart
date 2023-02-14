import 'package:easy_ride_app/Models/UberAPI/UberPrices.dart';
import 'Uber.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class UberPriceEstimates {
  var start_latitude;
  var start_longitude;
  var end_latitude;
  var end_longitude;
  List<UberPrices> pricesList = [];

  UberPriceEstimates() {}

  Future<List<UberPrices>> getPrice(var start_latitude, var start_longitude, var end_latitude, var end_longitude) async {
    var priceFile;
    var priceJson;

    // calculate distance
    double distanceInMeters = Geolocator.distanceBetween(start_latitude, start_longitude,
        end_latitude, end_longitude);

    // check distance
    if (distanceInMeters <= 10000) {
      // parsing json file
      priceFile = await rootBundle.loadString('json/UberPriceEstimates1.json');
      priceJson = jsonDecode(priceFile);
    }
    else if (distanceInMeters > 10000) {
      // parsing json file
      priceFile = await rootBundle.loadString('json/UberPriceEstimates2.json');
      priceJson = jsonDecode(priceFile);
    }

    // create list of UberPrices
    for (var i in priceJson['prices']) {
      UberPrices temp = UberPrices.fromJson(i);
      pricesList.add(temp);
    }

    return pricesList;
  }

}