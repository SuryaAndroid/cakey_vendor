import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:cakey_vendor/Drawer/AddCakes.dart';
import 'package:cakey_vendor/Drawer/CakesList.dart';
import 'package:cakey_vendor/Drawer/HomeScreen.dart';
import 'package:cakey_vendor/Screens/NotificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/ProfileScreen.dart';

class MainDrawer extends StatefulWidget {
  String screen;
  MainDrawer({required this.screen});

  @override
  State<MainDrawer> createState() => _MainDrawerState(screen: screen);
}

class _MainDrawerState extends State<MainDrawer> {
  String screen;
  _MainDrawerState({required this.screen});

  String profileImage = "";
  String vendorName = "";


  Future<void> getPrefs() async{
    var pref = await SharedPreferences.getInstance();
    setState((){
      profileImage = pref.getString("profileImage")??"";
      vendorName = pref.getString("vendorName")??"";
    });
  }

  @override
  void initState(){
    super.initState();
    print("Inist draw");
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        width: 310,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight:Radius.circular(25),bottomRight: Radius.circular(25))
        ),
        child: Column(
          children: [
            //Profile content...
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 12, color: Color(0xffcccccc), spreadRadius: 1)],
                    ),
                    child:
                    profileImage!="null"?
                    CircleAvatar(
                      radius: 37,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                        NetworkImage('$profileImage'),
                      ),
                    ):

                    CircleAvatar(
                      radius: 37,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          radius: 35,
                          // backgroundImage:AssetImage('assets/images/user.png')
                      ),
                    )
                ),
                SizedBox(width: 15,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 180,
                      child: Text("$vendorName",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AlertsAndColors().darkBlue,fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 7,),
                    Container(
                      height: 30,
                      width: 90,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        ),
                        color:AlertsAndColors().lightPink,
                        onPressed: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c)=>ProfileScreen())
                        ),
                        child: Text('PROFILE',
                          style: TextStyle(color:Colors.white,fontFamily: "Poppins",fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 0.5,
              color: AlertsAndColors().lightPink,
            ),
            SizedBox(height: 25,),
            ListTile(
              onTap: (){
                if(screen == "home"){
                  Navigator.pop(context);
                }else {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c)=>HomeScreen())
                  );
                }
              },
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red[50],
                // child: Icon(Icons.home_outlined,color:AlertsAndColors().lightPink,),
              ),
              title: Container(
                width: 180,
                child: Text('Home',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AlertsAndColors().darkBlue,fontFamily: "Poppins",fontSize: 16),
                ),
              ),
            ),
            ListTile(
              onTap: (){
                if(screen == "orderlist"){
                  Navigator.pop(context);
                }else {
                  Navigator.pop(context);
                }
              },
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red[50],
                // child: Icon(Icons.cake_outlined,color:AlertsAndColors().lightPink,),
              ),
              title: Container(
                width: 180,
                child: Text('Order List',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AlertsAndColors().darkBlue,fontFamily: "Poppins",fontSize: 16),
                ),
              ),
            ),
            ListTile(
              onTap: (){
                if(screen == "cakes"){
                  Navigator.pop(context);
                }else {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c)=>CakesList())
                  );
                }
              },
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red[50],
                // child: Icon(Icons.edit_outlined,color:AlertsAndColors().lightPink,),
              ),
              title: Container(
                child: Text('Cake List',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AlertsAndColors().darkBlue,fontFamily: "Poppins",fontSize: 16),
                ),
              ),
            ),
            ListTile(
              onTap: (){
                if(screen == "addcake"){
                  Navigator.pop(context);
                }else {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c)=>AddCakes())
                  );
                }
              },
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red[50],
                // child: Icon(Icons.account_circle_outlined,color:AlertsAndColors().lightPink,),
              ),
              title: Container(
                width: 180,
                child: Text('Add Cake',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AlertsAndColors().darkBlue,fontFamily: "Poppins",fontSize: 16),
                ),
              ),
            ),
            ListTile(
              onTap: (){

              },
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red[50],
                // child: Icon(Icons.shopping_bag_outlined,color:AlertsAndColors().lightPink,),
              ),
              title: Container(
                width: 180,
                child: Text('Categories',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AlertsAndColors().darkBlue,fontFamily: "Poppins",fontSize: 16),
                ),
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context)=>NotificationScreen())
                );
              },
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red[50],
                // child: Icon(Icons.notifications_outlined,color:AlertsAndColors().lightPink,),
              ),
              title: Container(
                width: 180,
                child: Text('Notifications',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AlertsAndColors().darkBlue,fontFamily: "Poppins",fontSize: 16),
                ),
              ),
            ),
            Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child:ListTile(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    leading:Icon(
                      Icons.logout_sharp,
                      color: AlertsAndColors().lightPink,
                      size: 30,
                    ),
                    title: Container(
                      width: 180,
                      child: Text('Logout',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AlertsAndColors().darkBlue,fontFamily: "Poppins",fontSize: 16),
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
