import 'dart:async';
import 'dart:convert';
import 'package:cakey_vendor/Screens/LoginScreen.dart';
import 'package:cakey_vendor/Screens/NotificationScreen.dart';
import 'package:cakey_vendor/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'ContextClass.dart';

void main(){
  runApp(MainScreen());
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MainScreen> {

  late Timer timer;
  String authToken = "";

  Future<void> updateLogSession() async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', Uri.parse('https://cakey-database.vercel.app/api/lastseen'));
    request.body = json.encode({
      "token": "$authToken",
      "LastLogout_At ": simplyFormat(time:DateTime.now() , dateOnly: false)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated...")));
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState(){
    timer = Timer.periodic(Duration(seconds: 60), (timer) {
      getToken();
      print(simplyFormat(time:DateTime.now() , dateOnly: false));
    });
    super.initState();
  }

  Future<void> getToken() async{
    var pr = await SharedPreferences.getInstance();

    setState((){
      authToken = pr.getString("authToken")??"";
    });

    if(authToken!=null || authToken!="null" || authToken.isNotEmpty){
      updateLogSession();
    }

    print("auth token in main.dart : $authToken");
  }

  //rm token
  Future<void> removeToken() async{
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("authToken");
  }

  @override
  void dispose(){
    timer.cancel();
    removeToken();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContextClass>(
      create: (context)=>ContextClass(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:SplashScreen()
      ),
    );
  }
}

