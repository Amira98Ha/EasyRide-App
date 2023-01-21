import '../Models/UberAPI/Uber.dart';
import '../Models/UberAPI/UberPrices.dart';
import '../Models/UberAPI/UberTimes.dart';
import '../Models/BoltAPI/Bolt.dart';
import '../Models/BoltAPI/BoltPrices.dart';
import '../Models/BoltAPI/BoltTimes.dart';

import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var start_latitude = 21.580948130893006;
  var start_longitude = 39.1806807119387;
  var end_latitude = 21.627725155960892;
  var end_longitude = 39.11108797417971;

  // for uber app
  Uber uberOpject = new Uber();
  List<UberPrices> uberPriceList = [];
  List<UberTimes> uberTimeList = [];

  // for bolt app
  Bolt boltOpject = new Bolt();
  List<BoltPrices> boltPriceList = [];
  List<BoltTimes> boltTimeList = [];

  // Price Estimates for uber app
  void getUberPriceEstimates() async {
    uberPriceList = await uberOpject.uberPriceEstimates
        .getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for uber app
  void getUberTimeEstimates() async {
    uberTimeList = await uberOpject.uberTimeEstimates
        .getTime(start_latitude, start_longitude);
  }

  // Price Estimates for bolt app
  void getBoltPriceEstimates() async {
    boltPriceList = await boltOpject.boltPriceEstimates
        .getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for bolt app
  void getBoltTimeEstimates() async {
    boltTimeList = await boltOpject.boltTimeEstimates
        .getTime(start_latitude, start_longitude);
  }

  @override
  Widget build(BuildContext context) {
    getUberPriceEstimates();
    getUberTimeEstimates();
    getBoltPriceEstimates();
    getBoltTimeEstimates();

    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Result"),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
        centerTitle: true,
      ),
      //Check if there is available rides or not
      body: uberPriceList.length > 0
          ? ListView.separated(
              itemCount: boltPriceList.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  leading: const CircleAvatar(
                    radius: 23,
                    backgroundImage: AssetImage("assets/Bolt_Logo.png",),
                  ),
                  title: Text(boltPriceList[index].display_name),
                  trailing: Text("${boltPriceList[index].estimate} ${boltPriceList[index].currency_code}"),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.white,
              ),
            )
          : const Center(child: Text("Sorry,There is no available rides right now :("),),
    );
  }
}
