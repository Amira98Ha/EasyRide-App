import 'package:easy_ride_app/Views/MapScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {

  @override
  _editProfileState createState()=> _editProfileState();
}
class _editProfileState extends State<MyProfile>{

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String userName = "";
  String email = "";
  String password = "";
  String PhoneNumber = "";


  final _userNameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserInfo().whenComplete(() {
      _userNameFieldController.text = userName;
      _emailFieldController.text = email;
      // _passwordFieldController.text = password;
      phoneController.text = PhoneNumber;

    });
  }

  getUserInfo() async {
    // if user sign in
    User? user = await FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance.collection("users");
    final query = userRef.doc(user?.uid).get();

    query.then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userName = documentSnapshot.get("name").toString();
        email = documentSnapshot.get("email").toString();
        PhoneNumber = documentSnapshot.get("phone").toString();
      } else {
        print('Document does not exist on the database');
      }
    });
  }


  saveProfile() async {
      FirebaseAuth.instance.userChanges();
      //DatabaseServices.updateUserData(user);
    }




  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavigationDrawer(),
    appBar: AppBar(
    title: const Text(""),
      elevation: 1,
      backgroundColor: Colors.black,
    ),
    //Box Details Style and content
    body: Container(
      padding: EdgeInsets.only(left: 20,right: 10,top: 30),
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: ListView(
            children: [
              Text("My Profile", style: TextStyle(fontSize: 25,
                  fontWeight: FontWeight.w600,),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                       boxShadow: [
                         BoxShadow(
                           spreadRadius: 2,color: Colors.black45.withOpacity(0.1),
                           blurRadius: 11,
                           offset: Offset(0, 12)
                         ),
                       ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWIVEirM1RHGgkdTOQ9090lNEG0_q_yJFkCw&usqp=CAU'),
                        ),
                      ),
                    ),
                    // Positioned(
                    //     bottom: 0,
                    //     right: 0,
                    //     child: Container (
                    //       height: 37,
                    //       width: 37,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         border: Border.all(
                    //         width: 3,
                    //           color: Colors.black12,
                    //         ),
                    //         color: Colors.green,
                    //       ), // BoxDecoration
                    //       child: Icon(Icons.edit, color: Colors .white,),
                    //     ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 37,
              ),
              TextField(
                decoration:InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 4),
                  labelText: "UserName",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: userName,
                  hintStyle: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black12,
                  ),
                ),
                controller: _userNameFieldController,
              ),
              Padding(padding: EdgeInsets.only(bottom: 40),),
              TextField(
                decoration:InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 4),
                  labelText: "E-mail",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: email,
                  hintStyle: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black12,
                  ),
                ),
                controller: _emailFieldController,
              ),
              Padding(padding: EdgeInsets.only(bottom: 40),),
              TextField(
                decoration:InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 4),
                  labelText: "Phone Number",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: PhoneNumber,
                  hintStyle: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black12,
                  ),
                ),
                controller: phoneController,

              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
      ),
    ),
  );
}