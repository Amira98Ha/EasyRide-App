

import 'package:easy_ride_app/Views/SignInScreen.dart';
import 'package:easy_ride_app/Views/reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'MapScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController= TextEditingController();
  TextEditingController _emailTextController= TextEditingController();
  TextEditingController _userNameTextController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          " Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height*0.2, 20, 0),
          child: Column(
            children: <Widget> [
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter UserName", Icons.person_outline, false,
                  _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Email", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              signInSignUpButton(context, false, (){
                FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text,
                    password: _passwordTextController.text)
                    .then((value){
                      print("Created new account");
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}");
                });

              })
            ],
          ),
        ),),
      ),
    );
  }
}
