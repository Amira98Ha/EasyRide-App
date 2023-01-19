

import '../Models/UberAPI/Uber.dart';
import '../Models/UberAPI/UberPrices.dart';
import '../Models/UberAPI/UberTimes.dart';
import '../Models/BoltAPI/Bolt.dart';
import '../Models/BoltAPI/BoltPrices.dart';
import '../Models/BoltAPI/BoltTimes.dart';

import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  @override
  ResultScreenState createState() => ResultScreenState();

}

//
//

class ResultScreenState extends State<ResultScreen> {

   var start_latitude = 21.580948130893006;
   var start_longitude = 39.1806807119387;
   var end_latitude = 21.627725155960892;
   var end_longitude = 39.11108797417971;

  // for uber app
  Uber uberOpject = new Uber();
  static List<UberPrices> uberPriceList = [];
  static List<UberTimes> uberTimeList = [];

  // for bolt app
  Bolt boltOpject = new Bolt();
   static List<BoltPrices> boltPriceList = [];
   static List<BoltTimes> boltTimeList = [];


  // test for elaf and amera
  void test() {
    List<String> testList = [];
    for (var i in uberPriceList) {
      testList.add(uberPriceList[0].currency_code);
    }

    print("----------------");
    print(testList);
    print("----------------");
  }

  // Price Estimates for uber app
  void getUberPriceEstimates() async {
    uberPriceList = await uberOpject.uberPriceEstimates.getPrice(start_latitude, start_longitude, end_latitude, end_longitude);

    // test
    print("----------------");
    print(uberPriceList[0].display_name);
    print("----------------");
  }
  // Time Estimates for uber app
  void getUberTimeEstimates() async {
    uberTimeList = await uberOpject.uberTimeEstimates.getTime(start_latitude, start_longitude);
  }

  // Price Estimates for bolt app
  void getBoltPriceEstimates() async {
    boltPriceList = await boltOpject.boltPriceEstimates.getPrice(start_latitude, start_longitude, end_latitude, end_longitude);
  }

  // Time Estimates for bolt app
  void getBoltTimeEstimates() async {
    boltTimeList = await boltOpject.boltTimeEstimates.getTime(start_latitude, start_longitude);
  }





  @override
  Widget build(BuildContext context) {
    getUberPriceEstimates() ;
    getUberTimeEstimates();
    // for test
    test();
    getBoltPriceEstimates() ;
    getBoltTimeEstimates();

    return  DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
        title: const Text('Results'),
    leading: GestureDetector(
    onTap: (){
    //handling the action for tap
    },
    ),

        /*body: ListView(
          children: [
            *//*TabBarView(children:
            OptimalChoice()
            ),*//*
            getResponse(),*/
        bottom: const TabBar(tabs: <Widget>[
              Tab(
                text:'Optimal choice',
              ),

              Tab(
                text:'Fastest Ride',
              ),
              Tab(
                  text:'cheapest Ride',

              ),

            ]),
/*
            ListTile(
              title: Text(uberPriceList[0].localized_display_name),
              isThreeLine:
              true, //will fix the alignment if the subtitle text is too big
              subtitle: Text(uberTimeList[0].estimate.toString()),
              leading: Image.asset("assets/Uber.png",height: 50,width: 50,),
              trailing:Text(uberPriceList[0].estimate),
            )*/
        ),
        body: ListView(
          children: [
            TabBarView(children:
            [
              getResponse(),
              OptimalChoice(),

            ]


            ),

          ],

        ),




      ),);
  }

}

/*    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children:<Widget> [
            Center(child:
            Container(
              height: 300.0,
              width: 300.0,
              color: Colors.blue[50],
              padding: EdgeInsets.all(15),
              child: ListView(
                children: [
                  Image.asset("assets/car.png",height: 150, width: 150,),
                  Text(uberPriceList[0].localized_display_name,style: TextStyle(fontWeight: FontWeight.bold, height:5, fontSize: 10),),



                ],
              ),
            ),)
          ],
        ),
      )


    );*/
  //testinggggg

class getResponse extends StatelessWidget {
  const getResponse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(ResultScreenState.uberPriceList[0].localized_display_name ),
    isThreeLine:
    true, //will fix the alignment if the subtitle text is too big
    subtitle: Text(ResultScreenState.uberTimeList[0].estimate.toString()),
    leading: Image.asset("assets/Uber.png",height: 50,width: 50,),
    trailing:Text(ResultScreenState.uberPriceList[0].estimate),
    );}
}
class OptimalChoice extends StatelessWidget {
  const OptimalChoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("optimaaaaaaaaaal"),

    );

  }
}






