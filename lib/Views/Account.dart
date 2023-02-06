import 'package:easy_ride_app/Views/MapScreen.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatelessWidget{

  MyAccount({Key? key}) : super(key: key);

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
              Text("My Account", style: TextStyle(fontSize: 25,
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
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container (
                          height: 37,
                          width: 37,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                            width: 3,
                              color: Colors.black12,
                            ),
                            color: Colors.green,
                          ), // BoxDecoration
                          child: Icon(Icons.edit, color: Colors .white,),
                        ),
                    ),
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
                  hintText: "should have username",
                  hintStyle: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black12,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 40),),
              TextField(
                decoration:InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 4),
                  labelText: "E-mail",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "should have E-mail",
                  hintStyle: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black12,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 40),),
              TextField(
                // obscureText: isPasswordTextField,
                decoration:InputDecoration(
                  // suffixIcon: isPass,
                  contentPadding: EdgeInsets.only(bottom: 4),

                  labelText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "should have Password",
                  // i have to make the password stars
                  hintStyle: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black12,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //cancel button
                  OutlinedButton(
                    onPressed: (){},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text('Cancel',
                    style: TextStyle(fontSize: 15,letterSpacing: 2,
                    color: Colors.black),),
                  ),
                  //save button
                  ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey ,
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                   ),
                    child: Text('Save',
                    style: TextStyle(fontSize: 15,letterSpacing: 2,
                        color: Colors.white),),
                  )
                ],

              ),
            ],
          ),
      ),
    ),
  );
}