import 'dart:convert';
import 'dart:io';
import 'package:cakey_vendor/Drawer/CusPriceInfo.dart';
import 'package:cakey_vendor/Screens/NotificationScreen.dart';
import 'package:cakey_vendor/Screens/ProfileScreen.dart';
import 'package:http/http.dart' as http;
import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomizeDetails extends StatefulWidget {
  List flavour;
  CustomizeDetails({required this.flavour});

  @override
  State<CustomizeDetails> createState() => _CustomizeDetailsState(flavour: flavour);
}

class _CustomizeDetailsState extends State<CustomizeDetails> {
  List flavour;
  _CustomizeDetailsState({required this.flavour});
  AlertsAndColors alertsAndColors = new AlertsAndColors();

  String Shape = '';
  String CakeID = '';
  String Cake_ID =  '';
  String CakeName  = '';
  String CakeCommonName  = '';
  String CakeType  =  '';
  String CakeSubType = '';
  String  CakeImage= '';
  String Weight = '';
  String VendorID = '';
  String Vendor_ID =  '';
  String VendorName =  '';
  String VendorPhoneNumber1 = '',VendorPhoneNumber2='',VendorAddress='';
  String UserID ='';
  String User_ID = '';
  String UserName = '';
  String UserPhoneNumber = '';
  String  DeliveryAddress = '';
  String DeliveryDate =   '';
  String DeliverySession = '';
  String DeliveryInformation ='';
  String Price =    '';
  String ItemCount ='';
  String Discount =    '';
  String ExtraCharges = '';
  String DeliveryCharge ='';
  String Gst =    '';
  String Sgst =   '';
  String PaymentType =    '';
  String PaymentStatus =    '';
  String Created_On =  '',Status='',EggOrEggless='',Total='',MessageOntheCake='',Id='';
  String StatusUpdate ='', Update='',_id='',CustomizeCake='',authToken='';

  //vendors
  List myVendorList = [];
  String currentVendorMail = "";
  String currentVendorName = "";
  String currentVendorStreet = "";
  String currentVendorCity = "";
  String currentVendorState= "";
  String currentVendorPin = "";
  String currentVendorPhn1 = "";
  String currentVendorPhn2 = "";
  String currentVendor_id = "";
  String currentVendorId = "";
  String profileUrl='';


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

