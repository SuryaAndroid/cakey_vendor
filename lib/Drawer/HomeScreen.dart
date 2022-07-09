import 'package:cakey_vendor/CommonClass/AppBar.dart';
import 'package:flutter/material.dart';

import '../CommonClass/AlertsAndColors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  //alert and color
  AlertsAndColors alertsAndColors = new AlertsAndColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBars().myAppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                GridView.count(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 crossAxisCount: 2,
                 crossAxisSpacing: 10,
                 mainAxisSpacing: 8.0,
                 children: [
                   Container(
                     height: 220,
                     color: Colors.blue[200],
                   ),
                   Container(
                     height: 220,
                     color: Colors.redAccent[200],
                   ),
                   Container(
                     height: 220,
                     color: Colors.yellow[200],
                   ),
                   Container(
                     height: 220,
                     color: Colors.indigo[200],
                   ),
                 ],
                )
              ]
          ),
        )
      ),
    );
  }
}
