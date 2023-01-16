import 'package:easy_ride_app/Models/UberAPI/UberPrices.dart';

import 'Uber.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UberPriceEstimates {
  var start_latitude;
  var start_longitude;
  var end_latitude;
  var end_longitude;
  List<UberPrices> pricesList = [];

  UberPriceEstimates() {}

  Future<List<UberPrices>> getPrice(var start_latitude, var start_longitude, var end_latitude, var end_longitude) async {
    // parsing json file
    final priceFile = await rootBundle.loadString('json/UberPriceEstimates1.json');
    final priceJson = jsonDecode(priceFile);

    // create list of UberPrices
    for (var i in priceJson['prices']) {
      UberPrices temp = UberPrices.fromJson(i);
      pricesList.add(temp);
    }

    return pricesList;
  }

}