  Future<void> getVendor() async{

    alertsAndColors.showLoader(context);
    List myList = [];

    try{

      var headers = {
        'Authorization': '$authToken'
      };

      var request = http.Request('GET',
          Uri.parse('https://cakey-database.vercel.app/api/vendors/list'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        myList = jsonDecode(await response.stream.bytesToString());

        print(myList);

        setState((){
          myVendorList = myList.where((element) => element['Email'].toString().toLowerCase()
              ==currentVendorMail.toLowerCase()).toList();
          myVendorList = myVendorList.reversed.toList();
          myVendorList = myVendorList.toSet().toList();

          currentVendorName = myVendorList[0]['VendorName'].toString();
          currentVendor_id = myVendorList[0]['_id'].toString();
          currentVendorId = myVendorList[0]['Id'].toString() ;
          currentVendorPhn1 = myVendorList[0]['PhoneNumber1'].toString();
          currentVendorPhn2 = myVendorList[0]['PhoneNumber2'].toString();
          currentVendorCity = myVendorList[0]["Address"]['City'].toString();
          currentVendorStreet = myVendorList[0]["Address"]['Street'].toString();
          currentVendorState = myVendorList[0]["Address"]['State'].toString();
          currentVendorPin= myVendorList[0]["Address"]['Pincode'].toString();
          profileUrl = myVendorList[0]['ProfileImage'];


        });

        Navigator.pop(context);
      }
      else {
        print(response.reasonPhrase);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Unable to get vendor details :${response.reasonPhrase}"),
              backgroundColor: Colors.brown,
              behavior: SnackBarBehavior.floating,
            )
        );

        Navigator.pop(context);
      }
    }catch(e){
      checkNetwork();
      Navigator.pop(context);
    }

  }


  Future<void> getInitialPrefs() async{
    var pref = await SharedPreferences.getInstance();
    setState(() {
      _id =  pref.getString("Cus_id")??"null";
      Shape =  pref.getString("Cus_Shape")??"null";
      CakeID =   pref.getString("Cus_CakeID")??"null";
      Cake_ID =  pref.getString("Cus_Cake_ID")??"null";
      CakeName  = pref.getString("Cus_CakeName")??"My cake name";
      CakeCommonName  = pref.getString("Cus_CakeCommonName")??"null";
      CakeType  = pref.getString("Cus_CakeType")??"null";
      EggOrEggless = pref.getString("Cus_EggOrEggless")??"null";
      CakeSubType =  pref.getString("Cus_CakeSubType")??"null";
      CakeImage =    pref.getString("Cus_Image")??"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkp-kR6zRZP6qPx7e-Uvy6lDvv05Ud6TT2Yw&usqp=CAU";
      Weight =     pref.getString("Cus_Weight")??"null";
      VendorID =     pref.getString("Cus_VendorID")??"null";
      Vendor_ID =     pref.getString("Cus_Vendor_ID")??"null";
      VendorName =     pref.getString("Cus_VendorName")??"null";
      VendorPhoneNumber1 =    pref.getString("Cus_VendorPhoneNumber1")??'null';
      VendorPhoneNumber2 =    pref.getString("Cus_VendorPhoneNumber2")??'null';
      VendorAddress = pref.getString("Cus_VendorAddress")??'null';
      UserID =     pref.getString("Cus_UserID")??"null";
      User_ID =     pref.getString("Cus_User_ID")??"null";
      UserName =     pref.getString("Cus_UserName")??"null";
      UserPhoneNumber =    pref.getString("Cus_UserPhoneNumber")??"null";
      DeliveryAddress =    pref.getString("Cus_DeliveryAddress")??"null";
      DeliveryDate =    pref.getString("Cus_DeliveryDate")??"null";
      DeliverySession =    pref.getString("Cus_DeliverySession")??"null";
      DeliveryInformation =    pref.getString("Cus_DeliveryInformation")??"null";
      Created_On =   pref.getString("Cus_Created_On")??"null";
      Id =   pref.getString("Cus_Id")??"null";
      CustomizeCake = pref.getString("Cus_CustomizeCake")??"n";
      Status =   pref.getString("Cus_Status")??"null";
      ItemCount =   pref.getString("Cus_ItemCount")??"null";

        authToken = pref.getString('authToken')??'null';
        currentVendorMail = pref.getString('authMail')??'null';

      print(authToken);
      getVendor();
    });
  }

  Future<void> statusUpdate() async {
    try{

      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('PUT',
          Uri.parse('https://cakey-database.vercel.app/api/order/updatestatus/$_id'));
      request.body = json.encode({
        "Status":StatusUpdate,
        "Status_Updated_By":VendorID
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(StatusUpdate);
        print(CakeID);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Status updated!'),backgroundColor: Colors.green,)
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.reasonPhrase.toString()),backgroundColor: alertsAndColors.lightPink,)
        );
      }
    }catch(error){
      Navigator.pop(context);
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please Check Your Connection!"),backgroundColor:alertsAndColors.lightPink,)
      );
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero , () async{
      getInitialPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.grey[300]),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: alertsAndColors.lightPink,
                                size: 20,
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          'CUSTOMIZE DETAILS',
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>NotificationScreen())
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
                                MaterialPageRoute(builder: (context)=>ProfileScreen())
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
                                NetworkImage("$profileUrl")),
                          ) :
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
                        width: 6,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
      body: RefreshIndicator(
        onRefresh: ()async{
          getInitialPrefs();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                              margin: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.27,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey),
                              child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage( CakeImage ==null? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyzg66tQkRI0ouITaVRkQOhM3lmOLuYoCkVg&usqp=CAU'
                                      :CakeImage))),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                      Positioned(
                          top: 15,
                          left: 3,
                          child:Status=='New'? Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                            decoration: BoxDecoration(
                                color: alertsAndColors.lightPink,
                                borderRadius: new BorderRadius.only(
                                    topRight:  const  Radius.circular(30.0),
                                    bottomRight: const  Radius.circular(30.0)
                                )
                            ),
                            child: Text('New',style: TextStyle(fontSize: 12,color: Colors.white,fontFamily: "Poppins"),),
                          )
                              :Status=='Ordered'?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                            decoration: BoxDecoration(
                                color:Color(0XFF6b55bd),
                                borderRadius: new BorderRadius.only(
                                    topRight:  const  Radius.circular(30.0),
                                    bottomRight: const  Radius.circular(30.0)
                                )
                            ),
                            child: Text('Ordered',style: TextStyle(fontSize: 12,color: Colors.white,fontFamily: "Poppins"),),
                          ):Status=='Delivered'?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: new BorderRadius.only(
                                    topRight:  const  Radius.circular(30.0),
                                    bottomRight: const  Radius.circular(30.0)
                                )
                            ),
                            child: Text('Delivered',style: TextStyle(fontSize: 12,color: Colors.white,fontFamily: "Poppins"),),
                          ):Status=='Cancelled'?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: new BorderRadius.only(
                                    topRight:  const  Radius.circular(30.0),
                                    bottomRight: const  Radius.circular(30.0)
                                )
                            ),
                            child: Text('Cancelled',style: TextStyle(fontSize: 12,color: Colors.white,fontFamily: "Poppins"),),
                          ):Status=='Assigned'?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: new BorderRadius.only(
                                    topRight:  const  Radius.circular(30.0),
                                    bottomRight: const  Radius.circular(30.0)
                                )
                            ),
                            child: Text('Assigned',style: TextStyle(fontSize: 12,color: Colors.white,fontFamily: "Poppins"),),
                          ):Status=='Sent'?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: new BorderRadius.only(
                                    topRight:  const  Radius.circular(30.0),
                                    bottomRight: const  Radius.circular(30.0)
                                )
                            ),
                            child: Text('Sent',style: TextStyle(fontSize: 12,color: Colors.white,fontFamily: "Poppins"),),
                          ):Container()
                      ),
                      Positioned(
                          left: 3,
                          top: 35,
                          child: Container(
                            width: 5.5,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: new BorderRadius.only(
                                  bottomLeft: const Radius.circular(100.0),
                                )),
                          )),
                      Positioned(
                          top: 200,
                          left: 15,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Transform.rotate(
                                        angle: 120,
                                        child: Icon(
                                          Icons.egg_outlined,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Text(
                                        EggOrEggless ,
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontFamily: "Poppins",
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),

                      Positioned(
                          left: 10,
                          top: 240,
                          child:   Container(
                            // margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 290,
                                  child: Text(CakeName==null?'CAKE NAME':CakeName,style: TextStyle(fontSize: 18,fontFamily: "Poppins",fontWeight: FontWeight.bold,),maxLines: 1,),
                                ),
                                Container(
                                  child: Text('ID : ' + '$Id',style: TextStyle(fontSize: 12,fontFamily: "Poppins"),),
                                )
                              ],
                            ),
                          )),
                      Positioned(
                        left: 265,
                        top: 205,
                        child: Column(
                          children: [
                            Container(
                              height: 75,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor:alertsAndColors.lightPink,
                                    radius: 9,
                                    child: CircleAvatar(
                                        radius: 7,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.person,size: 13,color: alertsAndColors.lightPink,)
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                      child: Text(UserName==null?'UserName':UserName.toString().split(' ').first
                                        ,style: TextStyle(fontSize: 12,  fontFamily: "Poppins"),)
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: alertsAndColors.lightPink,
                                  borderRadius: new BorderRadius.only(
                                      bottomLeft:  const  Radius.circular(50.0),
                                      bottomRight: const  Radius.circular(50.0)
                                  )
                              ),
                            )
                          ],
                        ),

                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5),
                    color: Color(0XFFd9effc),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Type Of Cake',style: TextStyle(fontFamily: "Poppins"),),
                              Text(CakeType,style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order Date',style: TextStyle(fontFamily: "Poppins"),),
                              Text(Created_On,style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery Date',style: TextStyle(fontFamily: "Poppins"),),
                              Text(DeliveryDate +' - '+ DeliverySession,style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.only(top:20,bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CAKE INFO',style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold),),
                        SizedBox(height: 3,),
                        Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Row(
                          children: [
                            Text('Flavour                               ',style: TextStyle(fontFamily: "Poppins",fontSize: 13),),
                            Text.rich(
                                TextSpan(
                                  text: ":  ",
                                  children:  <TextSpan>[
                                    TextSpan(text: flavour[0]['Name'], style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 15)),
                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(height: 3,),
                        Row(
                          children: [
                            Text('Shape                                ',style: TextStyle(fontFamily: "Poppins",fontSize: 13),),
                            Text.rich(
                                TextSpan(
                                  text: ":  ",
                                  children:  <TextSpan>[
                                    TextSpan(text: Shape, style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 15)),
                                  ],
                                )
                            )
                          ],
                        ),

                        SizedBox(height: 3,),
                        Row(
                          children: [
                            Text('Weight                               ',style: TextStyle(fontFamily: "Poppins",fontSize: 13),),
                            Text.rich(
                                TextSpan(
                                  text: ":  ",
                                  children:  <TextSpan>[
                                    TextSpan(text: Weight, style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 15)),
                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(height: 3,),
                        Row(
                          children: [
                            Text('Message On the Cake  ',style: TextStyle(fontFamily: "Poppins",fontSize: 13),),
                            Text.rich(
                                TextSpan(
                                  text: " :  ",
                                  children:  <TextSpan>[
                                    TextSpan(text:MessageOntheCake==''?'-':MessageOntheCake, style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 15)),
                                  ],
                                )
                            )
                          ],
                        ),

                      ],
                    ),
                  ),


                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CUSTOMER INFO',style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold),),
                        SizedBox(height: 3,),
                        Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 3,),
                        Row(
                          children: [
                            Text('Customer ID                        ',style: TextStyle(fontFamily: "Poppins",fontSize: 13),),
                            Text.rich(
                                TextSpan(
                                  text: ":  ",
                                  children:  <TextSpan>[
                                    TextSpan(text: User_ID, style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 15)),
                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(height: 3,),
                        Row(
                          children: [
                            Text('Customer Name                ',style: TextStyle(fontFamily: "Poppins",fontSize: 13),),
                            Text.rich(
                                TextSpan(
                                  text: ":  ",
                                  children:  <TextSpan>[
                                    TextSpan(text: UserName, style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 15)),
                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(height: 3,),
                        Row(
                          children: [
                            Text('Customer Phonenumber',style: TextStyle(fontFamily: "Poppins",fontSize: 13),),
                            Text(" :  "),
                            Text( '$UserPhoneNumber ', style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 15)),
                            CircleAvatar(
                              radius:9.5,
                              child:InkWell(
                                onTap: () async{
                                  String phoneNumber =UserPhoneNumber;
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: phoneNumber,
                                  );
                                  await launch(launchUri.toString());
                                },
                                child: Icon(Icons.phone,size: 11,),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical:10),
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('STATUS',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                        SizedBox(height: 3,),
                        Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 5,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Status,style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,color: Colors.grey),),
                            ]
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  (Status == 'Sent')?Container():
                  Center(
                    child: Container(
                      width: 200,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: alertsAndColors.lightPink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>CusPriceInfo(flavour: flavour)));
                        },
                        child: Text('SEND INVOICE',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}






