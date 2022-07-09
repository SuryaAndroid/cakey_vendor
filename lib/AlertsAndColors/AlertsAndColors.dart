import 'package:flutter/material.dart';

class AlertsAndColors{

  //color
  Color lightPink = Color(0xffFE8416D);
  Color lightGrey = Color(0xffF5F5F5);
  Color darkBlue = Color(0xffF213959);

  //alert dialog
  void showLoader(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=>
            AlertDialog(
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 15,),
                  Text('Please Wait...',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
    );
  }

}