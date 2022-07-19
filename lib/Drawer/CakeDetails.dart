import 'dart:convert';
import 'dart:io';

import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:cakey_vendor/ContextClass.dart';
import 'package:cakey_vendor/Drawer/AddCakes.dart';
import 'package:cakey_vendor/Drawer/EditCake.dart';
import 'package:cakey_vendor/Screens/NotificationScreen.dart';
import 'package:cakey_vendor/Screens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CakeDetails extends StatefulWidget {
  var flavours , shapes ,tiers;
  CakeDetails({required this.flavours, required this.shapes,required this.tiers});

  @override
  State<CakeDetails> createState() => _CakeDetailsState(flavours: flavours , shapes: shapes , tiers: tiers);
}

class _CakeDetailsState extends State<CakeDetails>{
  List flavours , shapes , tiers;
  _CakeDetailsState({required this.flavours, required this.shapes ,required this.tiers });

  AlertsAndColors alertsAndColors = new AlertsAndColors();


  String CakeImg='';
  String CakeComName='';
  String CakeType='';
  String CakeSubtype='';
  String IsEgglessPossible='';
  String BEgglesspricePerkg='';
  String Discount='';
  String Tax='';
  String Created_On='';
  String MinTimeForDcake='';
  String Cakebase='';
  String CakeCream='';
  String BestusedBefore='';
  String Tobestorein='';
  String MintimeForTierCake='';
  String ThemecakePossible='';
  String TopperPossible='';
  String FullyCus='';
  String HowgoodWiththecake='';
  String HowMTimesBaked='';
  String IstierPossible='';
  String cakeName = "";
  String cakePrice = "";
  String cakeDesc = "";
  String egg = "";
  String status = "";
  String cake_id = "";
  String cakeId = "";
  String cakeCustomPossible = "";
  String cakeTierPoss = "";
  String Stock='';
  String temp='';
  String BasicCus='';
  List<String> images = [];
  var weights = [];
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
  String authToken= "";


  //pg dots
  int pageViewCurIndex = 0;
  var myPgCntrl = new PageController();

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
          // profileUrl = myVendorList[0]['ProfileImage'];


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


  @override
  void initState(){
    getVendor();
    getDetails();
    super.initState();
  }

  Future<void> getDetails() async{
    var pref = await SharedPreferences.getInstance();

    setState((){

      cakeName = pref.getString("cakeName")??"";
      cakePrice = pref.getString("cakePrice")??"";
      cakeDesc = pref.getString("cakeDesc")??"";
      egg = pref.getString("cakeEgg")??"";
      status = pref.getString("cakeStatus")??"";
      cake_id = pref.getString("cake_id")??"";
      cakeId = pref.getString("cakeId")??"";
      cakeCustomPossible = pref.getString("cakeCustomPoss")??"";
      cakeTierPoss = pref.getString("cakeTierPoss")??"";

       CakeImg=pref.getString("cakeImage")??'';

       CakeComName=pref.getString("CakeCommonName")??'';

       CakeType= pref.getString("CakeType")??'';
       CakeSubtype= pref.getString("CakeSubType")??'';
       IsEgglessPossible=   pref.getString("IsEgglessOptionAvailable")??'';
       BEgglesspricePerkg= pref.getString("BasicEgglessCostPerKg")??'';
       Discount=pref.getString("Discount")??'';
       Tax=pref.getString("Tax")??'';
       Created_On= pref.getString("Created_On")??'';
       MinTimeForDcake= pref.getString("MinTimeForDeliveryOfDefaultCake")??'';
       Cakebase= pref.getString("CakeBase")??'';
       CakeCream= pref.getString("CakeCream")??'';
       BestusedBefore=  pref.getString("BestUsedBefore")??'';
       Tobestorein= pref.getString("ToBeStoredIn")??'';
       MintimeForTierCake=pref.getString("MinTimeForDeliveryFortierCake")??'';
       ThemecakePossible=  pref.getString("ThemeCakePossible")??'';
       TopperPossible=pref.getString("ToppersPossible")??'';
       FullyCus=pref.getString("FullCustomisationPossible")??'';
       HowgoodWiththecake=pref.getString("HowGoodAreYouWithTheCake")??'';
       HowMTimesBaked=pref.getString("HowManyTimesHaveYouBakedThisParticularCake")??'';
       IstierPossible= pref.getString("IsTierCakePossible")??'';
      temp= pref.getString("keeproomtemp")??'';
      BasicCus = pref.getString("cakeCustomPoss")??'';

      Stock= pref.getString("Stock")??'';
      images = pref.getStringList('cakeImages')??[];
      weights = pref.getStringList('cakeWeight')??[];
      weights = weights.toSet().toList();

    profileUrl = pref.getString("profileImage")??'';


    });
  }

