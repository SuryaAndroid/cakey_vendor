import 'package:cakey_vendor/Drawer/HomeScreen.dart';
import 'package:cakey_vendor/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContextClass>(
      create: (context)=>ContextClass(),
      child: MaterialApp(
          // theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home:LoginScreen()
        // home:TestScreen()
      ),
    );
  }
}

