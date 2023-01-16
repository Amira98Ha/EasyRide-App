import 'package:easy_ride_app/Models/BoltAPI/BoltPrices.dart';

import 'Bolt.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class BoltPriceEstimates {
  var start_latitude;
  var start_longitude;
  var end_latitude;
  var end_longitude;
  List<BoltPrices> pricesList = [];

  BoltPriceEstimates() {}

  Future<List<BoltPrices>> getPrice(var start_latitude, var start_longitude, var end_latitude, var end_longitude) async {
    // parsing json file
    final priceFile = await rootBundle.loadString('json/BoltPriceEstimates1.json');
    final priceJson = jsonDecode(priceFile);

    // create list of BoltPrices
    for (var i in priceJson['prices']) {
      BoltPrices temp = BoltPrices.fromJson(i);
      pricesList.add(temp);
    }

    return pricesList;
  }

}