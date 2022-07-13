import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../CommonClass/AlertsAndColors.dart';

class EditCake extends StatefulWidget {

  List flavoursList , shapeList , tierList ,weightList;
  EditCake({required this.flavoursList, required this.shapeList, required this.tierList,required this.weightList});

  @override
  State<EditCake> createState() => _EditCakeState(
    flavoursList: flavoursList,
    shapeList: shapeList,
    tierList: tierList,
    weightList: weightList
  );
}

class _EditCakeState extends State<EditCake> {

  List flavoursList , shapeList , tierList ,weightList;
  _EditCakeState({required this.flavoursList, required this.shapeList, required this.tierList,required this.weightList});

  //common
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  var drawerKey = GlobalKey<ScaffoldState>();

  //controllers
  var cakePrice = new TextEditingController(text: "200");
  var extraShapeCtrl = new TextEditingController();
  var threekgCtrl = TextEditingController();
  var fvkgCtrl = TextEditingController();

  //Strings
  String authToken= "";
  String cakeName ="";
  String cake_id = "";
  String cakeId = "";
  String cakeCustomPossible = "";
  String cakeTierPoss = "";
  String stocks = "Instock";
  String tierPoss = "No";
  String basicCus = "No";
  String threekgHourorMin = "Hour";
  String fvkgHourorMin = "Hour";

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

  /*tier*/
  List tiers = ["2 Tier", "3 Tier", "4 Tier"];
  List<bool> isTierTapped = [];
  List<TextEditingController> tierWeightEditors = [];
  List<TextEditingController> tierPriceEditors = [];
  List fixedTierList = [];
  List<TextEditingController> tierMinTimeEditor = [];
  List selectedTierDropItem = [];
  List fixedMinTimeTires = [];

  //

  //getVendors
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

  Future<void> getEditData() async{
    var pref = await SharedPreferences.getInstance();

    setState((){
      authToken = pref.getString("authToken")??"null";
      currentVendorMail = pref.getString("authMail")??"null";
      cakeName = pref.getString("cakeEdName")??"null";
      cakePrice.text = pref.getString("cakeEdPrice")??"null";
      cake_id = pref.getString("cakeEd_id")??"null";
      cakeId = pref.getString("cakeEdId")??"null";
      cakeCustomPossible = pref.getString("cakeEdCustomPoss")??"null";
      cakeTierPoss = pref.getString("cakeEdTierPoss")??"null";

      print(cakeCustomPossible);
      print(cakeTierPoss);

      if(cakeCustomPossible.toLowerCase()=="n"){
        basicCus = "No";
      }else{
        basicCus = "Yes";
      }

      if(cakeTierPoss.toLowerCase()=="n"){
        tierPoss = "No";
      }else{
        tierPoss = "Yes";
      }

    });
    getVendor();
    getShapes();
  }

  //getShapes
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
        shapeList.removeWhere((element) => element['Price']=="0");
        for(int i = 0 ; i<shapeList.length;i++){
          fixedShapeList.add(shapeList[i]);
        }
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

