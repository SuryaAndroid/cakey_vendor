import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cakey_vendor/Drawer/AddCakes.dart';
import 'package:cakey_vendor/Drawer/CakesList.dart';
import 'package:cakey_vendor/Drawer/MainDrawer.dart';
import 'package:cakey_vendor/Screens/NotificationScreen.dart';
import 'package:cakey_vendor/Screens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CommonClass/AlertsAndColors.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //alert and color
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  var drawerKey = GlobalKey<ScaffoldState>();
  String authToken = "";
  String authMail = "";
  String profileUrl = "";
  String vendorName = "";
  List vendorProfile = [];

  @override
  void initState(){
    super.initState();
    getInitialPrefs();
  }

  Future<void> getInitialPrefs() async{
    var pref = await SharedPreferences.getInstance();
    setState((){
      authToken = pref.getString('authToken')??"";
      authMail = pref.getString('authMail')??"";
    });
    getVendorByMail(authMail);
  }

  Future<void> getVendorByMail(String authMail) async{
    var pref = await SharedPreferences.getInstance();
    alertsAndColors.showLoader(context);
    try{
      var headers = {
        'Authorization': '$authToken'
      };
      var request = http.Request('GET',
          Uri.parse('https://cakey-database.vercel.app/api/vendors/listbyemail/$authMail'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        List data = jsonDecode(await response.stream.bytesToString());
        print(data.length);
        setState((){
          vendorProfile = data;
          profileUrl = vendorProfile[0]["ProfileImage"].toString();
          vendorName = vendorProfile[0]["VendorName"].toString();
          pref.setString("profileImage", profileUrl);
          pref.setString("vendorName", vendorName);
        });
        Navigator.pop(context);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.reasonPhrase.toString()),
              backgroundColor: Colors.brown,
              behavior: SnackBarBehavior.floating,
            )
        );
        Navigator.pop(context);
      }
    }catch(e){
      checkNetwork();
      print(e);
      Navigator.pop(context);
    }

  }

  //network check
  Future<void> checkNetwork() async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internet Not Connected"),
            backgroundColor: Colors.brown,
            behavior: SnackBarBehavior.floating,
          )
      );
      print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: MainDrawer(screen: "home",),
      appBar: PreferredSize(
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
                          FocusScope.of(context).unfocus();
                          drawerKey.currentState?.openDrawer();
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
                              Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (c)=>NotificationScreen())
                              );
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (c)=>ProfileScreen())
                            );
                          },
                          child:
                          profileUrl != "null"
                              ? CircleAvatar(
                              radius: 14.7,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundImage:
                                NetworkImage(profileUrl)),
                          ) :
                          CircleAvatar(
                            radius: 14.7,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 13,
                              child: Icon(Icons.person_outline_outlined, color: Colors.white,),),
                          ),
                        ),
                      ),
                      SizedBox(width: 15,)
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
      body: Container(
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: ()=>Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context)=>CakesList())
                            ),
                            child: Container(
                              height: 160,
                              decoration: BoxDecoration(
                                  color: Colors.blue[50],
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
                                        height: 50,
                                        width: 50,
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
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: InkWell(
                            onTap: ()=>Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>CakesList())
                            ),
                            child: Container(
                              height: 160,
                              decoration: BoxDecoration(
                                  color: Colors.pink[50],
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
                                        height: 50,
                                        width: 50,
                                        image: AssetImage("assets/images/cakelist.png"),
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: ()=>Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>AddCakes())
                            ),
                            child: Container(
                              height: 160,
                              decoration: BoxDecoration(
                                  color: Colors.orange[50],
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
                                        height: 50,
                                        width: 50,
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
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: InkWell(
                            onTap: ()=>Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>CakesList())
                            ),
                            child: Container(
                              height: 160,
                              decoration: BoxDecoration(
                                  color: Colors.indigo[50],
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
                                        height: 50,
                                        width: 50,
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
