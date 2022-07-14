import 'dart:convert';
import 'dart:io';
import 'package:cakey_vendor/ContextClass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../CommonClass/AlertsAndColors.dart';


class CusPriceInfo extends StatefulWidget {

  List flavour;
  CusPriceInfo({required this.flavour});

  @override
  State<CusPriceInfo> createState() => _CusPriceInfoState(
      flavour: flavour,
  );
}

class _CusPriceInfoState extends State<CusPriceInfo> {

  List flavour ;
  _CusPriceInfoState({required this.flavour});

  //common
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  var drawerKey = GlobalKey<ScaffoldState>();
  var priceCtrl = new TextEditingController();
  var taxCtrl = new TextEditingController();
  var discountCtrl = new TextEditingController();

  //Strings
  String authToken= "";
  String cake_id = "";
  String cakeId = "";

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

  //Lists /*shape*/
  List<bool> isShapetTapped = [];
  List<TextEditingController> shapeEditors = [];
  List fixedShapeList = [];
  List spareShapeList = [];
  /*flv*/
  List<bool> isFlavTapped = [];
  List<TextEditingController> flavEditors = [];
  List fixedFlavList = [];
  List spareFlavList = [];
  /*weight*/
  List<bool> isWeightTapped = [];
  List<TextEditingController> weightEditors = [];
  List fixedWeightList = [];
  List spareWeightList = [];


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
  String StatusUpdate ='', Update='',_id='',CustomizeCake='';

double FinalPrice=0.0;
double Finalgst=0.0;
double Finalsgst=0.0;
double FinalExtracharge=0.0;
double TotalPrice=0.0;
double FinalDiscount=0.0;
double Priceperkg=0.0;


  Future<void> getInitialPrefs() async{
    var pref = await SharedPreferences.getInstance();
    this.setState(() {
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
    });
  }

