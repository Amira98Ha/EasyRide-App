import 'package:easy_ride_app/Views/MapScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<MyProfile> {
  late Future<void> _future;

  String userName = "";
  String email = "";
  String PhoneNumber = "";

  final _userNameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    _future = getUserInfo();
    super.initState();
  }

  Future<void> getUserInfo() async {
    // if user sign in
    User? user = await FirebaseAuth.instance.currentUser;
    // get all users information
    final userRef = await FirebaseFirestore.instance.collection("users");
    // get user information
    final query = userRef.doc(user?.uid).get();

    // get fields
    query.then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userName = documentSnapshot.get("name").toString();
        email = documentSnapshot.get("email").toString();
        PhoneNumber = documentSnapshot.get("phone").toString();
        _userNameFieldController.text = userName;
        _emailFieldController.text = email;
        phoneController.text = PhoneNumber;
      }
      else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future, // function to search for rides
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // if searchRides() has not finish
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: new CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 2,
            ),
          );
        }
        else {
          // if searchRides() has error
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            return Scaffold(
              drawer: NavigationDrawer(),
              appBar: AppBar(
                title: const Text(""),
                elevation: 1,
                backgroundColor: Colors.black,
              ),
              //Box Details Style and content
              body: Container(
                padding: EdgeInsets.only(left: 20, right: 10, top: 30),
                child: GestureDetector(
                  onTap: FocusScope.of(context).unfocus,
                  child: ListView(
                    children: [
                      Text(
                        "My Profile",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
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
                                      spreadRadius: 2,
                                      color: Colors.black45.withOpacity(0.1),
                                      blurRadius: 11,
                                      offset: Offset(0, 12)),
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWIVEirM1RHGgkdTOQ9090lNEG0_q_yJFkCw&usqp=CAU'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 37,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 4),
                          labelText: "UserName",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: userName,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black12,
                          ),
                        ),
                        controller: _userNameFieldController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 40),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 4),
                          labelText: "E-mail",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: email,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black12,
                          ),
                        ),
                        controller: _emailFieldController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 40),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 4),
                          labelText: "Phone Number",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: PhoneNumber,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
          } // else
        } // else
      }, // builder
    );
  } // build
}
