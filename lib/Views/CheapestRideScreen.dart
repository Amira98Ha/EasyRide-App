

import 'package:flutter/material.dart';
import '../Controllers/ResultController.dart';

class CheapestRideScreen  extends StatefulWidget {


  CheapestRideState createState() => CheapestRideState();
}

class CheapestRideState extends State<CheapestRideScreen>
{




  @override
  Widget build(BuildContext context) {

    ResultControllerState.priceCompare();

    return Scaffold(
      //Check if there is available rides or not
      body: ResultControllerState.rideResultList.length > 0
          ? ListView.separated(
        itemCount: ResultControllerState.rideResultList.length,
        itemBuilder: (context, int index) {
          num time = ResultControllerState.rideResultList[index].estimate_time/60;
          return ListTile(
            //if app name == Bolt present bolt img
            leading:  ResultControllerState.rideResultList[index].app_name.toString() == "Bolt" ?
            const CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage("assets/Bolt_Logo.png",),
            )
            //if app name == Uber present uber img
                : const CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage("assets/Uber_Logo.png",),
            ),
            title: Text(ResultControllerState.rideResultList[index].display_name),
            subtitle: Text("${time.toInt()} min to arrive"),
            trailing: Text("${ResultControllerState.rideResultList[index].estimate_price} SAR"),
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
