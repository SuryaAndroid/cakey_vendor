import 'dart:convert';
import 'dart:io';
import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:cakey_vendor/Drawer/MainDrawer.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:http_parser/http_parser.dart';

class AddCakes extends StatefulWidget {
  const AddCakes({Key? key}) : super(key: key);

  @override
  State<AddCakes> createState() => _AddCakesState();
}

class _AddCakesState extends State<AddCakes> {
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  var drawerKey = GlobalKey<ScaffoldState>();
  String egg = "";
  String egglessPoss = "";
  String authToken = "";

  //
  String basicCus = "no";
  String gstAmt = "0";
  String cakeMin = "hour";
  String tobeStore = "Freezer";
  String cakeBase = "Butter";
  String cakeCream = "Butter cream";
  String cakeBestBef = "Hour";
  String cakeRoomTime = "Hour";
  String themePoss = "No";
  String topperPoss = "No";
  String tierPoss = "No";
  String howGood = "Good";
  String howManyTime = "Never";
  String fullCustomPoss = "No";

  String minimumTime = "";
  String beforeDays = "";
  String temperature = "";

  List<bool> isFlavTapped = [];
  List<bool> isWightTapped = [];
  List<bool> isShapetTapped = [];
  List<TextEditingController> flavEditors = [];
  List<TextEditingController> weightEditors = [];
  List<TextEditingController> shapeEditors = [];

  List flavList = [];
  List weightList = [];
  List shapetList = [];

  List fixedWeightList = [];
  List fixedShapeList = [];
  List fixedFlavList = [];

  //controllers
  var cakeName = TextEditingController(text: "My Cake Name");
  var cakeCommonName = TextEditingController(text: "Common Cake");
  var cakeFlav = TextEditingController(text: "Vanilla");
  var cakeShape = TextEditingController(text: "Round");
  var cakeWeight = TextEditingController(text: "1kg");
  var cakePrice = TextEditingController(text: "400");
  var cakeEgglessPrice = TextEditingController(text: "0");
  var cakeDescription = TextEditingController(text: "My cake descriptons");
  var cakeDiscount = TextEditingController(text: "0");
  var cakeMinTime = TextEditingController();
  var cakeBestBefore = TextEditingController();
  var timeInRoom = TextEditingController();
  
  var file = new File("");


  @override
  void initState(){
    Future.delayed(Duration.zero , () async {
      getInitialPrefs();
    });
    super.initState();
  }

  Future<void> getInitialPrefs() async{
    var pref = await SharedPreferences.getInstance();
    setState((){
      authToken = pref.getString('authToken')??'null';
    });
    print(authToken);
    getFlavours();
    getWeights();
    getShapes();
  }


  //getFlavs
  Future<void> getFlavours() async{

    List myFlavList = [];

    var headers = {
      'Authorization': '$authToken'
    };

    var request = http.Request('GET', Uri.parse('https://cakey-database.vercel.app/api/flavour/list'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      myFlavList = jsonDecode(await response.stream.bytesToString());

      print(myFlavList);

        setState((){
          flavList = myFlavList;
          flavList = flavList.reversed.toList();
          flavList = flavList.toSet().toList();
        });


    }
    else {
      print(response.reasonPhrase);
    }

  }

  //getFlavs
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

      print(myFlavList);

      setState((){
        weightList = myFlavList;
        weightList = weightList.reversed.toList();
        weightList = weightList.toSet().toList();
      });


    }
    else {
      print(response.reasonPhrase);
    }

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

      print(myFlavList);

