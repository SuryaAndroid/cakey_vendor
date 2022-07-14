import 'dart:convert';
import 'dart:io';
import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  String authToken = "";
  String authMail = "";
  String vendorId = "";

  List newOrders = [];

  //get prefs
  Future<void> getIniitialPrefs() async{
    var pref = await SharedPreferences.getInstance();
    setState((){
      authToken = pref.getString('authToken')??"";
      authMail = pref.getString('authMail')??"";
    });
    getVendors();
  }

  Future<void> getVendors() async{

    alertsAndColors.showLoader(context);

    var list = [];
    try{
      var headers = {
        'Authorization': '$authToken'
      };

      var request = http.Request('GET',
          Uri.parse('https://cakey-database.vercel.app/api/vendors/listbyemail/$authMail'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        list = jsonDecode(await response.stream.bytesToString());

        setState((){
          vendorId = list[0]['_id'];
        });

        getOrders(vendorId);

        Navigator.pop(context);

      }
      else {
        checkNetwork();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error Occurred"),
              backgroundColor: Colors.black,
              behavior: SnackBarBehavior.floating,
            )
        );
      }
    }catch(e){
      print(e);
      checkNetwork();
      Navigator.pop(context);
    }

  }

  Future<void> getOrders(String id) async{
    var headers = {
      'Authorization': '$authToken'
    };
    var request = http.Request('GET', Uri.parse('https://cakey-database.vercel.app/api/order/listbyvendorid/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List map = jsonDecode(await response.stream.bytesToString());
      setState((){
        newOrders = map.where((element) => element['Status'].toString().toLowerCase()=="new").toList();
        getCustomiseOrders(vendorId);
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> getCustomiseOrders(String id) async{

    List oldList = [];
    var headers = {
      'Authorization': '$authToken'
    };
    var request = http.Request('GET',
        Uri.parse('https://cakey-database.vercel.app/api/customize/cake/listbyvendorid/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List map = jsonDecode(await response.stream.bytesToString());
      setState((){
        oldList = map.where((element) => element['Status'].toString().toLowerCase()=="new").toList();
        oldList = oldList + map.where((element) => element['Status'].toString().toLowerCase()=="assigned").toList();
        oldList = oldList.reversed.toList();
        newOrders = oldList + newOrders;
        newOrders.sort((a,b)=>a['Created_On'].toString().compareTo(simplyFormat(time: DateTime.now(),dateOnly: false).toString()));
        newOrders = newOrders.reversed.toList();
      });
    }
    else {
      print(response.reasonPhrase);
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
  void initState(){
    super.initState();
    getIniitialPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:PreferredSize(
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
                          'NOTIFICATION',
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
                ],
              ),
            ),
          )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height*0.9,
        child:RefreshIndicator(
          onRefresh: () async{
            getIniitialPrefs();
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: newOrders.length>0?
            GroupedListView<dynamic , String>(
                elements: newOrders,
                shrinkWrap: true,
                groupBy: (e)=>e['Created_On'],
                order: GroupedListOrder.DESC,
                groupSeparatorBuilder: (String i)=>Container(),
                itemBuilder: (context , e){
                  return InkWell(
                    onTap: (){
                      print(formateToDay(e['Created_On'].toString().split(" ").first));
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          e['Image']==null?
                          Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                            child:
                            Icon(Icons.image_outlined , color:alertsAndColors.darkBlue,size: 35,),
                          ):
                          Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                                image: DecorationImage(
                                    image: NetworkImage(e['Image'].toString()),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          SizedBox(width: 6,),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  e['CustomizeCake']!=null?
                                  Text("New Order "+e['CakeName'].toString()+" From ${e['UserName']}",style: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: "Poppins",
                                      fontSize: 13
                                  ),):
                                  Text("New Customize Cake Is Ordered By ${e['UserName']}. Click to view",style: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: "Poppins",
                                      fontSize: 13
                                  ),),
                                  SizedBox(height: 10,),
                                  Text(
                                    simplyFormat(time: DateTime.now(),dateOnly: true)==
                                        e['Created_On'].toString().split(" ").first?
                                    "Today":formateToDay(e['Created_On'].toString().split(" ").first)
                                    ,style: TextStyle(
                                      color: alertsAndColors.darkBlue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                  );
                },
            ):
            // Column(
            //   children:newOrders.map((e){
            //     return InkWell(
            //       onTap: (){
            //         print(formateToDay(e['Created_On'].toString().split(" ").first));
            //       },
            //       child: Container(
            //         padding: EdgeInsets.all(15),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             e['Image']==null?
            //             Container(
            //               alignment: Alignment.center,
            //               height: 60,
            //               width: 60,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 color: Colors.grey[300],
            //               ),
            //               child:
            //               Icon(Icons.image_outlined , color:alertsAndColors.darkBlue,size: 35,),
            //             ):
            //             Container(
            //               alignment: Alignment.center,
            //               height: 60,
            //               width: 60,
            //               decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   color: Colors.grey[300],
            //                   image: DecorationImage(
            //                       image: NetworkImage(e['Image'].toString()),
            //                       fit: BoxFit.cover
            //                   )
            //               ),
            //             ),
            //             SizedBox(width: 6,),
            //             Expanded(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text("New Order "+e['CakeName'].toString()+" From ${e['UserName']}",style: TextStyle(
            //                         color: Colors.grey[600],
            //                         fontFamily: "Poppins",
            //                         fontSize: 13
            //                     ),),
            //                     SizedBox(height: 10,),
            //                     Text(
            //                       simplyFormat(time: DateTime.now(),dateOnly: true)==
            //                           e['Created_On'].toString().split(" ").first?
            //                       "Today":formateToDay(e['Created_On'].toString().split(" ").first)
            //                       ,style: TextStyle(
            //                         color: alertsAndColors.darkBlue,
            //                         fontSize: 15,
            //                         fontWeight: FontWeight.bold
            //                     ),),
            //                   ],
            //                 )
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // )
            Container(
              height: MediaQuery.of(context).size.height*0.9,
              width: double.infinity,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 40,color: Colors.red,) ,
                    SizedBox(height: 15,),
                    Text("No Notifications",style: TextStyle(
                        color: alertsAndColors.lightPink,
                        fontFamily: "Poppins",
                        fontSize: 18
                    ),)
                  ],
               ),
            ),
          ),
        )
      ),
    );
  }
}

