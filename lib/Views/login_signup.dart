import 'package:easy_ride_app/Views/MapScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'reusable_widgets/progressDialog.dart';
import 'reusable_widgets/reusable_widget.dart';

class LoginSignUp extends StatefulWidget {


  @override
  _LoginSignUpState createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {

  final userRef = FirebaseFirestore.instance.collection("users");

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool signUpPage = false;
  String btnText = "SignIn";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: navigationOption(),
              ),
              SizedBox(height: 30,),
        logoWidget("assets/logo1-ai.png"),
              SizedBox(height: 20,),
              Visibility(
                visible: signUpPage,
                child: Column(
                  children: [
                    userNameTextField(),
                    phoneTextField(),
                  ],
                ),
              ),

              emailTextField(),
              passwordTextField(),
              SizedBox(height: 20,),
              signInSignUp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget navigationOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              signUpPage =true;
              btnText = "SignUp";
            });
          },
          child: Text("SignUp", style: TextStyle(color: Colors.grey[700],
              fontSize: 25),),
        ),
        InkWell(
          onTap: () {
            setState(() {
              signUpPage = false;
              btnText = "SignIn";
            });


          },

          child: Text("SignIn", style: TextStyle(color: Colors.grey[700],
              fontSize: 25),),
        ),
      ],
    );
  }



  Widget userNameTextField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        decoration: kBoxDecor,
        child: TextFormField(
          controller: userNameController,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black, fontFamily: 'Opensans'),
          decoration:InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.account_circle, color: Colors.black,),
            hintText: "Enter your username",
          ),
        ),
      ),
    );
  }

  Widget phoneTextField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        decoration: kBoxDecor,
        child: TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          style: TextStyle(color: Colors.black, fontFamily: 'Opensans'),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.phone, color: Colors.black,),
            hintText: "Enter your phone number",
          ),
        ),
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        decoration: kBoxDecor,
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black, fontFamily: 'Opensans'),
          decoration:InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.email, color: Colors.black,),
            hintText: "Enter you Email",
          ),
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        decoration: kBoxDecor,
        child: TextFormField(
          controller: passwordController,
          keyboardType: TextInputType.text,
          obscureText: true,
          style: TextStyle(color: Colors.black, fontFamily: 'Opensans'),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.lock, color: Colors.black,),
            hintText: "Enter you password",
          ),
        ),
      ),
    );
  }

  Widget signInSignUp(){
    return ElevatedButton(
        onPressed: (){
          (signUpPage)
              ? _register()
              : _login();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(btnText, style: TextStyle(fontSize: 24),),
        ));
  }

  final FirebaseAuth  _auth = FirebaseAuth.instance;

  void _register() async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Registering, please wait...");
        });

    final User? user = (
        await _auth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
            .catchError((errMsg){
          Navigator.pop(context);
          displayToastMsg(context, "$errMsg", "Error");
          print("Our Error message: $errMsg");
        })
    ).user;
    if(user != null){
      userRef.doc(user.uid).set({
        "name" : userNameController.text.trim(),
        "email" : emailController.text.trim(),
        "phone" : phoneController.text.trim()
      })
          .then((value) => null)
          .catchError((onError){

      });
      Navigator.pop(context);
      displayToastMsg(context, "Congratulations, account created", "Success");
      print("User created successfly");
      setState(() {
        signUpPage = false;

        btnText = "Login";
      });
    }else {
      Navigator.pop(context);
      displayToastMsg(context, "User account creation failed", "Failed");
      print("User account creation failed");
    }
  }

  void _login() async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Verifying Sign In, please wait...");
        });

    final User? user = (
        await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
            .catchError((errMsg) {
          Navigator.pop(context);
          displayToastMsg(context, "$errMsg", "Error");
          print("Our Error message: $errMsg");
        })
    ).user;
    if (user != null) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)
      => MapScreen()));
      print("Sign In Successful");
    } else {
      Navigator.pop(context);
      displayToastMsg(context, "Sign In failed", "Failed");
      print("Sign In failed");
    }
  }



  final kBoxDecor = BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(0, 2),
        )
      ]
  );

}

Future<void> displayToastMsg(BuildContext context, String msg, String title1) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("$title1"),
          content: Text("$msg"),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
