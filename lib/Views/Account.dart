import 'package:easy_ride_app/Views/MapScreen.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatelessWidget{
  MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavigationDrawer(),
    appBar: AppBar(
    title: const Text("My Account"),
      backgroundColor: Colors.black,
    ),
  );
}