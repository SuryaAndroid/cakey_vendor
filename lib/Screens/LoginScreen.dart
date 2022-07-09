import 'dart:convert';
import 'dart:io';

import 'package:cakey_vendor/AlertsAndColors/AlertsAndColors.dart';
import 'package:cakey_vendor/Drawer/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //alert and color
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  
  var email = TextEditingController();
  var password = TextEditingController();

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

  //login
  Future<void> loginUser() async{

    alertsAndColors.showLoader(context);
    
    var prefs = await SharedPreferences.getInstance();
    var map = Map();

    try{
      var headers = {
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('https://cakey-database.vercel.app/api/login/validate'));

      request.body = json.encode({
        "Email": email.text.toString(),
        "Password": password.text.toString()
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        map = jsonDecode(await response.stream.bytesToString());

        Navigator.pop(context);

        if(map['message']=="Login Succeed"){

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login succeed!"),
                backgroundColor: Colors.black,
                behavior: SnackBarBehavior.floating,
              )
          );

          prefs.setBool("currentUser" , true);
          prefs.setString("authToken" , map["token"]);
          prefs.setString("authToken" , map["token"]);

          Navigator.push(context, MaterialPageRoute(builder:(context)=>HomeScreen()));

        }else{
          checkNetwork();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Email/Password Incorrect"),
                backgroundColor: Colors.black,
                behavior: SnackBarBehavior.floating,
              )
          );
        }
      }
      else {
        checkNetwork();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error occurred!"),
              backgroundColor: Colors.black,
              behavior: SnackBarBehavior.floating,
            )
        );
      }
    }catch(e){
      checkNetwork();
      Navigator.pop(context);
    }

    // {statusCode: 200, message: Login Succeed, 
    // type: vendor, token: 
    // eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyODQ3OGM1OTVlYjRmMGI1MGJkMDY1OCIsIkVtYWlsIjoibWFkaHVwcml5YUBtaW5kbWFkZS5pbiIsImlhdCI6MTY1NzM0NDA1MSwiZXhwIjoxNjU3OTQ4ODUxfQ.Bg8XAvcbzIg1o_5bxkj6YKCXV596TD0-_ucQmdokqdQ}
    
  }

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
                SizedBox(height: 30,),
                Container(
                  height: MediaQuery.of(context).size.height*0.4,
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
                  controller: email,
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
                  controller: password,
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
                      
                      if(email.text.isEmpty||password.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Make Sure Fields Are Not Empty"))
                        );
                      }else{
                        loginUser();
                      }

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