String simplyFormat({required DateTime time, bool dateOnly = false}) {

  String year = time.year.toString();

  // Add "0" on the left if month is from 1 to 9
  String month = time.month.toString().padLeft(2, '0');

  // Add "0" on the left if day is from 1 to 9
  String day = time.day.toString().padLeft(2, '0');

  // Add "0" on the left if hour is from 1 to 9
  String hour = time.hour.toString().padLeft(2, '0');

  // Add "0" on the left if minute is from 1 to 9
  String minute = time.minute.toString().padLeft(2, '0');

  // Add "0" on the left if second is from 1 to 9
  String second = time.second.toString();

  // return the "yyyy-MM-dd HH:mm:ss" format
  if (dateOnly == false) {
    return "$day-$month-$year $hour:$minute:$second";
  }

  // If you only want year, month, and date
  return "$day-$month-$year";
}

String formateToDay(String date){

  String day = date.split("-").first;
  String month = date.split("-")[1];
  String year = date.split("-").last;

  List months = [
    {"month": 'Jan', "number": 01},
    {"month": 'Feb', "number": 02},
    {"month": 'Mar', "number": 03},
    {"month": 'Apr', "number": 04},
    {"month": 'May', "number": 05},
    {"month": 'Jun', "number": 06},
    {"month": 'Jul', "number": 07},
    {"month": 'Aug', "number": 08},
    {"month": 'Sep', "number": 09},
    {"month": 'Oct', "number": 10},
    {"month": 'Nav', "number": 11},
    {"month": 'Dec', "number": 12},
  ];

  List Month = months.where((element) => element['number']==int.parse(month)).toList();
  String formateMonth = Month[0]["month"];

  String formatedDate = formateMonth+" $day " + year;

  return formatedDate;
}

