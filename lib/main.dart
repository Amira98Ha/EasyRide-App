import 'package:flutter/material.dart';

import 'Views/MapScreen.dart';

void main() {
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Ride App',
      home: MapScreen(),
    );
  }
}
