

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

    );
  }
}
