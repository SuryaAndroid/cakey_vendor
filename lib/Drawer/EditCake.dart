import 'package:flutter/material.dart';

import '../CommonClass/AlertsAndColors.dart';

class EditCake extends StatefulWidget {
  const EditCake({Key? key}) : super(key: key);

  @override
  State<EditCake> createState() => _EditCakeState();
}

class _EditCakeState extends State<EditCake> {
  //common
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  var drawerKey = GlobalKey<ScaffoldState>();

  //controllers
  var cakeName = new TextEditingController(text: "My Cake Name goes here");
  var cakePrice = new TextEditingController(text: "200");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 15),
              height: 50,
              color: alertsAndColors.lightGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //draw btn
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child:Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(7)
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.chevron_left,size: 30,color: alertsAndColors.lightPink,),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          'CAKE EDIT',
                          style: TextStyle(
                              color: alertsAndColors.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: "Poppins"),
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
                            onTap: () {},
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
                          onTap: () {},
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
                              child: Icon(
                                Icons.person_outline_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
      body: Container(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //col start

              Container(
                color: Colors.blue[200],
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text("My Cake Name is goes here and shows here",
                        style: TextStyle(
                        color: alertsAndColors.darkBlue,
                        fontFamily: "Poppins",
                         fontWeight: FontWeight.bold,
                         fontSize: 16
                      ),),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              TextField(
                controller: cakePrice,
                style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Cake Price",
                  label: Text("Cake Price"),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 1, color: Colors.grey)
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              //stock
              Container(
                height: 55,
                width: double.infinity,
                padding: EdgeInsets.only(left: 10,right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: DropdownButton(
                    value: "Instock",
                    isExpanded: true,
                    underline: Container(),
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                          value: "Instock",
                          child: Text("Instock")
                      ),
                      DropdownMenuItem(
                          value: "Out of stock",
                          child: Text("Out of stock")
                      ),
                    ],
                    onChanged: (item){
                      print(item);
                    }
                ),
              )
              //col end
            ],
          ),
        ),
      ),
    );
  }
}
