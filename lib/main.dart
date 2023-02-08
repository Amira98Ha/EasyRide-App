import 'package:easy_ride_app/Views/Profile.dart';
import 'package:easy_ride_app/Views/SearchScreen.dart';
import 'package:easy_ride_app/Views/SignUpScreen.dart';
import 'package:easy_ride_app/Views/TapsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Views/MapScreen.dart';
import 'Views/ResultScreen.dart';
import 'Views/SignInScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Ride App',
      home: SignInScreen(),
    );
  }
}