  Future<void> passDataToEdit() async{
    var pref = await SharedPreferences.getInstance();

    pref.remove("cakeEd_id");
    pref.remove("cakeEdId");
    pref.remove("cakeEdName");
    pref.remove("cakeEdPrice");
    pref.remove("cakeEdCustomPoss");
    pref.remove("cakeEdTierPoss");

    pref.setString("cakeEd_id", cake_id);
    pref.setString("cakeEdId", cakeId);
    pref.setString("cakeEdName", cakeName);
    pref.setString("cakeEdPrice", cakePrice);
    pref.setString("cakeEdTierPoss", cakeTierPoss);
    pref.setString("cakeEdCustomPoss", cakeCustomPossible);

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>EditCake(
          flavoursList: flavours,
          shapeList: shapes,
          tierList: tiers,
          weightList: weights,
        ))
    );
  }

  @override
  Widget build(BuildContext context) {
    if(context.watch<ContextClass>().getCakeUpdate()==true){
      cakePrice = context.watch<ContextClass>().getCakePrice();
      flavours = context.watch<ContextClass>().getFlavour();
      shapes = context.watch<ContextClass>().getShape();
      weights = context.watch<ContextClass>().getWeigth();
    }
    return WillPopScope(
      onWillPop: () async{
        context.read<ContextClass>().clearAllData();
        return true;
      },
      child: Scaffold(
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
                            'CAKE DETAILS',
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
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //cakeimage
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child:Stack(
                    children: [
                      PageView.builder(
                          controller: myPgCntrl,
                          itemCount: images.length,
                          itemBuilder: (c,i){
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: NetworkImage(images[i]),
                                      fit: BoxFit.cover
                                  )
                              ),
                            );
                          }
                      ),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Text("${pageViewCurIndex+1}/${images.length}"),
                      //       SizedBox(
                      //         height: 15,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding:EdgeInsets.only(right: 8, top: 5),
                                  child: RaisedButton(
                                    onPressed: ()=>passDataToEdit(),
                                    child: Text("EDIT" ,style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins"
                                    ),),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                      ),
                                      child:Row(
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
                                            '$egg',
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontFamily: "Poppins",
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ),

                SizedBox(height: 10,),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$cakeName" , style: TextStyle(
                      color: alertsAndColors.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize:17,
                      fontFamily: "Poppins"
                    ),),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "₹",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16
                            ),
                            children:[
                              TextSpan(
                                text: " $cakePrice",
                                style: TextStyle(
                                  color: alertsAndColors.lightPink,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ]
                          )
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: status.toLowerCase()=="new"?
                            Colors.red:status.toLowerCase()=="approved"?
                            Colors.green:Colors.grey[400],
                          ),
                          child:  Text("$status" , style: TextStyle(
                              color: Colors.white,
                              fontSize:14,
                              fontFamily: "Poppins"
                          ),),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    //descriptions
                    Text("$cakeDesc" , style: TextStyle(
                        color: Colors.grey[400],
                        fontSize:13,
                        fontFamily: "Poppins"
                    ),),
                    SizedBox(height: 10,),

                  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('CAKE INFO',style: TextStyle(fontFamily: "Poppins",color: alertsAndColors.darkBlue,fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                          Divider(height: 1,color: Colors.grey,),
                          SizedBox(height: 5,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child:  Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cake ID',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                                    Text(cakeId,style: TextStyle(fontFamily: "Poppins",),)
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cake Common Name',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                                    Text(CakeComName,style: TextStyle(fontFamily: "Poppins"),)
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cake Type',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                                    Text(CakeType,style: TextStyle(fontFamily: "Poppins"),)
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cake SubType',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                                    Text(CakeSubtype,style: TextStyle(fontFamily: "Poppins"),)
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Is Eggless Available',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                                    Text((IsEgglessPossible=='y')?'Yes':'No',style: TextStyle(fontFamily: "Poppins"),)
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Basic Eggles Cost Per kg',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                                    Text(BEgglesspricePerkg,style: TextStyle(fontFamily: "Poppins"),)
                                  ],
                                ),



                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //ui flavours
                                Text("FLAVOURS" , style: TextStyle(
                                    color: alertsAndColors.darkBlue,
                                    fontSize:15,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold
                                ),),
                                SizedBox(height: 6,),
                                Divider(
                                  height: 1,
                                  color: Colors.grey[400],
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: flavours.length,
                                  itemBuilder: (context , i){
                                    return Container(
                                        padding: EdgeInsets.all(4),
                                        child: Text.rich(
                                            TextSpan(
                                                text: "${flavours[i]["Name"]} - ",
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontFamily: "Poppins"
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: "Rs ${flavours[i]['Price']}",
                                                    style: TextStyle(
                                                        color: alertsAndColors.darkBlue,
                                                        fontFamily: "Poppins",
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                                ]
                                            )
                                        )
                                    );
                                  },
                                ),
                              ],
                            ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //ui shapes
                                  Text("SHAPES" , style: TextStyle(
                                      color: alertsAndColors.darkBlue,
                                      fontSize:15,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(height: 6,),
                                  Divider(
                                    height: 1,
                                    color: Colors.grey[400],
                                  ),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: shapes.length,
                                    itemBuilder: (context , i){
                                      return Container(
                                          padding: EdgeInsets.all(4),
                                          child: Text.rich(
                                              TextSpan(
                                                  text: "${shapes[i]["Name"]} - ",
                                                  style: TextStyle(
                                                      color: Colors.grey[400],
                                                      fontFamily: "Poppins"
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: "Rs ${shapes[i]['Price']}",
                                                      style: TextStyle(
                                                          color: alertsAndColors.darkBlue,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    )
                                                  ]
                                              )
                                          )
                                      );
                                    },
                                  ),
                                ],
                              ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //ui weight
                                    Text("WEIGHT" , style: TextStyle(
                                        color: alertsAndColors.darkBlue,
                                        fontSize:15,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold
                                    ),),
                                    SizedBox(height: 6,),
                                    Divider(
                                      height: 1,
                                      color: Colors.grey[400],
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: weights.length,
                                      itemBuilder: (context , i){
                                        return Container(
                                            padding: EdgeInsets.all(4),
                                            child: Text.rich(
                                                TextSpan(
                                                    text: "${weights[i]}",
                                                    style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontFamily: "Poppins"
                                                    ),
                                                    children: [
                                                      // TextSpan(
                                                      //   text: "Rs 20",
                                                      //   style: TextStyle(
                                                      //       color: alertsAndColors.darkBlue,
                                                      //       fontFamily: "Poppins",
                                                      //       fontWeight: FontWeight.bold
                                                      //   ),
                                                      // )
                                                    ]
                                                )
                                            )
                                        );
                                      },
                                    ),
                                    SizedBox(height: 5,),
                                  ],
                                ),

                                //ui toppers

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("TIERS" , style: TextStyle(
                                        color: alertsAndColors.darkBlue,
                                        fontSize:15,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold
                                    ),),
                                    SizedBox(height: 6,),
                                    Divider(
                                      height: 1,
                                      color: Colors.grey[400],
                                    ),
                                    tiers.isNotEmpty?
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: tiers.length,
                                      itemBuilder: (context , i){
                                        return Container(
                                            padding: EdgeInsets.all(4),
                                            child: Text.rich(
                                                TextSpan(
                                                    text: "${tiers[i]["Tier"]} - ",
                                                    style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontFamily: "Poppins"
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: "Rs ${tiers[i]['Price']}/${tiers[i]['Weight']}",
                                                        style: TextStyle(
                                                            color: alertsAndColors.darkBlue,
                                                            fontFamily: "Poppins",
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      )
                                                    ]
                                                )
                                            )
                                        );
                                      },
                                    ):
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text("No Tiers :(",style:  TextStyle(
                                          color: Colors.grey[400],
                                          fontFamily: "Poppins",
                                          fontSize: 16
                                      ),),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PRICE INFO',style: TextStyle(fontFamily: "Poppins",color: alertsAndColors.darkBlue,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Divider(height: 1,color: Colors.grey,),
                        SizedBox(height: 5,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child:  Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Availability',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins"),),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (Stock=='InStock')?Colors.green:Colors.red
                                    ),
                                      child: Text(Stock,style: TextStyle(fontFamily: "Poppins",color: Colors.white),)
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Discount',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins"),),
                                  Text('$Discount'+' %',style: TextStyle(fontFamily: "Poppins"),)
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tax',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins"),),
                                  Text('$Tax' +' %',style: TextStyle(fontFamily: "Poppins"),)
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Created On',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins"),),
                                  Text(Created_On,style: TextStyle(fontFamily: "Poppins"),)
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                        Text('OTHER INFO',style: TextStyle(fontFamily: "Poppins",color: alertsAndColors.darkBlue,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Divider(height: 1,color: Colors.grey,),
                        SizedBox(height: 5,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Minimum Delivery Time for Default Cake',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                            Text('$MinTimeForDcake',style: TextStyle(fontFamily: "Poppins"),)
                          ],
                        ),

                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cake Base',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text('$Cakebase',style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cake Cream',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text(CakeCream,style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Best Used Before',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text(BestusedBefore,style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('To be Stored In',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text(Tobestorein,style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Minimum Time for keep the  Cake in Room Temperator',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text(temp,style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Theme Cake Possible',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text((ThemecakePossible=='y')?'Yes':'No',style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Topper Possible',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text((TopperPossible=='y')?'Yes':'No',style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Basic Customize Possible',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text((BasicCus=='y')?'Yes':'No',style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fully Customize Possible',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text((FullyCus=='y')?'Yes':'No',style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('How Good Are you with the cake',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text(HowgoodWiththecake,style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('How Many times You Bake the cake',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text(HowMTimesBaked,style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(height: 1,color: Colors.grey,),
                    SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Is Tier Cake Possible',style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),),
                        Text((IstierPossible=='y')?'Yes':'No',style: TextStyle(fontFamily: "Poppins"),)
                      ],
                    ),
                    SizedBox(height: 20,),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
