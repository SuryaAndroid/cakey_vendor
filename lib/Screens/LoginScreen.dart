import 'package:cakey_vendor/AlertsAndColors/AlertsAndColors.dart';
import 'package:cakey_vendor/Drawer/HomeScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //alert and color
  AlertsAndColors alertsAndColors = new AlertsAndColors();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          // alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('LOGIN',
                style: TextStyle(
                  color: alertsAndColors.darkBlue,
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                 ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/loginpic.png")
                    )
                  ),
                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User Name",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: "Poppins"
                    ),
                  ),
                ),
                TextField(
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: alertsAndColors.darkBlue
                  ),
                  decoration: InputDecoration(
                    hintText: "User Name",
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 13
                      ),
                    prefixIcon: Container(
                      margin: EdgeInsets.all(5),
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: alertsAndColors.darkBlue,),
                    )
                  ),
                ),

                SizedBox(height: 15,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: "Poppins"
                    ),
                  ),
                ),
                TextField(
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: alertsAndColors.darkBlue
                  ),
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13
                      ),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(5),
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.lock, color: alertsAndColors.darkBlue,),
                      )
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (c)=>HomeScreen())
                      );
                    },
                    child: Text(
                      'LOGIN' ,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    color: alertsAndColors.lightPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