  Future<void> priceUpdate() async{
    try{
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('PUT',
          Uri.parse('https://cakey-database.vercel.app/api/customize/cake/price/$_id'));
      request.body = json.encode({
        "CakeType": CakeType,
        "EggOrEggless": EggOrEggless,
        // "Flavour":Flavour,
        "Shape":Shape,
        "Weight": Weight,
        "MessageOnTheCake": MessageOntheCake,
        "DeliveryAddress": DeliveryAddress,
        "DeliveryDate": DeliveryDate,
        "DeliverySession": DeliverySession,
        "DeliveryInformation": DeliveryInformation,
        "VendorID": VendorID,
        "Vendor_ID": Vendor_ID,
        "VendorName": VendorName,
        "VendorPhoneNumber1": VendorPhoneNumber1,
        "VendorPhoneNumber2": VendorPhoneNumber2,
        "VendorAddress": VendorAddress,
        "UserID": UserID,
        "User_ID": User_ID,
        "UserName": UserName,
        "UserPhoneNumber": UserPhoneNumber,
        "Status": "Sent",
        "Notification": 'unseen',
        "Price": Priceperkg,
        "Discount": FinalDiscount,
        "Gst": Finalsgst,
        "Sgst": Finalgst,
        "ExtraCharges": FinalExtracharge,
        "Total" : TotalPrice,
        "Invoice_Sent_By": VendorID
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print(StatusUpdate);
        print(CakeID);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Price updated!'),backgroundColor: Colors.green,)
        );
        Navigator.pop(context);
      }else {
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



  Future<void> getVendor() async{

    print(currentVendorMail);

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

        });

        print(myVendorList[0]['Email']);

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

  //
  Future<void> getEditData() async{
    var pref = await SharedPreferences.getInstance();

    setState((){
      authToken = pref.getString("authToken")??"null";
      currentVendorMail = pref.getString("authMail")??"null";
      cake_id = pref.getString("cakeEd_id")??"null";
      cakeId = pref.getString("cakeEdId")??"null";
    });
    getVendor();
    getShapes();
  }



  void confiromPrice(BuildContext context){
    showDialog(
        context: context,
        builder: (_) =>  AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(10.0))),
          content: Container(
            width: MediaQuery.of(context).size.width*0.60,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 300,
                  child: Center(
                    child: Column(
                      children: [
                        Text('PRICE DETAILS',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Container(height: 1,color: Colors.grey[200],),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Weight',style: TextStyle(fontFamily: "Poppins",color: Colors.grey,fontWeight: FontWeight.bold),),
                                Text('$Weight',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                              ],
                            ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Price per KG',style: TextStyle(fontFamily: "Poppins",color: Colors.grey,fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                Text('₹',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                SizedBox(width: 3,),
                                Text(priceCtrl.text.toString(),style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Extra Charges',style: TextStyle(fontFamily: "Poppins",color: Colors.grey,fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                Text('₹',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                SizedBox(width: 3,),
                                Text('$FinalExtracharge',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Gst',style: TextStyle(fontFamily: "Poppins",color: Colors.grey,fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                Text('₹',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                SizedBox(width: 3,),
                                Text('$Finalgst',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sgst',style: TextStyle(fontFamily: "Poppins",color: Colors.grey,fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                Text('₹',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                SizedBox(width: 3,),
                                Text('$Finalsgst',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount',style: TextStyle(fontFamily: "Poppins",color: Colors.grey,fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                Text('-',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text('$Finalsgst',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(height: 1,color: Colors.grey[200],),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Bill Total',style: TextStyle(fontFamily: "Poppins",color: Colors.grey,fontWeight: FontWeight.bold),),
                            SizedBox(width: 20,),
                            Text('$TotalPrice',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: alertsAndColors.lightPink
                          ),
                          child: InkWell(
                            onTap: (){
                              priceUpdate();
                            },
                            child: Text('CONFIRM',style: TextStyle(fontFamily: "Poppins",color: Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        )


                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
    );
  }



  Future<void> getFlavours() async{

    List myFlavList = [];

    var headers = {
      'Authorization': '$authToken'
    };

    var request = http.Request('GET',
        Uri.parse('https://cakey-database.vercel.app/api/flavour/list'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      myFlavList = jsonDecode(await response.stream.bytesToString());


      setState((){
        for(int i = 0 ; i<flavour.length;i++){
          fixedFlavList.add(flavour[i]);
        }
        spareFlavList = myFlavList;
        spareFlavList = spareFlavList.reversed.toList();
        spareFlavList = spareFlavList.toSet().toList();
      });
      getWeights();
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> getShapes() async{

    List myFlavList = [];

    var headers = {
      'Authorization': '$authToken'
    };

    var request = http.Request('GET',
        Uri.parse('https://cakey-database.vercel.app/api/shape/list'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      myFlavList = jsonDecode(await response.stream.bytesToString());


      setState((){
        // shapeList.removeWhere((element) => element['Price']=="0");
        // for(int i = 0 ; i<shapeList.length;i++){
        //   fixedShapeList.add(shapeList[i]);
        // }
        spareShapeList = myFlavList;
        spareShapeList = spareShapeList.reversed.toList();
        spareShapeList = spareShapeList.toSet().toList();
      });
      getFlavours();
    }
    else {
      print(response.reasonPhrase);
    }

  }


  Future<void> getWeights() async{

    List myFlavList = [];

    var headers = {
      'Authorization': '$authToken'
    };

    var request = http.Request('GET',
        Uri.parse('https://cakey-database.vercel.app/api/weight/list'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      myFlavList = jsonDecode(await response.stream.bytesToString());


      setState((){
        // for(int i = 0 ; i<weightList.length;i++){
        //   fixedWeightList.add(weightList[i]);
        // }
        spareWeightList = myFlavList;
        spareWeightList = spareWeightList.reversed.toList();
        spareWeightList = spareWeightList.toSet().toList();
      });

      print(spareWeightList);
    }
    else {
      print(response.reasonPhrase);
    }

  }


  @override
  void initState(){
    Future.delayed(Duration.zero ,() async{
      getEditData();
      getInitialPrefs();
      print(VendorName);
      print(VendorPhoneNumber1);
      print(VendorPhoneNumber2);
      print(VendorAddress);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          'PRICE INFO',
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
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Stack(
                  children: [
                    Container(
                      height:65,
                      margin:EdgeInsets.only(top: 3),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey , width: 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 35,
                                    child: TextField(
                                      keyboardType: TextInputType.phone,
                                      maxLength: 5,
                                      controller: priceCtrl,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 5),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                        counterText: "",
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 6,),
                              Expanded(child: Container(
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: (){
                                    // if(extraShapeCtrl.text.isNotEmpty){
                                    //   addExtraShape(extraShapeCtrl.text);
                                    // }
                                    print(priceCtrl.text.toString());
                                  },
                                  child: Text("ADD" , style: TextStyle(
                                      color: Colors.white
                                  ),),
                                ),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 12,
                        top: -5,
                        child: Text(
                          "Price",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                              backgroundColor: Colors.white
                          ),
                        )
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Stack(
                  children: [
                    Container(
                      height:65,
                      margin:EdgeInsets.only(top: 3),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey , width: 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 35,
                                    child: TextField(
                                      keyboardType: TextInputType.phone,
                                      maxLength: 3,
                                      controller: taxCtrl,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 5),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        counterText: "",
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 6,),
                              Expanded(child: Container(
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: (){
                                    // if(extraShapeCtrl.text.isNotEmpty){
                                    //   addExtraShape(extraShapeCtrl.text);
                                    // }
                                    print(taxCtrl.text.toString());
                                  },
                                  child: Text("ADD" , style: TextStyle(
                                      color: Colors.white
                                  ),),
                                ),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 12,
                        top: -5,
                        child: Text(
                          "Tax ( % )",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                              backgroundColor: Colors.white
                          ),
                        )
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Stack(
                  children: [
                    Container(
                      height:65,
                      margin:EdgeInsets.only(top: 3),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey , width: 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 35,
                                    child: TextField(
                                      keyboardType: TextInputType.phone,
                                      maxLength: 3,
                                      controller: discountCtrl,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 5),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        counterText: "",
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 6,),
                              Expanded(child: Container(
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: (){
                                    // if(extraShapeCtrl.text.isNotEmpty){
                                    //   addExtraShape(extraShapeCtrl.text);
                                    // }
                                    print(discountCtrl.text.toString());
                                  },
                                  child: Text("ADD" , style: TextStyle(
                                      color: Colors.white
                                  ),),
                                ),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 12,
                        top: -5,
                        child: Text(
                          "Discount ( % )",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                              backgroundColor: Colors.white
                          ),
                        )
                    ),
                  ],
                ),
              ),


              SizedBox(height: 5,),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Stack(
                      children: [
                        Container(
                          margin:EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey , width: 1),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),
                              Wrap(
                                spacing: 3,
                                children:fixedFlavList.map((e){
                                  return ActionChip(
                                      label: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(e['Name']+" - Rs."+e['Price'], style: TextStyle(
                                              color: alertsAndColors.darkBlue,
                                              fontFamily: "Poppins"
                                          ),),
                                          SizedBox(width: 3,),
                                          Icon(Icons.check_circle , size: 18,color: Colors.green,)
                                        ],
                                      ),
                                      onPressed: ()=>setState((){
                                        fixedFlavList.remove(e); //fixedflavourlist----->flavourlist
                                      })
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10,),
                              ListView.builder(
                                  itemCount: spareFlavList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (c, i){
                                    isFlavTapped.add(false);
                                    flavEditors.add(new TextEditingController());
                                    return Container(
                                      padding: EdgeInsets.only(left: 7 , right: 7 , top: 5 , bottom: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  isFlavTapped[i]==true?
                                                  GestureDetector(
                                                    onTap: ()=>setState((){
                                                      if(fixedFlavList.isNotEmpty){
                                                        fixedFlavList.removeWhere((element) => element['Name']
                                                            ==spareFlavList[i]['Name']);
                                                        flavEditors[i].text = "";
                                                        isFlavTapped[i]=false;
                                                        print(fixedFlavList);
                                                      }else{
                                                        flavEditors[i].text = "";
                                                        isFlavTapped[i]=false;
                                                      }
                                                    }),
                                                    child: Icon(Icons.remove_circle , color: Colors.red,),
                                                  ):Container(),
                                                  SizedBox(width: 5,),
                                                  Text("${spareFlavList[i]['Name']}" ,style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "Poppins"
                                                  ),),
                                                ],
                                              ),
                                              isFlavTapped[i]==false?
                                              GestureDetector(
                                                onTap: ()=>setState((){
                                                  isFlavTapped[i] = true;
                                                }),
                                                child: Icon(Icons.add_circle , color: Colors.green,),
                                              ):
                                              Container(
                                                height: 30,
                                                width:45,
                                                child: TextField(
                                                  keyboardType: TextInputType.phone,
                                                  controller: flavEditors[i],
                                                  onEditingComplete: (){
                                                    print("Completed...");
                                                    setState((){
                                                      if(flavEditors[i].text.isNotEmpty){
                                                        fixedFlavList.add(
                                                            {
                                                              "Name":'${spareFlavList[i]['Name']}',
                                                              "Price":'${flavEditors[i].text}',
                                                            }
                                                        );
                                                      }
                                                    });
                                                    print(fixedFlavList.toSet().toList());
                                                  },
                                                  onSubmitted: (e){
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      contentPadding: EdgeInsets.only(left: 6)
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Divider(height: 1,color: Colors.grey,),
                                        ],
                                      ),
                                    );
                                  }
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            left: 12,
                            top: -5,
                            child: Text(
                              "Flavours",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Poppins",
                                  backgroundColor: Colors.white
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),



              SizedBox(height: 10,),


              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: alertsAndColors.lightPink
                  ),
                  child: InkWell(
                    onTap: (){
                      setState((){

                        FinalExtracharge=0.0;
                        for(int i=0;i<fixedFlavList.length;i++){
                          FinalExtracharge=FinalExtracharge+double.parse(fixedFlavList[i]['Price']);
                        }

                        print(FinalExtracharge);
                        var weight= Weight.toString().split('').first;
                        double dweight =double.parse(weight);
                         Priceperkg = double.parse(priceCtrl.text.toString());
                        double ddiscount = double.parse(discountCtrl.text.toString());
                        double dtax = double.parse(taxCtrl.text.toString());
                        double priceweight = dweight*Priceperkg;
                        FinalDiscount = (priceweight * ddiscount / 100);
                        double tax = (priceweight * dtax)/100;
                            Finalgst = tax/2;
                            Finalsgst = tax/2;
                            print('weight...'   + '$dweight');
                            print('price per kg...'   + '$Priceperkg');
                            print('Discount...'   + '$ddiscount');
                            print('tax...     '   +  '$dtax');
                            print('extra charge...   '   + '$FinalExtracharge');
                            print('gst...'+'$Finalgst');
                            print('sgst...'+'$Finalsgst');

                        double Addedprice = (priceweight+FinalExtracharge);
                         TotalPrice = (Addedprice+tax)-FinalDiscount;
                          print('TOTAL....' +"$TotalPrice");

                        // addedPrice  = (((price*weights)+extra)*itemCount);
                        // finalPrice = (addedPrice + tax + delCharge)-discountedPrice;
                        confiromPrice(context);
                      });
                    },
                    child: Text('CONFIRM PRICE',style: TextStyle(color: Colors.white,fontFamily: "Poppins",fontWeight: FontWeight.bold),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


