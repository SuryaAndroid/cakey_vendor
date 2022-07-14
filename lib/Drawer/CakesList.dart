import 'dart:convert';
import 'dart:io';
import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:cakey_vendor/Drawer/CakeDetails.dart';
import 'package:cakey_vendor/Drawer/MainDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../ContextClass.dart';

class CakesList extends StatefulWidget {
  const CakesList({Key? key}) : super(key: key);
  @override
  State<CakesList> createState() => _CakesListState();
}

class _CakesListState extends State<CakesList> {

  var drawerKey = new GlobalKey<ScaffoldState>();
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  int isCtClickedIndex = 0;
  List cakeList = [];
  List filteredCakeList = [];
  var cakeTypes = [];
  var vendorMail = "";
  var vendorId;
  var authToken = "";
  var filteredCakeType = "";
  bool loading = true;

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration.zero , () async{
      getInitialPrefs();
    });
  }

  Future<void> getInitialPrefs() async{
    var prefs = await SharedPreferences.getInstance();

    this.setState(() {
      authToken = prefs.getString("authToken")??"null";
      vendorMail = prefs.getString("authMail")??"null";
    });

    print(authToken);
    print(vendorMail);
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
          Uri.parse('https://cakey-database.vercel.app/api/vendors/listbyemail/$vendorMail'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

          list = jsonDecode(await response.stream.bytesToString());

          setState((){
            vendorId = list[0]['_id'];
          });

          getCakes(vendorId);

          Navigator.pop(context);

      }
      else {
        checkNetwork();
        setState((){
          loading = false;
        });
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
      setState((){
        loading = false;
      });
      Navigator.pop(context);
    }

  }

  Future<void> getCakes(String id) async{
    var list = [];
    try{

      var headers = {
        'Authorization': '$authToken'
      };
      var request = http.Request('GET',
          Uri.parse('https://cakey-database.vercel.app/api/cake/listbyId/$id'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        list = jsonDecode(await response.stream.bytesToString());

        setState((){
          cakeList = list.reversed.toList();
          for(int i = 0 ; i<cakeList.length;i++){
            if(i==0){
              cakeTypes.add("All Cakes");
            }
            cakeTypes.add(cakeList[i]['CakeType']);
          }

          cakeTypes = cakeTypes.toSet().toList();

          print(cakeList);

          setState((){
            loading = false;
          });

        });
      }
      else {
        print(response.reasonPhrase);
        setState((){
          loading = false;
        });
      }

    }catch(e){
      checkNetwork();
      setState((){
        loading = false;
      });
      print(e);
    }

  }

  Future<void> passDetails(int i) async{

    var pref = await SharedPreferences.getInstance();

    //img
    List images = filteredCakeList[i]['AdditionalCakeImages'].toList();
    List<String> shareImg = [];

    //wei
    List weights = filteredCakeList[i]['MinWeightList'].toList();
    List<String> shareWeight = [];

    //flav
    List flavs = filteredCakeList[i]['CustomFlavourList'].toList();

    if(flavs.isEmpty){
      flavs.add({"Name":"${filteredCakeList[i]['BasicFlavour']}" , "Price":"0"});
    }else{
      flavs.insert(0, {"Name":"${filteredCakeList[i]['BasicFlavour']}" , "Price":"0"});
    }

    //flav
    List shapes = filteredCakeList[i]['CustomShapeList']["Info"].toList();

    if(shapes.isEmpty){
      shapes.add({"Name":"${filteredCakeList[i]['BasicShape']}" , "Price":"0"});
    }else{
      shapes.insert(0, {"Name":"${filteredCakeList[i]['BasicShape']}" , "Price":"0"});
    }

    //Tiers
    List tiers = filteredCakeList[i]['TierCakeMinWeightAndPrice'].toList();

    //img
    if(images.isEmpty){
      shareImg.add(filteredCakeList[i]['MainCakeImage'].toString());
    }else{
      for(int i = 0 ; i<images.length;i++){
        shareImg.add(images[i].toString());
      }
      shareImg.insert(0, filteredCakeList[i]['MainCakeImage'].toString());
    }

    //weight
    if(weights.isEmpty){
      shareWeight.add(filteredCakeList[i]['MinWeight'].toString());
    }else{
      for(int i = 0 ; i<weights.length;i++){
        shareWeight.add(weights[i].toString());
      }
      shareWeight.insert(0, filteredCakeList[i]['MinWeight'].toString());
    }


    pref.remove("cakeName");
    pref.remove("cakeImage");
    pref.remove("cakePrice");
    pref.remove("cakeEgg");
    pref.remove("cakeDesc");
    pref.remove("cakeStatus");
    pref.remove("cakeImages");
    pref.remove("cakeWeight");
    pref.remove("cake_id");
    pref.remove("cakeId");
    pref.remove("cakeTierPoss");
    pref.remove("cakeCustomPoss");


    pref.setString("cakeName", filteredCakeList[i]['CakeName']);
    pref.setString("cakeImage", filteredCakeList[i]['MainCakeImage']);
    pref.setString("cakePrice", filteredCakeList[i]['BasicCakePrice']);
    pref.setString("cakeEgg", filteredCakeList[i]['DefaultCakeEggOrEggless']);
    pref.setString("cakeDesc", filteredCakeList[i]['Description']);
    pref.setString("cakeStatus", filteredCakeList[i]['Status']);
    pref.setString("cake_id", filteredCakeList[i]['_id']);
    pref.setString("cakeId", filteredCakeList[i]['Id']);
    pref.setString("cakeTierPoss", filteredCakeList[i]['IsTierCakePossible']);
    pref.setString("cakeCustomPoss", filteredCakeList[i]['BasicCustomisationPossible']);


    pref.setStringList("cakeImages", shareImg);
    pref.setStringList("cakeWeight", shareWeight);


    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>CakeDetails(
          flavours: flavs,
          shapes: shapes,
          tiers: tiers,
        ))
    );

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
  Widget build(BuildContext context) {
    if(filteredCakeType == "all cakes"){
      filteredCakeList = cakeList;
    }else{
      filteredCakeList = cakeList.
      where((element) => element['CakeType'].toString().toLowerCase().contains(filteredCakeType)).toList();
    }

    return Scaffold(
      key: drawerKey,
      drawer: MainDrawer(),
      appBar: PreferredSize(
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
                          print("Drawer");
                          FocusScope.of(context).unfocus();
                          drawerKey.currentState?.openDrawer();
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 5.2,
                                    backgroundColor: alertsAndColors.darkBlue,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  CircleAvatar(
                                    radius: 5.2,
                                    backgroundColor: alertsAndColors.darkBlue,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      radius: 5.2, backgroundColor: alertsAndColors.darkBlue),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  CircleAvatar(
                                    radius: 5.2,
                                    backgroundColor: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          'CAKE LIST',
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

                          },
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
        padding: EdgeInsets.all(2),
        child:RefreshIndicator(
          onRefresh: () async{
            getInitialPrefs();
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Cake types List...
                Container(
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cakeTypes.length,
                      shrinkWrap: true,
                      itemBuilder: (c , i){
                        return InkWell(
                          onTap: (){
                            setState(() {
                              isCtClickedIndex = i;
                              filteredCakeType = cakeTypes[i].toString().toLowerCase();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 10 , right: 10),
                            decoration: BoxDecoration(
                              color: isCtClickedIndex==i?Colors.red[50]:Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.pink , width: 1)
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.cake_outlined , color: Colors.pink,),
                                SizedBox(width: 10,),
                                Text("${cakeTypes[i]}" , style: TextStyle(
                                  color: alertsAndColors.darkBlue ,
                                  fontFamily: "Poppins"
                                ),)
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                ),
                cakeList.length>0?
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(8.0),
                            crossAxisCount: 2,
                            mainAxisSpacing: 6,
                            // crossAxisSpacing: 2,
                            itemCount:filteredCakeList.length,
                            itemBuilder: (c , i){
                              if(i==0){
                                return GestureDetector(
                                  onTap: ()=>passDetails(i),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Text("We Have"  , style: TextStyle(
                                          color: alertsAndColors.darkBlue,
                                          fontFamily: "Poppins"
                                      ),maxLines: 2,textAlign: TextAlign.center,),
                                      Text("${filteredCakeList.length} Items"  , style: TextStyle(
                                          color: alertsAndColors.darkBlue,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),maxLines: 2,textAlign: TextAlign.center,),
                                      SizedBox(height: 15,),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        color: Colors.white,
                                        elevation: 4,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage("${filteredCakeList[i]['MainCakeImage']}"),
                                                        fit: BoxFit.cover
                                                    )
                                                ),
                                              ),
                                              SizedBox(height: 15,),
                                              Text("${filteredCakeList[i]['CakeName']}"  , style: TextStyle(
                                                  color: alertsAndColors.darkBlue,
                                                  fontFamily: "Poppins"
                                              ),maxLines: 2,textAlign: TextAlign.center,),
                                              SizedBox(height: 15,),
                                              Container(
                                                padding: EdgeInsets.only(left: 5, right: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("₹ ${filteredCakeList[i]['BasicCakePrice']}" , style: TextStyle(
                                                        color: alertsAndColors.lightPink ,
                                                        fontFamily: "Poppins"
                                                    ),),
                                                    Container(
                                                      padding: EdgeInsets.all(3),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey[200],
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      child: Text("${filteredCakeList[i]['MinWeight']}"),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }else{
                                return GestureDetector(
                                  onTap: ()=>passDetails(i),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    color: Colors.white,
                                    elevation: 4,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage("${filteredCakeList[i]['MainCakeImage']}"),
                                                    fit: BoxFit.cover
                                                )
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Text("${filteredCakeList[i]['CakeName']}"  , style: TextStyle(
                                              color: alertsAndColors.darkBlue,
                                              fontFamily: "Poppins"
                                          ),maxLines: 2,textAlign: TextAlign.center,),
                                          SizedBox(height: 15,),
                                          Container(
                                            padding: EdgeInsets.only(left: 5, right: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("₹ ${filteredCakeList[i]['BasicCakePrice']}" , style: TextStyle(
                                                    color: alertsAndColors.lightPink ,
                                                    fontFamily: "Poppins"
                                                ),),
                                                Container(
                                                  padding: EdgeInsets.all(3),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: Text("${filteredCakeList[i]['MinWeight']}"),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.fit(1),
                          )
                        ]
                      ),
                    ),
                  ),
                ):
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(!loading?Icons.not_interested_rounded:Icons.hourglass_empty, size: 40,color: Colors.red,) ,
                        SizedBox(height: 20,),
                        Text(!loading?"No Cakes Found":"Loading...",style: TextStyle(
                            color: alertsAndColors.lightPink,
                            fontFamily: "Poppins",
                            fontSize: 18
                        ),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ),

      ),
    );
  }
}