  //getflavs
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
        flavoursList.removeWhere((element) => element['Price']=="0");
        for(int i = 0 ; i<flavoursList.length;i++){
          fixedFlavList.add(flavoursList[i]);
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

  //getWeights
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
        for(int i = 0 ; i<weightList.length;i++){
          fixedWeightList.add(weightList[i]);
        }
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

  //setup tiers
  void setUpTiers(){

    print(tierList);

    setState((){
      for (int i = 0 ; i<tierList.length;i++){
        fixedTierList.add({
          "Tier":"${tierList[i]["Tier"]}",
          "Price":"${tierList[i]["Price"]}",
          "Weight":"${tierList[i]["Weight"]}"
        });
      }
    });
  }

  //update cake
  Future<void> updateCake() async{

    alertsAndColors.showLoader(context);

    List tempWeight = fixedWeightList;
    List tempFlav = fixedFlavList;
    List tempShape = fixedShapeList;

    // print("wei $fixedWeightList");
    // print("flav $fixedFlavList");
    // print("shape $fixedShapeList");

    //stringifying
    jsonEncode(tempWeight);
    jsonEncode(tempFlav);
    jsonEncode(tempShape);

    print({
      'CustomFlavourList': jsonEncode(tempFlav),
      'CustomShapeList': jsonEncode(tempShape),
      'MinWeightList': jsonEncode(tempWeight),
      'Vendor_ID': currentVendorId,
      'VendorName': currentVendorName,
      'VendorPhoneNumber1': currentVendorPhn1,
      'VendorPhoneNumber2': currentVendorPhn2,
      'Street': currentVendorStreet,
      'City': currentVendorCity,
      'State': currentVendorState,
      'Pincode': currentVendorPin,
      'Stock': stocks,
      'OldSampleImages': '[""]',
      'VendorID': currentVendor_id,
      'BasicCustomisationPossible': basicCus.toLowerCase()=="yes"?'y':'n',
      'BasicCakePrice': cakePrice.text.toString()
    });


    try{
      var request = http.MultipartRequest('PUT', Uri.parse('https://cakey-database.vercel.app/api/cake/update/$cake_id'));
      request.fields.addAll({
        'CustomFlavourList': jsonEncode(tempFlav),
        'CustomShapeList': jsonEncode(tempShape),
        'MinWeightList': jsonEncode(tempWeight),
        'Vendor_ID': currentVendorId,
        'VendorName': currentVendorName,
        'VendorPhoneNumber1': currentVendorPhn1,
        'VendorPhoneNumber2': currentVendorPhn2,
        'Street': currentVendorStreet,
        'City': currentVendorCity,
        'State': currentVendorState,
        'Pincode': currentVendorPin,
        'Stock': stocks,
        'OldSampleImages': '[""]',
        'VendorID': currentVendor_id,
        'BasicCustomisationPossible': basicCus.toLowerCase()=="yes"?'y':'n',
        'BasicCakePrice': cakePrice.text.toString()
      });

      if(fixedWeightList.contains("3Kg")||fixedWeightList.contains("3kg")||
          fixedWeightList.contains("3KG")){
        request.fields.addAll({
          'MinTimeForDeliveryOfA3KgCake': "${threekgCtrl.text}${threekgHourorMin.toLowerCase()}",
        });
      }

      if(fixedWeightList.contains("5Kg")||fixedWeightList.contains("5kg")||
          fixedWeightList.contains("5KG")){
        request.fields.addAll({
          'MinTimeForDeliveryOfA5KgCake': "${fvkgCtrl.text}${fvkgHourorMin.toLowerCase()}",
        });
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var map = jsonDecode(await response.stream.bytesToString());

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${map["message"]}"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            )
        );

        Navigator.pop(context);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error Occurred"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            )
        );
        Navigator.pop(context);
        print(response.reasonPhrase);
      }

    }catch(e){
      checkNetwork();
      Navigator.pop(context);
    }

  }

  void validateInputs(){
    if(fixedWeightList.contains("3kg")&&threekgCtrl.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter minimum delivery time of 3kg"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(fixedWeightList.contains("5kg")&&fvkgCtrl.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter minimum delivery time of 5kg"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else{
      updateCake();
    }
  }


  @override
  void initState(){
    Future.delayed(Duration.zero ,() async{
      getEditData();
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
                          'CAKE EDIT',
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
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //col start
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 7),
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text("$cakeName",
                        style: TextStyle(
                        color: alertsAndColors.darkBlue,
                        fontFamily: "Poppins",
                         fontWeight: FontWeight.bold,
                         fontSize: 16
                      ),),
                    ),
                    Positioned(
                        top: -4,
                        left: 12,
                        child: Text(
                          "Cakename",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                              backgroundColor: Colors.white),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              TextField(
                controller: cakePrice,
                style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Cake Price",
                  label: Text("Cake Price"),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 1, color: Colors.grey)
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              //stock
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 7),
                      height: 55,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: DropdownButton(
                          value: "$stocks",
                          isExpanded: true,
                          underline: Container(),
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                                value: "Instock",
                                child: Text("Instock")
                            ),
                            DropdownMenuItem(
                                value: "Out of stock",
                                child: Text("Out of stock")
                            ),
                          ],
                          onChanged: ((item)=>setState((){
                            stocks = item.toString();
                          }))
                      ),
                    ),
                    Positioned(
                        top: -4,
                        left: 12,
                        child: Text(
                          "Stocks",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                              backgroundColor: Colors.white),
                        )),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              /*Tiers*/
              //Tier possible
              // Container(
              //   padding: EdgeInsets.only(top: 5),
              //   child: Stack(
              //     children: [
              //       Container(
              //         height: 55,
              //         margin: EdgeInsets.only(top: 7),
              //         width: double.infinity,
              //         padding: EdgeInsets.only(left: 10,right: 10),
              //         decoration: BoxDecoration(
              //             border: Border.all(color: Colors.grey, width: 1),
              //             borderRadius: BorderRadius.circular(15)
              //         ),
              //         child: DropdownButton(
              //             value: "$tierPoss",
              //             isExpanded: true,
              //             underline: Container(),
              //             items: <DropdownMenuItem<String>>[
              //               DropdownMenuItem(
              //                   value: "No",
              //                   child: Text("No")
              //               ),
              //               DropdownMenuItem(
              //                   value: "Yes",
              //                   child: Text("Yes")
              //               ),
              //             ],
              //             onChanged: ((item)=>setState((){
              //               tierPoss = item.toString();
              //             }))
              //         ),
              //       ),
              //       Positioned(
              //           top: -4,
              //           left: 12,
              //           child: Text(
              //             "Tier Possible",
              //             style: TextStyle(
              //                 color: Colors.grey,
              //                 fontFamily: "Poppins",
              //                 backgroundColor: Colors.white),
              //           )),
              //     ],
              //   ),
              // ),
              // //tiers
              // tierPoss.toLowerCase()=='yes'?
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     SizedBox(height: 10,),
              //     Container(
              //       padding: EdgeInsets.only(top: 5),
              //       child: Stack(
              //         children: [
              //           Container(
              //             margin:EdgeInsets.only(top: 5),
              //             padding: EdgeInsets.all(7),
              //             decoration: BoxDecoration(
              //                 border: Border.all(color: Colors.grey , width: 1),
              //                 borderRadius: BorderRadius.circular(15)
              //             ),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 SizedBox(height: 5,),
              //                 Wrap(
              //                   spacing: 3,
              //                   children:fixedTierList.map((e){
              //                     return ActionChip(
              //                         label: Row(
              //                           crossAxisAlignment: CrossAxisAlignment.center,
              //                           mainAxisSize: MainAxisSize.min,
              //                           children: [
              //                             Text("${e['Tier']} - ${e['Price']}/${e['Weight']}", style: TextStyle(
              //                                 color: alertsAndColors.darkBlue,
              //                                 fontFamily: "Poppins"
              //                             ),),
              //                             SizedBox(width: 3,),
              //                             Icon(Icons.check_circle , size: 18,color: Colors.green,)
              //                           ],
              //                         ),
              //                         onPressed: ()=>setState((){
              //                           fixedTierList.remove(e);
              //                         })
              //                     );
              //                   }).toList(),
              //                 ),
              //                 SizedBox(height: 10,),
              //                 ListView.builder(
              //                     itemCount: tiers.length,
              //                     shrinkWrap: true,
              //                     physics: NeverScrollableScrollPhysics(),
              //                     itemBuilder: (c, i){
              //                       isTierTapped.add(false);
              //                       tierWeightEditors.add(new TextEditingController());
              //                       tierPriceEditors.add(new TextEditingController());
              //                       //List<TextEditingController> tierMinTimeEditor = [];
              //                       //   List selectedTierDropItem = [];
              //                       //   List fixedMinTimeTires = [];
              //                       return Container(
              //                         padding: EdgeInsets.only(left: 7 , right: 7 , top: 5 , bottom: 5),
              //                         child: Column(
              //                           children: [
              //                             Row(
              //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                               children: [
              //                                 Row(
              //                                   children: [
              //                                     isTierTapped[i]==true?
              //                                     GestureDetector(
              //                                       onTap: ()=>setState((){
              //                                         if(fixedTierList.isNotEmpty){
              //                                           fixedTierList.removeWhere((element) => element['Tier']
              //                                               ==tiers[i]);
              //                                           tierWeightEditors[i].text = "";
              //                                           tierPriceEditors[i].text = "";
              //                                           isTierTapped[i]=false;
              //                                           print(fixedTierList);
              //                                         }else{
              //                                           tierMinTimeEditor.clear();
              //                                           fixedMinTimeTires.clear();
              //                                           tierWeightEditors[i].text = "";
              //                                           tierPriceEditors[i].text = "";
              //                                           isTierTapped[i]=false;
              //                                         }
              //                                         print(fixedTierList);
              //                                       }),
              //                                       child: Icon(Icons.remove_circle , color: Colors.red,),
              //                                     ):Container(),
              //                                     SizedBox(width: 5,),
              //                                     Text("${tiers[i]}" ,style: TextStyle(
              //                                         color: Colors.grey,
              //                                         fontFamily: "Poppins"
              //                                     ),),
              //                                   ],
              //                                 ),
              //                                 isTierTapped[i]==false?
              //                                 GestureDetector(
              //                                   onTap: ()=>setState((){
              //                                     isTierTapped[i] = true;
              //                                   }),
              //                                   child: Icon(Icons.add_circle , color: Colors.green,),
              //                                 ):
              //                                 Row(
              //                                   children: [
              //                                     Text("Weight",style: TextStyle(
              //                                         fontFamily: "Poppins"
              //                                     ),),
              //                                     SizedBox(width: 3,),
              //                                     Container(
              //                                       height: 30,
              //                                       width:45,
              //                                       child: TextField(
              //                                         controller: tierWeightEditors[i],
              //                                         onEditingComplete: (){
              //                                           print("Completed...");
              //                                           setState((){
              //
              //                                           });
              //
              //                                           print(fixedFlavList.toSet().toList());
              //                                         },
              //                                         onSubmitted: (e){
              //                                           FocusScope.of(context).unfocus();
              //                                         },
              //                                         decoration: InputDecoration(
              //                                             border: OutlineInputBorder(
              //                                               borderRadius: BorderRadius.circular(10),
              //                                             ),
              //                                             contentPadding: EdgeInsets.only(left: 6)
              //                                         ),
              //                                       ),
              //                                     ),
              //                                     SizedBox(width: 3,),
              //                                     Text("Price",style: TextStyle(
              //                                         fontFamily: "Poppins"
              //                                     ),),
              //                                     SizedBox(width: 3,),
              //                                     Container(
              //                                       height: 30,
              //                                       width:45,
              //                                       child: TextField(
              //                                         controller: tierPriceEditors[i],
              //                                         onEditingComplete: (){
              //                                           print("Completed...");
              //                                           setState((){
              //                                             if(tierPriceEditors[i].text.isNotEmpty&&
              //                                                 tierWeightEditors[i].text.isNotEmpty){
              //                                               fixedTierList.add(
              //                                                   {
              //                                                     "Tier":'${tiers[i]}',
              //                                                     "Price":'${tierPriceEditors[i].text}',
              //                                                     "Weight":"${tierWeightEditors[i].text}kg"
              //                                                   }
              //                                               );
              //                                             }
              //
              //                                             print(fixedTierList);
              //                                           });
              //
              //                                         },
              //                                         onSubmitted: (e){
              //                                           FocusScope.of(context).unfocus();
              //                                         },
              //                                         decoration: InputDecoration(
              //                                             border: OutlineInputBorder(
              //                                               borderRadius: BorderRadius.circular(10),
              //                                             ),
              //                                             contentPadding: EdgeInsets.only(left: 6)
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 )
              //                               ],
              //                             ),
              //                             SizedBox(height: 5,),
              //                             Divider(height: 1,color: Colors.grey,)
              //                           ],
              //                         ),
              //                       );
              //                     }
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Positioned(
              //               left: 12,
              //               top: -5,
              //               child: Text(
              //                 "Tires",
              //                 style: TextStyle(
              //                     color: Colors.grey,
              //                     fontFamily: "Poppins",
              //                     backgroundColor: Colors.white
              //                 ),
              //               )
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(height: 10,),
              //   ],
              // ):Container(),
              //
              // SizedBox(
              //   height: 10,
              // ),

              Container(
                padding: EdgeInsets.only(top: 5),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 55,
                      margin: EdgeInsets.only(top: 7),
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      // child: DropdownButton(
                      //     value: "$basicCus",
                      //     isExpanded: true,
                      //     underline: Container(),
                      //     items: <DropdownMenuItem<String>>[
                      //       DropdownMenuItem(
                      //           value: "No",
                      //           child: Text("No")
                      //       ),
                      //       DropdownMenuItem(
                      //           value: "Yes",
                      //           child: Text("Yes")
                      //       ),
                      //     ],
                      //     onChanged: ((item)=>setState((){
                      //       basicCus = item.toString();
                      //     }))
                      // ),
                      child: Text("$basicCus",style: TextStyle(
                        color: alertsAndColors.darkBlue,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    Positioned(
                        top: -4,
                        left: 12,
                        child: Text(
                          "Basic Customisations",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                              backgroundColor: Colors.white),
                        )),
                  ],
                ),
              ),

              //flavs
              basicCus.toLowerCase()=="yes"?
              Column(
                children: [
                  SizedBox(height: 10,),
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
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                        height: 45,
                                        child: TextField(
                                          controller: extraShapeCtrl,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: 5),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
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
                                      },
                                      child: Text("ADD" , style: TextStyle(
                                          color: Colors.white
                                      ),),
                                    ),
                                  ))
                                ],
                              ),
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
                                        fixedFlavList.remove(e);
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
              ):Container(),

              //shapes
              basicCus.toLowerCase()=="yes"?
              Column(
                children: [
                  SizedBox(height: 10,),
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
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                        height: 45,
                                        child: TextField(
                                          controller: extraShapeCtrl,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: 5),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
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
                                      },
                                      child: Text("ADD" , style: TextStyle(
                                          color: Colors.white
                                      ),),
                                    ),
                                  ))
                                ],
                              ),
                              SizedBox(height: 5,),
                              Wrap(
                                spacing: 3,
                                children:fixedShapeList.map((e){
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
                                        try{
                                          fixedShapeList.remove(e);
                                        }catch(er){
                                          print(er);
                                        }
                                        print(fixedShapeList);
                                        print(shapeList);
                                      })
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10,),
                              ListView.builder(
                                  itemCount: spareShapeList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (c, i){
                                    isShapetTapped.add(false);
                                    shapeEditors.add(new TextEditingController());
                                    if(spareShapeList[i]['Price']!=null){
                                      shapeEditors[i].text=spareShapeList[i]['Price'].toString();
                                    }
                                    return Container(
                                      padding: EdgeInsets.only(left: 7 , right: 7 , top: 5 , bottom: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  isShapetTapped[i]==true?
                                                  GestureDetector(
                                                    onTap: ()=>setState((){
                                                      if(fixedShapeList.isNotEmpty){
                                                        fixedShapeList.removeWhere((element) => element['Name']
                                                            ==spareShapeList[i]['Name']);
                                                        shapeEditors[i].text = "";
                                                        isShapetTapped[i]=false;
                                                        print(fixedShapeList);
                                                      }else{
                                                        shapeEditors[i].text = "";
                                                        isShapetTapped[i]=false;
                                                      }
                                                    }),
                                                    child: Icon(Icons.remove_circle , color: Colors.red,),
                                                  ):Container(),
                                                  SizedBox(width: 5,),
                                                  Text("${spareShapeList[i]['Name']}" ,style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "Poppins"
                                                  ),),
                                                ],
                                              ),
                                              isShapetTapped[i]==false?
                                              GestureDetector(
                                                onTap: ()=>setState((){
                                                  isShapetTapped[i] = true;
                                                }),
                                                child: Icon(Icons.add_circle , color: Colors.green,),
                                              ):
                                              Container(
                                                height: 30,
                                                width:45,
                                                child: TextField(
                                                  controller: shapeEditors[i],
                                                  onEditingComplete: (){
                                                    print("Completed...");
                                                    setState((){
                                                      if(shapeEditors[i].text.isNotEmpty){
                                                        fixedShapeList.add(
                                                            {
                                                              "Name":'${spareShapeList[i]['Name']}',
                                                              "Price":'${shapeEditors[i].text}',
                                                            }
                                                        );
                                                      }
                                                    });
                                                    print(fixedShapeList.toSet().toList());
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
                              "Shapes",
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
              ):Container(),

              //weights
              basicCus.toLowerCase()=="yes"?
              Column(
                children: [
                  SizedBox(height: 10,),
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
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                        height: 45,
                                        child: TextField(
                                          controller: extraShapeCtrl,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: 5),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
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
                                      },
                                      child: Text("ADD" , style: TextStyle(
                                          color: Colors.white
                                      ),),
                                    ),
                                  ))
                                ],
                              ),
                              SizedBox(height: 5,),
                              Wrap(
                                spacing: 3,
                                children:fixedWeightList.map((e){
                                  return ActionChip(
                                      label: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(e.toString(), style: TextStyle(
                                              color: alertsAndColors.darkBlue,
                                              fontFamily: "Poppins"
                                          ),),
                                          SizedBox(width: 3,),
                                          Icon(Icons.check_circle , size: 18,color: Colors.green,)
                                        ],
                                      ),
                                      onPressed: ()=>setState((){
                                        fixedWeightList.remove(e);
                                      })
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10,),
                              ListView.builder(
                                  itemCount: spareWeightList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (c, i){
                                    isWeightTapped.add(false);
                                    weightEditors.add(new TextEditingController());
                                    return Container(
                                      padding: EdgeInsets.only(left: 7 , right: 7 , top: 5 , bottom: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  isWeightTapped[i]==true?
                                                  GestureDetector(
                                                    onTap: ()=>setState((){
                                                      if(fixedWeightList.isNotEmpty){
                                                        fixedWeightList.removeWhere((element) => element
                                                            ==spareWeightList[i]['Weight']);
                                                        isWeightTapped[i]=false;
                                                        print(fixedWeightList);
                                                      }else{
                                                        isWeightTapped[i]=false;
                                                      }
                                                    }),
                                                    child: Icon(Icons.remove_circle , color: Colors.red,),
                                                  ):Container(),
                                                  SizedBox(width: 5,),
                                                  Text("${spareWeightList[i]['Weight']}" ,style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "Poppins"
                                                  ),),
                                                ],
                                              ),
                                              isWeightTapped[i]==false?
                                              GestureDetector(
                                                onTap: ()=>setState((){
                                                  isWeightTapped[i] = true;
                                                  fixedWeightList.add(
                                                     '${spareWeightList[i]['Weight']}',
                                                  );
                                                }),
                                                child: Icon(Icons.add_circle , color: Colors.green,),
                                              ):Container()
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
                              "Weight",
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
              ):Container(),

              //3kg
              fixedWeightList.contains("3Kg")||fixedWeightList.contains("3kg")||
                  fixedWeightList.contains("3KG")?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text("Min Time For Delivery Of 3Kg Cake * ",
                    style: TextStyle(
                        color: alertsAndColors.darkBlue ,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller:threekgCtrl,
                          onChanged: (e){
                            setState((){
                              threekgHourorMin = threekgCtrl.text;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Min Time For Delivery Of 3Kg Cake",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1, color: Colors.grey)),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left:5 , right: 5),
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey , width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "${threekgCtrl.text} $threekgHourorMin",
                                style: TextStyle(
                                  color: alertsAndColors.darkBlue,
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            itemBuilder: (c)=>
                            [
                              PopupMenuItem(
                                  onTap: ()=>setState((){threekgHourorMin = "Days";}),
                                  child: Text("Days")
                              ),
                              PopupMenuItem(
                                  onTap: ()=>setState((){threekgHourorMin = "Hours";}),
                                  child: Text("Hours")
                              ),
                              PopupMenuItem(
                                  onTap: ()=>setState((){threekgHourorMin = "Mins";}),
                                  child: Text("minutes")
                              ),
                            ]
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ):Container(),

              //5kg
              fixedWeightList.contains("5Kg")||fixedWeightList.contains("5kg")||
                  fixedWeightList.contains("5KG")?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text("Min Time For Delivery Of 5Kg Cake * ",
                    style: TextStyle(
                        color: alertsAndColors.darkBlue ,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller:fvkgCtrl,
                          onChanged: (e){
                            setState((){
                              fvkgHourorMin = fvkgCtrl.text;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Min Time For Delivery Of 5Kg Cake",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1, color: Colors.grey)),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left:5 , right: 5),
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey , width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "${fvkgCtrl.text} $fvkgHourorMin",
                                style: TextStyle(
                                  color: alertsAndColors.darkBlue,
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            itemBuilder: (c)=>
                            [
                              PopupMenuItem(
                                  onTap: ()=>setState((){fvkgHourorMin = "Days";}),
                                  child: Text("Days")
                              ),
                              PopupMenuItem(
                                  onTap: ()=>setState((){fvkgHourorMin = "Hours";}),
                                  child: Text("Hours")
                              ),
                              PopupMenuItem(
                                  onTap: ()=>setState((){fvkgHourorMin = "Mins";}),
                                  child: Text("minutes")
                              ),
                            ]
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ):Container(),
              SizedBox(height: 20,),

              Center(
                child: Container(
                  height: 40,
                  width:200,
                  child: RaisedButton(
                    color: alertsAndColors.lightPink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    onPressed: ()=>validateInputs(),
                    child: Text(
                      "UPDATE" ,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              //col end
            ],
          ),
        ),
      ),
    );
  }
}
