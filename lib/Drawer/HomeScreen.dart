import 'package:cakey_vendor/CommonClass/AppBar.dart';
import 'package:flutter/material.dart';

import '../CommonClass/AlertsAndColors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //alert and color
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.22;


    return Scaffold(
      appBar: AppBars().myAppBar(),
      body: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 170,
                            decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue, width: 2)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    // height: 80,
                                    // width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Image(
                                      height: 60,
                                      width: 60,
                                      image: AssetImage("assets/images/orderlist.png"),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text("ORDER LIST",
                                  style: TextStyle(
                                    color:alertsAndColors.darkBlue,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Container(
                            height: 170,
                            decoration: BoxDecoration(
                                color: Colors.pink[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.red, width: 2)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    // height: 80,
                                    // width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Image(
                                      height: 60,
                                      width: 60,
                                      image: AssetImage("assets/images/orderlist.png"),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text("CAKE LIST",
                                    style: TextStyle(
                                        color:alertsAndColors.darkBlue,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 170,
                            decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.orange, width: 2)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    // height: 80,
                                    // width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Image(
                                      height: 60,
                                      width: 60,
                                      image: AssetImage("assets/images/addcake.png"),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text("ADD CAKE",
                                    style: TextStyle(
                                        color:alertsAndColors.darkBlue,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Container(
                            height: 170,
                            decoration: BoxDecoration(
                                color: Colors.indigo[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.indigo, width: 2)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    // height: 80,
                                    // width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Image(
                                      height: 60,
                                      width: 60,
                                      image: AssetImage("assets/images/category.png"),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text("CATEGORIES",
                                    style: TextStyle(
                                        color:alertsAndColors.darkBlue,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/chefhome.png"),fit: BoxFit.cover)
                    ),
                  ),
                ]),
          )),
    );
  }
}
