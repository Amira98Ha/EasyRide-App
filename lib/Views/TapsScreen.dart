import 'package:easy_ride_app/Views/BookScreen.dart';
import 'package:flutter/material.dart';

import '../Controllers/SearchController.dart';
import '../Models/RideResult.dart';
import 'BookScreen.dart';

class TapsScreen extends StatefulWidget {
  TapsScreenState createState() => TapsScreenState();
}

class TapsScreenState extends State<TapsScreen> {
  late Future<void> _future;

  // to display result
  SearchController searchController = SearchController();
  List<RideResult> rideResultList = [];
  List<RideResult> priceRideResultList = [];
  List<RideResult> timeRideResultList = [];
  var optimalChoiceId = "";

  @override
  void initState() {
    _future = searchRides();
    super.initState();
  }

  Future<void> searchRides() async {
    // get full ride result list
    rideResultList = await searchController.searchRides();
    // get optimal choice
    optimalChoiceId = await searchController.optimalChoice(rideResultList);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future, // function to search for rides
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // if searchRides() has not finish
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: new CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 2,
          ),);
        }
        else {
          // if searchRides() has error
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          else {
            //Display Nested Tap Bar
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Rides Result"),
                  backgroundColor: Colors.black,
                  titleTextStyle: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
                  centerTitle: true,
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    tabs: <Widget>[
                      //1-tap
                      Tab(
                        child: Text(
                          "Cheapest",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand Bold",
                          ),
                        ),
                      ),

                      //2-tap
                      Tab(
                        child: Text(
                          "Fastest",
                          style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                        ),
                      ),
                    ],
                  ),
                ),

                body: TabBarView(
                  children: [
                    SortRide("Cheapest"),
                    SortRide("Fastest"),
                  ],
                ),
              ),
            );
          } // else
        } // else
      }, // builder
    );
  } // build


  SortRide(String kind) {
    List<RideResult> sortList = [];

    // filter based on (All,Standard,Family,Luxury)
    if (kind == "Cheapest") {
      sortList = searchController.priceCompare(rideResultList);
    }
    else if (kind == "Fastest") {
      sortList = searchController.timeCompare(rideResultList);
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Colors.black,
              tabs: <Widget>[
                //1- Tap
                Tab(
                  child: Text(
                    "All",
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                //2- Tap
                Tab(
                  child: Text(
                    "Standard",
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                //3- Tap
                Tab(
                  child: Text(
                    "Family",
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                //4- Tap
                Tab(
                  child: Text(
                    "Luxury",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            FilterRide(sortList, "All"),
            FilterRide(sortList, "Standard"),
            FilterRide(sortList, "Family"),
            FilterRide(sortList, "Luxury"),
          ],
        ),
      ),
    );
  } // SortRide

  FilterRide(List<RideResult> sortList, String kind) {
    List<RideResult> filterList = [];

    // filter based on (All,Standard,Family,Luxury)
    if (kind == "All") {
      filterList = sortList;
    }
    else if (kind == "Standard") {
      filterList = searchController.standardRides(sortList);
    }
    else if (kind == "Family") {
      filterList = searchController.familyRides(sortList);
    }
    else if (kind == "Luxury") {
      filterList = searchController.luxuryRides(sortList);
    }

    return Scaffold(
      //Check if there is available rides or not
      body: filterList.isNotEmpty
          ? ListView.builder(
        itemCount: filterList.length,
        itemBuilder: (context, int index) {
          num time = filterList[index].estimate_time / 60;
          return ListTile(
            //if app name == Bolt present bolt img
            leading: filterList[index].app_name.toString() == "Bolt"
                ? const CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage(
                "assets/Bolt_Logo.png",
              ),
            )
            //if app name == Uber present uber img
                : const CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage(
                "assets/Uber_Logo.png",
              ),
            ),
            title: Text(filterList[index].display_name),
            subtitle: filterList[index].product_id == optimalChoiceId ?
            Text("${time.toInt()} min to arrive \nOptimal choice") :
            Text("${time.toInt()} min to arrive"),
            trailing: Text("${filterList[index].estimate_price} SAR"),
            isThreeLine: filterList[index].product_id == optimalChoiceId ? true : false,
            tileColor: filterList[index].product_id == optimalChoiceId ? Colors.black12 : null,
            shape: filterList[index].product_id == optimalChoiceId ?
            BeveledRectangleBorder(side: BorderSide(color:Colors.grey, width: 1),)
                : null,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BookScreen(rideResult: rideResultList[index], time: time)));
            },
          );

          // return SizedBox(height: 0); Elaf????
        },
        // separatorBuilder: (BuildContext context, int index) =>
        // const Divider(
        //   color: Colors.white,
        // ),
      )
          : const Center(
        child: Text("Sorry,There is no available rides right now :("),
      ),
    );
  } // FilterRide

}
