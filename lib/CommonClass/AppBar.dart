import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:flutter/material.dart';

class AppBars{

  AlertsAndColors alertsAndColors = new AlertsAndColors();

  PreferredSize myAppBar()=>PreferredSize(
      preferredSize: Size.fromHeight(50),
      child:SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 15),
          height: 50,
          color:alertsAndColors.lightGrey,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //draw btn
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      print("Drawer");
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 5.2,
                                backgroundColor: alertsAndColors.darkBlue,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              CircleAvatar(
                                radius: 5.2,
                                backgroundColor: alertsAndColors.darkBlue,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  radius: 5.2, backgroundColor: alertsAndColors.darkBlue),
                              SizedBox(
                                width: 3,
                              ),
                              CircleAvatar(
                                radius: 5.2,
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'HOME',
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      InkWell(
                        onTap: () {

                        },
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6)),
                          child: Icon(
                            Icons.notifications_none,
                            color: alertsAndColors.darkBlue,
                            size: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 6,
                        child: CircleAvatar(
                          radius: 3.7,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 2.7,
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3,
                            color: Colors.black,
                            spreadRadius: 0)
                      ],
                    ),
                    child: InkWell(
                      onTap: () {

                      },
                      child:
                      // profileUrl != "null"
                      //     ? CircleAvatar(
                      //   radius: 14.7,
                      //   backgroundColor: Colors.white,
                      //   child: CircleAvatar(
                      //       radius: 13,
                      //       backgroundImage:
                      //       NetworkImage("$profileUrl")),
                      // ) :
                      CircleAvatar(
                        radius: 14.7,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 13,
                          child: Icon(Icons.person_outline_outlined, color: Colors.white,),),
                      ),
                    ),
                  ),
                  SizedBox(width: 6,)
                ],
              ),
            ],
          ),
        ),
      )
  );
}