      setState((){
        shapetList = myFlavList;
        shapetList = shapetList.reversed.toList();
        shapetList = shapetList.toSet().toList();
      });


    }
    else {
      print(response.reasonPhrase);
    }

  }

  //file picker
  Future<void> gotoFilePicker() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        String path = result.files.single.path.toString();
        file = File(path);
        print("file $file");
      });
    } else {
      // User canceled the picker
    }
  }

  //validations
  void validateTheInputs() {
    if(cakeName.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please enter cakename"),
            behavior: SnackBarBehavior.floating,
        )
      );
    }else if(cakeDiscount.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter cake discount"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(cakeCommonName.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter cake common name"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(cakeFlav.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter cake base flavour"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(cakeShape.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter cake base shape"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(cakeWeight.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter cake weight"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(cakePrice.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter cake price"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(cakeEgglessPrice.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter cake egg or eggless"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(cakeDescription.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter cake description"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(file.path.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select a image file"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else{
      addCake();
    }
  }

  //addCake
  Future<void> addCake() async{

    List tempFlav = [];
    List tempShape = [];
    List tempWeight = [];

    if(fixedFlavList.isNotEmpty){
      for(int i =0; i<fixedFlavList.length;i++){
        tempFlav.add(jsonEncode(fixedFlavList[i]));
      }
    }
    
    if(fixedShapeList.isNotEmpty){
      for(int i =0; i<fixedShapeList.length;i++){
        tempShape.add(jsonEncode(fixedShapeList[i]));
      }
    }
    
    if(fixedWeightList.isNotEmpty){
      for(int i =0; i<fixedWeightList.length;i++){
        tempWeight.add(jsonEncode(fixedWeightList[i]));
      }
    }
    
    alertsAndColors.showLoader(context);
    var request = http.MultipartRequest('POST', Uri.parse('https://cakey-database.vercel.app/api/cake/new'));
    request.fields.addAll({
      'CakeName': cakeName.text,
      'CakeCommonName':cakeCommonName.text,
      'BasicFlavour': cakeFlav.text,
      'BasicShape': cakeShape.text,
      'MinWeight': cakeWeight.text,
      'BasicCakePrice': cakePrice.text,
      'DefaultCakeEggOrEggless':egg,
      'IsEgglessOptionAvailable': egglessPoss,
      'BasicEgglessCostPerKg': cakeEgglessPrice.text,
      'IsTierCakePossible': tierPoss.toLowerCase()=="yes"?'y':'n',
      'ThemeCakePossible': themePoss.toLowerCase()=="yes"?'y':'n',
      'ToppersPossible': topperPoss.toLowerCase()=="yes"?'y':'n',
      'MinTimeForDeliveryOfDefaultCake': minimumTime,
      'FullCustomisationPossible': fullCustomPoss.toLowerCase()=="yes"?'y':'n',
      'CakeBase': cakeBase,
      'CakeCream': cakeCream,
      'BestUsedBefore': beforeDays,
      'ToBeStoredIn': tobeStore,
      'KeepTheCakeInRoomTemperature': cakeRoomTime,
      'Description': cakeDescription.text,
      'HowGoodAreYouWithTheCake': howGood,
      'HowManyTimesHaveYouBakedThisParticularCake': howManyTime,
      'VendorID': '628478c595eb4f0b50bd0658',
      'Vendor_ID': 'CKYV-7',
      'VendorName': 'Madhu Priya',
      'VendorPhoneNumber1': '9876543211',
      'VendorPhoneNumber2': '8642135790',
      'Street': 'No.10',
      'City': 'Coimbatore',
      'State': 'Tamilnadu',
      'Pincode': '641114',
      'Discount': cakeDiscount.text,
      'Tax': gstAmt.toString()
    });

    if(basicCus.toLowerCase()=="yes"){
      request.fields.addAll(
        {
          'BasicCustomisationPossible': 'y',
          'CustomFlavourList': "$tempFlav",
          'CustomShapeList': "$tempShape",
          'MinWeightList': "$tempWeight",
        }
      );
    }else{
      request.fields.addAll(
          {
            'BasicCustomisationPossible': 'n',
          }
      );
    }

    request.files.add(await http.MultipartFile.fromPath(
        'files', file.path.toString(),
        filename: Path.basename(file.path),
        contentType: MediaType.parse(lookupMimeType(file.path.toString()).toString())
    ));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cake added!"),
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: MainDrawer(),
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
                                      radius: 5.2,
                                      backgroundColor:
                                          alertsAndColors.darkBlue),
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
                          'ADD CAKE',
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
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [

              //Col start

              SizedBox(
                height: 15,
              ),
              //img select
              Stack(
                children: [
                  GestureDetector(
                    onTap: ()=>gotoFilePicker(),
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1, color: Colors.grey),
                          color: Colors.white),
                      child: Column(
                        children: [
                          file.path.isNotEmpty?
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(file.path.split("/").last, style: TextStyle(
                                    color: alertsAndColors.lightPink,
                                    fontFamily: "Poppins"
                                  ),),
                                ),
                                IconButton(
                                    onPressed: ()=>setState((){
                                      file = new File("");
                                    }),
                                    icon: Icon(Icons.close)
                                )
                              ],
                            ),
                          ):
                          Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Icon(
                                Icons.image_outlined,
                                size: 45,
                                color: Colors.blue,
                              ),
                              Text(
                                "Drag & Drop your files here",
                                style: TextStyle(
                                    color: alertsAndColors.darkBlue,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          )    
                          
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: -6,
                      left: 12,
                      child: Text(
                        "upload Image",
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Poppins",
                            backgroundColor: Colors.white),
                      )),
                ],
              ),

              //ck name
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: cakeName,
                style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Cake Name",
                  label: Text("Cake Name"),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //ck comm name
              TextField(
                controller: cakeCommonName,
                style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Cake Common Name",
                  label: Text("Cake Common Name"),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //ck flav
              TextField(
                controller: cakeFlav,
                style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Basic Flavour",
                  label: Text("Cake Basic Flavour"),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //ck shape
              TextField(
                controller: cakeShape,
                style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Basic Shape",
                  label: Text("Cake Basic Shape"),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              
              //egg or eggless
              GestureDetector(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (context)=>
                          AlertDialog(
                            title: Text("Egg/Eggless"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PopupMenuItem(
                                    onTap:()=>setState((){
                                      egg = "Egg";
                                    }),
                                    child: Text("Egg")
                                ),
                                PopupMenuItem(
                                    onTap:()=>setState((){
                                      egg = "Eggless";
                                    }),
                                    child: Text("Eggless")
                                ),
                              ],
                            ),
                          )
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey, width: 1)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(egg.isEmpty?"Select Egg Or Eggless":egg,style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins"
                      ),),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              //eggless poss
              egg.toLowerCase()=="egg"?
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context)=>
                              AlertDialog(
                                title: Text("Eggless possible"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PopupMenuItem(
                                        onTap:()=>setState((){
                                          egglessPoss = "y";
                                        }),
                                        child: Text("Yes")
                                    ),
                                    PopupMenuItem(
                                        onTap:()=>setState((){
                                          egglessPoss = "n";
                                        }),
                                        child: Text("No")
                                    ),
                                  ],
                                ),
                              )
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 1)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(egglessPoss.isEmpty?"Eggless Possible ?":"Eggless : "+egglessPoss,style: TextStyle(
                              color: alertsAndColors.darkBlue,
                              fontFamily: "Poppins"
                          ),),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ):
              Container(),

              //if eggless y
              egglessPoss.toLowerCase()=="y"?
              Column(
                children: [
                  TextField(
                    controller: cakeEgglessPrice,
                    style: TextStyle(
                        color: alertsAndColors.darkBlue,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Eggless cake price",
                      label: Text("Eggless cake price"),
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ):
              Container(),


              //weight and price
               Row(
                  children: [
                    Container(
                      child: Expanded(
                        flex: 1,
                          child:
                          TextField(
                            controller: cakeWeight,
                            style: TextStyle(
                                color: alertsAndColors.darkBlue,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              label: Text("Weight"),
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(width: 1, color: Colors.grey)),
                            ),
                          )
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                        flex: 2,
                        child:
                        TextField(
                          controller: cakePrice,
                          style: TextStyle(
                              color: alertsAndColors.darkBlue,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            label: Text("Basic cake price"),
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1, color: Colors.grey)),
                          ),
                        )
                    ),
                  ],
                ),

              SizedBox(height: 20,),

              TextField(
                controller: cakeDescription,
                maxLines: 4 ,
                style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: "Description",
                  label: Text("Description"),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                ),
              ),
              SizedBox(height: 20,),

              //discounts and tax
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cakeDiscount,
                        style: TextStyle(
                            color: alertsAndColors.darkBlue,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: "Discount %",
                          label: Text("Discount %"),
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(width: 1, color: Colors.grey)),
                        ),
                      ),
                    ),
                    SizedBox(width:10,),
                    Expanded(
                      child:GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (context)=>
                                  AlertDialog(
                                    title: Text("GST In %"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        PopupMenuItem(
                                            onTap:()=>setState((){
                                              gstAmt = "0";
                                            }),
                                            child: Text("0 %")
                                        ),
                                        PopupMenuItem(
                                            onTap:()=>setState((){
                                              gstAmt = "5";
                                            }),
                                            child: Text("5 %")
                                        ),
                                        PopupMenuItem(
                                            onTap:()=>setState((){
                                              gstAmt = "12";
                                            }),
                                            child: Text("12 %")
                                        ),
                                        PopupMenuItem(
                                            onTap:()=>setState((){
                                              gstAmt = "18";
                                            }),
                                            child: Text("18 %")
                                        ),
                                        PopupMenuItem(
                                            onTap:()=>setState((){
                                              gstAmt = "28";
                                            }),
                                            child: Text("28 %")
                                        ),
                                      ],
                                    ),
                                  )
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey , width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Gst $gstAmt%",
                            style: TextStyle(
                              color: alertsAndColors.darkBlue,
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Other Details
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:15 , bottom: 15),
                  child: Text("OTHER DETAILS",style: TextStyle(
                      color: alertsAndColors.darkBlue ,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize:17
                  ),),
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //min time delivery
                    Text("Minimum Time For Delivery Of Default Cake * ",
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
                              controller: cakeMinTime,
                              onChanged: (e){
                                setState((){
                                  minimumTime = cakeMinTime.text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Min Delivery Time",
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
                                    "${minimumTime} $cakeMin",
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
                                          onTap: ()=>setState((){cakeMin = "Hours";}),
                                          child: Text("Hours")
                                      ),
                                      PopupMenuItem(
                                          onTap: ()=>setState((){cakeMin = "Days";}),
                                          child: Text("Days")
                                      ),
                                    ]
                            ),
                          )
                        ],
                      ),
                    SizedBox(height: 10,),

                    //cake base
                    Text("Cake Base * ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                          isExpanded: true,
                          value: "$cakeBase",
                          hint: Text("Select Cake Base"),
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                                value:"Butter",
                                child: Text("Butter")
                            ),
                            DropdownMenuItem(
                                value:"Oil",
                                child: Text("Oil")
                            ),
                          ],
                          onChanged: (item){
                            setState((){
                              cakeBase = item.toString();
                            });
                          },
                      ),
                    ),

                    //cake cream
                    SizedBox(height: 10,),
                    Text("Cake Cream * ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        value: "$cakeCream",
                        hint: Text("Select Cake Cream"),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value:"Butter cream",
                              child: Text("Butter cream")
                          ),
                          DropdownMenuItem(
                              value:"Whipping cream",
                              child: Text("Whipping cream")
                          ),
                        ],
                        onChanged: (item){
                          setState((){
                            cakeCream = item.toString();
                          });
                        },
                      ),
                    ),

                    //best use
                    Text("Best Use Before * ",
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
                            controller: cakeBestBefore,
                            onChanged: (e){
                              setState((){
                                beforeDays = cakeBestBefore.text;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Best Use Before",
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
                                  "${beforeDays} $cakeBestBef",
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
                                    onTap: ()=>setState((){cakeBestBef = "Hours";}),
                                    child: Text("Hours")
                                ),
                                PopupMenuItem(
                                    onTap: ()=>setState((){cakeBestBef = "Days";}),
                                    child: Text("Days")
                                ),
                              ]
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),

                    //cake cream
                    SizedBox(height: 10,),
                    Text("To Be Stored In * ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        value: "$tobeStore",
                        hint: Text("Select Cake Cream"),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value:"Freezer",
                              child: Text("Freezer")
                          ),
                          DropdownMenuItem(
                              value:"Chiller",
                              child: Text("Chiller")
                          ),
                        ],
                        onChanged: (item){
                          setState((){
                            tobeStore = item.toString();
                          });
                        },
                      ),
                    ),

                    //room temp
                    Text("Min Time For Keeping In Room Temperature * ",
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
                            controller:timeInRoom,
                            onChanged: (e){
                              setState((){
                                temperature = timeInRoom.text;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Min Time For Keeping In Room Temperature",
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
                                  "${temperature} $cakeRoomTime",
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
                                    onTap: ()=>setState((){cakeRoomTime = "Mins";}),
                                    child: Text("Mins")
                                ),
                                PopupMenuItem(
                                    onTap: ()=>setState((){cakeRoomTime = "Hours";}),
                                    child: Text("Hours")
                                ),
                              ]
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),

                    //cake theme poss
                    SizedBox(height: 10,),
                    Text("Theme Cake Possible * ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        value: "$themePoss",
                        hint: Text("Select"),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value:"Yes",
                              child: Text("Yes")
                          ),
                          DropdownMenuItem(
                              value:"No",
                              child: Text("No")
                          ),
                        ],
                        onChanged: (item){
                          setState((){
                            themePoss = item.toString();
                          });
                        },
                      ),
                    ),

                    //cake toppers
                    SizedBox(height: 10,),
                    Text("Topper Possible * ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        value: "$topperPoss",
                        hint: Text("Select"),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value:"Yes",
                              child: Text("Yes")
                          ),
                          DropdownMenuItem(
                              value:"No",
                              child: Text("No")
                          ),
                        ],
                        onChanged: (item){
                          setState((){
                            topperPoss = item.toString();
                          });
                        },
                      ),
                    ),

                    //tier
                    SizedBox(height: 10,),
                    Text("Tier Possible * ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        value: "$tierPoss",
                        hint: Text("Select"),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value:"Yes",
                              child: Text("Yes")
                          ),
                          DropdownMenuItem(
                              value:"No",
                              child: Text("No")
                          ),
                        ],
                        onChanged: (item){
                          setState((){
                            tierPoss = item.toString();
                          });
                        },
                      ),
                    ),

                    //tier
                    SizedBox(height: 10,),
                    Text("Fully Customizable * ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        value: "$fullCustomPoss",
                        hint: Text("Select"),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value:"Yes",
                              child: Text("Yes")
                          ),
                          DropdownMenuItem(
                              value:"No",
                              child: Text("No")
                          ),
                        ],
                        onChanged: (item){
                          setState((){
                            fullCustomPoss = item.toString();
                          });
                        },
                      ),
                    ),

                    //how good
                    SizedBox(height: 10,),
                    Text("How Good Are You In Make This Cake * ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        value: "$howGood",
                        hint: Text("Select"),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value:"First Time",
                              child: Text("First Time")
                          ),
                          DropdownMenuItem(
                              value:"Average",
                              child: Text("Average")
                          ),
                          DropdownMenuItem(
                              value:"Good",
                              child: Text("Good")
                          ),
                          DropdownMenuItem(
                              value:"Very Good",
                              child: Text("Very Good")
                          ),
                          DropdownMenuItem(
                              value:"Expert",
                              child: Text("Expert")
                          ),
                          DropdownMenuItem(
                              value:"Speciality",
                              child: Text("speciality")
                          ),
                        ],
                        onChanged: (item){
                          setState((){
                            howGood = "$item";
                          });
                        },
                      ),
                    ),


                    //how many
                    SizedBox(height: 10,),
                    Text("How Many Time You Baked This Cake* ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        value: "$howManyTime",
                        hint: Text("Select"),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value:"Never",
                              child: Text("Never")
                          ),
                          DropdownMenuItem(
                              value:"1 - 5 Times",
                              child: Text("1 - 5 Times")
                          ),
                          DropdownMenuItem(
                              value:"5 - 10 Times",
                              child: Text("5 - 10 Times")
                          ),
                          DropdownMenuItem(
                              value:"More Than 10 Times",
                              child: Text("More Than 10 Times")
                          ),
                        ],
                        onChanged: (item){
                          setState((){
                            howManyTime = "$item";
                          });
                        },
                      ),
                    ),


                    //cake basic customize
                    SizedBox(height: 10,),
                    Text("Basic Customise Possible * ",
                      style: TextStyle(
                          color: alertsAndColors.darkBlue ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        value: "$basicCus",
                        hint: Text("Select"),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                              value:"yes",
                              child: Text("Yes")
                          ),
                          DropdownMenuItem(
                              value:"no",
                              child: Text("No")
                          ),
                        ],
                        onChanged: (item){
                          print(item);
                          setState((){
                            basicCus = item.toString();
                          });
                        },
                      ),
                    ),


                    basicCus.toLowerCase()=="yes"?
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
                               children: [
                                 SizedBox(height: 5,),
                                 Row(
                                   children: [
                                     Expanded(
                                       flex: 4,
                                       child: Container(
                                         height: 45,
                                         child: TextField(
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
                                         onPressed: (){},
                                         child: Text("ADD" , style: TextStyle(
                                           color: Colors.white
                                         ),),
                                       ),
                                     ))
                                   ],
                                 ),
                                 SizedBox(height: 10,),
                                 ListView.builder(
                                     itemCount: flavList.length,
                                     shrinkWrap: true,
                                     physics: NeverScrollableScrollPhysics(),
                                     itemBuilder: (c, i){
                                       isFlavTapped.add(false);
                                       flavEditors.add(
                                         new TextEditingController()
                                       );
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
                                                               ==flavList[i]['Name']);
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
                                                     Text("${flavList[i]['Name']}" ,style: TextStyle(
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
                                                 ):Container(
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
                                                                 "Name":'${flavList[i]['Name']}',
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
                                             Divider(height: 1,color: Colors.grey,)
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
                    ):
                    Container(),
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
                                  children: [
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: 45,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(left: 5),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10)
                                                    )
                                                ),
                                              ),
                                            )
                                        ),
                                        SizedBox(width: 6,),
                                        Expanded(child: Container(
                                          child: RaisedButton(
                                            color: Colors.green,
                                            onPressed: (){},
                                            child: Text("ADD" , style: TextStyle(
                                                color: Colors.white
                                            ),),
                                          ),
                                        ))
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    ListView.builder(
                                        itemCount: weightList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (c, i){
                                          isWightTapped.add(false);
                                          weightEditors.add(
                                            new TextEditingController()
                                          );
                                          return Container(
                                            padding: EdgeInsets.only(left: 7 , right: 7 , top: 5 , bottom: 5),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        isWightTapped[i]==true?
                                                        GestureDetector(
                                                          onTap: ()=>setState((){
                                                            if(fixedWeightList.isNotEmpty){
                                                              fixedWeightList.removeWhere((element) => element
                                                                  ==weightList[i]['Weight']);
                                                              weightEditors[i].text = "";
                                                              isWightTapped[i]=false;
                                                              print(fixedWeightList);
                                                            }else{
                                                              weightEditors[i].text = "";
                                                              isWightTapped[i]=false;
                                                            }
                                                          }),
                                                          child: Icon(Icons.remove_circle , color: Colors.red,),
                                                        ):Container(),
                                                        SizedBox(width: 5,),
                                                        Text("${weightList[i]['Weight']}" ,style: TextStyle(
                                                            color: Colors.grey,
                                                            fontFamily: "Poppins"
                                                        ),),
                                                      ],
                                                    ),
                                                    isWightTapped[i]==false?
                                                    GestureDetector(
                                                      onTap: ()=>setState((){
                                                        isWightTapped[i] = true;
                                                        fixedWeightList.add(
                                                            weightList[i]['Weight'].toString()
                                                        );
                                                      }),
                                                      child: Icon(Icons.add_circle , color: Colors.green,),
                                                    ):
                                                    Container()
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Divider(height: 1,color: Colors.grey,)
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
                    ):
                    Container(),
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
                                  children: [
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: 45,
                                              child: TextField(
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
                                            onPressed: (){},
                                            child: Text("ADD" , style: TextStyle(
                                                color: Colors.white
                                            ),),
                                          ),
                                        ))
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    ListView.builder(
                                        itemCount: shapetList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (c, i){
                                          isShapetTapped.add(false);
                                          shapeEditors.add(new TextEditingController());
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
                                                                  ==shapetList[i]['Name']);
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
                                                        Text("${shapetList[i]['Name']}" ,style: TextStyle(
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
                                                    ):Container(
                                                      height: 35,
                                                      width:45,
                                                      child: TextField(
                                                        controller: shapeEditors[i],
                                                        onEditingComplete: (){
                                                          print("Completed...");
                                                          setState((){
                                                            if(shapeEditors[i].text.isNotEmpty){
                                                              fixedShapeList.add(
                                                                  {
                                                                    "Name":'${shapetList[i]['Name']}',
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
                                                Divider(height: 1,color: Colors.grey,)
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
                    ):
                    Container(),

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
                          onPressed: ()=>validateTheInputs(),
                          child: Text(
                              "CREATE" ,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins"
                              ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                  ],
                ),
              )

              //col end
            ],
          ),
        ),
      ),
    );
  }
}
