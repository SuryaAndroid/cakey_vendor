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

  //strings
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
  String egg = "";
  String egglessPoss = "";
  String authToken = "";
  String minimumTime = "";
  String beforeDays = "";
  String temperature = "";
  String threekgHourorMin = "Hour";
  String fvkgHourorMin = "Hour";

  //list
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
  List tierList = ["2 Tier", "3 Tier", "4 Tier"];
  List<bool> isTierTapped = [];
  List<TextEditingController> tierWeightEditors = [];
  List<TextEditingController> tierPriceEditors = [];
  List fixedTierList = [];
  List<TextEditingController> tierMinTimeEditor = [];
  List selectedTierDropItem = [];
  List fixedMinTimeTires = [];


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

  //controllers
  var cakeName = TextEditingController(text: "My Cake Name");
  var cakeCommonName = TextEditingController(text: "Common Cake");
  var cakeFlav = TextEditingController(text: "Vanilla");
  var cakeShape = TextEditingController(text: "Round");
  var cakeWeight = TextEditingController(text: "1kg");
  var cakePrice = TextEditingController(text: "400");
  var cakeEgglessPrice = TextEditingController(text: "0");
  var cakeDescription = TextEditingController(text: "My cake descriptions");
  var cakeDiscount = TextEditingController(text: "0");
  var cakeMinTime = TextEditingController();
  var cakeBestBefore = TextEditingController();
  var timeInRoom = TextEditingController();
  var threekgCtrl = TextEditingController();
  var fvkgCtrl = TextEditingController();
  var extraFlavCtrl = TextEditingController();
  var extraShapeCtrl = TextEditingController();
  var extrWightCtrl = TextEditingController();

  //file
  var file = new File("");
  List<File> files = [];



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
      currentVendorMail = pref.getString('authMail')??'null';
    });
    print(authToken);
    getVendor();
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

  //picking multiple files
  Future<void> multipleFilePicker() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],);

    if (result != null) {
       setState((){
         files = result.paths.map((path) => File(path!)).toList();
       });
    } else {
      // User canceled the picker
    }

    print(files);
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
    }else if(cakeMinTime.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter minimum time of delivery!"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(cakeBestBefore.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter best before using day!"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(timeInRoom.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter room temperature!"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(basicCus.toLowerCase()=="yes"&&fixedFlavList.isEmpty){

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please add the basic customisation options! flavours/shapes/weights"),
              behavior: SnackBarBehavior.floating,
            )
        );


    }else if(egg.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select egg/eggless options"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(egglessPoss.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select eggless avaiable or not!"),
            behavior: SnackBarBehavior.floating,
          )
      );
    }else if(tierPoss.toLowerCase()=="yes"&&fixedMinTimeTires.isEmpty){

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please add weight and price in Tier/add min delivery time in Tier"),
              behavior: SnackBarBehavior.floating,
            )
        );

    }else if(fixedWeightList.contains("3kg")&&threekgCtrl.text.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter minimum delivery time of 3kg"),
            behavior: SnackBarBehavior.floating,
          )
      );

    }else if(fixedWeightList.contains("5kg")&&threekgCtrl.text.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter minimum delivery time of 5kg"),
            behavior: SnackBarBehavior.floating,
          )
      );

    }else{
      addCake();
    }
  }

  //getVendors
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

        });

        getFlavours();
        getWeights();
        getShapes();

        print(myVendorList);

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

  //addCake
  Future<void> addCake() async{
    alertsAndColors.showLoader(context);

    List tempFlav = [];
    List tempShape = [];
    List tempWeight = [];

    List tempTier = [];
    List tempTierTime = [];

    fixedMinTimeTires.removeWhere((element) => element=="value");

    print(fixedMinTimeTires);

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

    if(fixedTierList.isNotEmpty){
      for(int i =0; i<fixedTierList.length;i++){
        tempTier.add(jsonEncode(fixedTierList[i]));
      }
    }

    if(fixedMinTimeTires.isNotEmpty){
      for(int i =0; i<fixedMinTimeTires.length;i++){
        tempTierTime.add(jsonEncode(fixedMinTimeTires[i]));
      }
    }


    print(tempTier);

    print({
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
      'MinTimeForDeliveryOfDefaultCake': minimumTime+cakeMin.toLowerCase(),
      'FullCustomisationPossible': fullCustomPoss.toLowerCase()=="yes"?'y':'n',
      'CakeBase': cakeBase,
      'CakeCream': cakeCream,
      'BestUsedBefore': beforeDays+cakeBestBef.toLowerCase(),
      'ToBeStoredIn': tobeStore,
      'KeepTheCakeInRoomTemperature': timeInRoom.text+cakeRoomTime.toLowerCase(),
      'Description': cakeDescription.text,
      'HowGoodAreYouWithTheCake': howGood,
      'HowManyTimesHaveYouBakedThisParticularCake': howManyTime,
      'Discount': cakeDiscount.text,
      'Tax': gstAmt.toString(),
      'BasicCustomisationPossible': basicCus,
      'CustomFlavourList': "$tempFlav",
      'CustomShapeList': "$tempShape",
      'MinWeightList': "$tempWeight",
      'VendorID': '$currentVendor_id',
      'Vendor_ID': '$currentVendorId',
      'VendorName': '$currentVendorName',
      'VendorPhoneNumber1': '$currentVendorPhn1',
      'VendorPhoneNumber2': '$currentVendorPhn2',
      'Street': '$currentVendorStreet',
      'City': '$currentVendorCity',
      'State': '$currentVendorState',
      'Pincode': '$currentVendorPin',
    });


    try{

      var request = http.MultipartRequest('POST', Uri.parse('https://cakey-database.vercel.app/api/cake/new'));


      request.fields.addAll({
        'CakeName': cakeName.text,
        'CakeCommonName':cakeCommonName.text,
        'BasicFlavour': cakeFlav.text,
        'BasicShape': cakeShape.text,
        'MinWeight': cakeWeight.text,
        'BasicCakePrice': cakePrice.text,
        'DefaultCakeEggOrEggless':egg,
        'ThemeCakePossible': themePoss.toLowerCase()=="yes"?'y':'n',
        'ToppersPossible': topperPoss.toLowerCase()=="yes"?'y':'n',
        'MinTimeForDeliveryOfDefaultCake': minimumTime+cakeMin.toLowerCase(),
        'FullCustomisationPossible': fullCustomPoss.toLowerCase()=="yes"?'y':'n',
        'CakeBase': cakeBase,
        'CakeCream': cakeCream,
        'BestUsedBefore': beforeDays+cakeBestBef.toLowerCase(),
        'ToBeStoredIn': tobeStore,
        'KeepTheCakeInRoomTemperature': timeInRoom.text+cakeRoomTime.toLowerCase(),
        'Description': cakeDescription.text,
        'HowGoodAreYouWithTheCake': howGood,
        'HowManyTimesHaveYouBakedThisParticularCake': howManyTime,
        'Discount': cakeDiscount.text,
        'Tax': gstAmt.toString(),
        'VendorID': '$currentVendor_id',
        'Vendor_ID': '$currentVendorId',
        'VendorName': '$currentVendorName',
        'VendorPhoneNumber1': '$currentVendorPhn1',
        'VendorPhoneNumber2': '$currentVendorPhn2',
        'Street': '$currentVendorStreet',
        'City': '$currentVendorCity',
        'State': '$currentVendorState',
        'Pincode': '$currentVendorPin',
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
      }
      else{
        request.fields.addAll(
            {
              'BasicCustomisationPossible': 'n',
            }
        );
      }

      request.files.add(await http.MultipartFile.fromPath(
          'MainCakeImage', file.path.toString(),
          filename: Path.basename(file.path),
          contentType: MediaType.parse(lookupMimeType(file.path.toString()).toString())
      ));

      if(files.isNotEmpty){
        for(var i =0 ; i<files.length;i++){
          request.files.add(await http.MultipartFile.fromPath(
              'AdditionalCakeImages', files[i].path.toString(),
              filename: Path.basename(files[i].path),
              contentType: MediaType.parse(lookupMimeType(files[i].path.toString()).toString())
          ));
        }
      }

      if(tierPoss.toLowerCase()=="yes"){
        request.fields.addAll({
          'IsTierCakePossible': "y",
          'TierCakeMinWeightAndPrice':"$tempTier",
          'MinTimeForDeliveryFortierCake':"$tempTierTime",
        });
      }else{
        request.fields.addAll({
          'IsTierCakePossible': "n",
        });
      }

      if(egg.toLowerCase()=="eggless"){
        request.fields.addAll(
          {
            'BasicEgglessCostPerKg': egg.toLowerCase()=="eggless"?cakePrice.text:cakeEgglessPrice.text,
          }
        );
      }else{
        request.fields.addAll(
            {
              'IsEgglessOptionAvailable': "n",
            }
        );
      }

      if(fixedWeightList.contains("5Kg")||fixedWeightList.contains("5kg")||
          fixedWeightList.contains("5KG"))
      {
        request.fields.addAll({
          "MinTimeForDeliveryOfA5KgCake":"${fvkgCtrl.text} $fvkgHourorMin"
        });
      }

      if(fixedWeightList.contains("3Kg")||fixedWeightList.contains("3kg")||
          fixedWeightList.contains("3KG"))
      {
        request.fields.addAll({
          "MinTimeForDeliveryOfA3KgCake":"${threekgCtrl.text} $threekgHourorMin"
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
      Navigator.pop(context);
      print(e);
    }

  }

  //add extra shape
  Future<void> addExtraShape(String myShape) async{
    alertsAndColors.showLoader(context);

    myShape = myShape.toLowerCase().replaceAll("kg", "");

    try{

      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://cakey-database.vercel.app/api/shape/new'));
      request.body = json.encode({
        "Shape": "$myShape"+"kg"
      });


      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        var map = jsonDecode(await response.stream.bytesToString());

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${map['message']}"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            )
        );

        getFlavours();
        Navigator.pop(context);
      }
      else {
        checkNetwork();
        print(response.reasonPhrase);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error occurred"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            )
        );
      }
    }catch(e){
      checkNetwork();
      Navigator.pop(context);
    }

  }
  //add extra flav
  Future<void> addExtraFlav(String myFlav) async{

    alertsAndColors.showLoader(context);

    try{

      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://cakey-database.vercel.app/api/flavour/new'));
      request.body = json.encode({
        "Flavour": "$myFlav"
      });


      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        var map = jsonDecode(await response.stream.bytesToString());

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${map['message']}"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            )
        );

        getFlavours();
        Navigator.pop(context);
      }
      else {
        checkNetwork();
        print(response.reasonPhrase);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error occurred"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            )
        );
      }
    }catch(e){
      checkNetwork();
      Navigator.pop(context);
    }

  }
  //add extra wight
  Future<void> addExtraWeight(String myWeight) async{

    alertsAndColors.showLoader(context);

    try{

      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://cakey-database.vercel.app/api/weight/new'));
      request.body = json.encode({
        "Weight": "$myWeight"
      });


      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        var map = jsonDecode(await response.stream.bytesToString());

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${map['message']}"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            )
        );

        getFlavours();
        Navigator.pop(context);
      }
      else {
        checkNetwork();
        print(response.reasonPhrase);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error occurred"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            )
        );
      }
    }catch(e){
      checkNetwork();
      Navigator.pop(context);
    }

  }

  //onback press
  Future<bool> onBackPressed() async{
    return (
       await showDialog(
           context: context,
           builder: (context){
             return AlertDialog(
               title: Text('Warning!'),
               content: Text("Are You Sure , Do You Want To Exit?"),
               actions: [
                 FlatButton(
                     onPressed: ()=>Navigator.of(context).pop(true),
                     child: Text("Yes",style: TextStyle(
                         color: Colors.purple
                     ),)
                 ),
                 FlatButton(
                     onPressed: ()=>Navigator.of(context).pop(false),
                     child: Text("No" ,style: TextStyle(
                       color: Colors.purple
                     ),)
                 ),
               ],
             );
           }
       )
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>onBackPressed(),
      child: Scaffold(
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
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1, color: Colors.grey),
                            color: Colors.white),
                        child: Column(
                          children: [
                            file.path.isNotEmpty?
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 120,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 120,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.all(8),
                                      child:Container(
                                        margin: EdgeInsets.all(6),
                                        child: Image(
                                          image: FileImage(file),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    ),
                                    Positioned(
                                        top: 6,
                                        right: 0,
                                        child: InkWell(
                                          onTap:()=>setState((){
                                            file = new File("");
                                          }),
                                          child: Icon(
                                            Icons.remove_circle ,
                                            color: Colors.red,
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ):
                            InkWell(
                              onTap:()=>gotoFilePicker(),
                              child: Column(
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
                              ),
                            )

                          ],
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

                //multiple image
                SizedBox(
                  height: 15,
                ),
                //img select
                Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1, color: Colors.grey),
                            color: Colors.white),
                        child: Column(
                          children: [
                            files.isNotEmpty?
                            Container(
                              alignment: Alignment.centerLeft,
                              height:120,
                              padding: EdgeInsets.all(8),
                              child:ListView.builder(
                                  itemCount: files.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (c , i){
                                    return Stack(
                                      children: [
                                        Container(
                                            height: 120,
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.all(8),
                                            child:Container(
                                              margin: EdgeInsets.all(6),
                                              child: Image(
                                                image: FileImage(files[i]),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                        ),
                                        Positioned(
                                            top: 6,
                                            right: 0,
                                            child: InkWell(
                                              onTap:()=>setState((){
                                                files.removeAt(i);
                                              }),
                                              child: Icon(
                                                Icons.remove_circle ,
                                                color: Colors.red,
                                              ),
                                            )
                                        )
                                      ],
                                    );
                                  }
                              ),
                            ):
                            InkWell(
                              onTap: ()=>multipleFilePicker(),
                              child: Column(
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
                              ),
                            )
                          ],
                        ),
                      ),
                    Positioned(
                        top: -6,
                        left: 12,
                        child: Text(
                          "Additional Images",
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
                                        egglessPoss = "y";
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

                      //Tier posss
                      tierPoss.toLowerCase()=="yes"?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                      ListView.builder(
                                          itemCount: tierList.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (c, i){
                                            isTierTapped.add(false);
                                            tierWeightEditors.add(new TextEditingController());
                                            tierPriceEditors.add(new TextEditingController());
                                            //List<TextEditingController> tierMinTimeEditor = [];
                                            //   List selectedTierDropItem = [];
                                            //   List fixedMinTimeTires = [];
                                            return Container(
                                              padding: EdgeInsets.only(left: 7 , right: 7 , top: 5 , bottom: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          isTierTapped[i]==true?
                                                          GestureDetector(
                                                            onTap: ()=>setState((){
                                                              if(fixedTierList.isNotEmpty){
                                                                fixedTierList.removeWhere((element) => element['Tier']
                                                                    ==tierList[i]);
                                                                tierWeightEditors[i].text = "";
                                                                tierPriceEditors[i].text = "";
                                                                isTierTapped[i]=false;
                                                                print(fixedTierList);
                                                              }else{
                                                                tierMinTimeEditor.clear();
                                                                fixedMinTimeTires.clear();
                                                                tierWeightEditors[i].text = "";
                                                                tierPriceEditors[i].text = "";
                                                                isTierTapped[i]=false;
                                                              }
                                                              print(fixedTierList);
                                                            }),
                                                            child: Icon(Icons.remove_circle , color: Colors.red,),
                                                          ):Container(),
                                                          SizedBox(width: 5,),
                                                          Text("${tierList[i]}" ,style: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: "Poppins"
                                                          ),),
                                                        ],
                                                      ),
                                                      isTierTapped[i]==false?
                                                      GestureDetector(
                                                        onTap: ()=>setState((){
                                                          isTierTapped[i] = true;
                                                        }),
                                                        child: Icon(Icons.add_circle , color: Colors.green,),
                                                      ):
                                                      Row(
                                                        children: [
                                                          Text("Weight",style: TextStyle(
                                                              fontFamily: "Poppins"
                                                          ),),
                                                          SizedBox(width: 3,),
                                                          Container(
                                                            height: 30,
                                                            width:45,
                                                            child: TextField(
                                                              controller: tierWeightEditors[i],
                                                              onEditingComplete: (){
                                                                print("Completed...");
                                                                setState((){
                                                                  // if(flavEditors[i].text.isNotEmpty){
                                                                  //   fixedFlavList.add(
                                                                  //       {
                                                                  //         "Name":'${flavList[i]['Name']}',
                                                                  //         "Price":'${flavEditors[i].text}',
                                                                  //       }
                                                                  //   );
                                                                  //}
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
                                                          ),
                                                          SizedBox(width: 3,),
                                                          Text("Price",style: TextStyle(
                                                              fontFamily: "Poppins"
                                                          ),),
                                                          SizedBox(width: 3,),
                                                          Container(
                                                            height: 30,
                                                            width:45,
                                                            child: TextField(
                                                              controller: tierPriceEditors[i],
                                                              onEditingComplete: (){
                                                                print("Completed...");
                                                                setState((){
                                                                  if(tierPriceEditors[i].text.isNotEmpty&&
                                                                      tierWeightEditors[i].text.isNotEmpty){
                                                                    fixedTierList.add(
                                                                        {
                                                                          "Tier":'${tierList[i]}',
                                                                          "Price":'${tierPriceEditors[i].text}',
                                                                          "Weight":"${tierWeightEditors[i].text}kg"
                                                                        }
                                                                    );
                                                                  }

                                                                  print(fixedTierList);
                                                                });

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
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Divider(height: 1,color: Colors.grey,)
                                                ],
                                              ),
                                            );
                                          }
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    left: 12,
                                    top: -5,
                                    child: Text(
                                      "Tires",
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
                          SizedBox(height: 10,),
                        ],
                      ):Container(),

                      //Tier posss
                      fixedTierList.isNotEmpty?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                      SizedBox(height: 10,),
                                      ListView.builder(
                                          itemCount: fixedTierList.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (c, i){
                                            tierMinTimeEditor.add(new TextEditingController());
                                            selectedTierDropItem.add("None");
                                            fixedMinTimeTires.add("value");
                                            return Container(
                                              padding: EdgeInsets.only(left: 7 , right: 7 , top: 5 , bottom: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 5,),
                                                          Text("${fixedTierList[i]["Tier"]}" ,style: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: "Poppins"
                                                          ),),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Type Hour",style: TextStyle(
                                                              fontFamily: "Poppins"
                                                          ),),
                                                          SizedBox(width: 3,),
                                                          Container(
                                                            height: 30,
                                                            width:45,
                                                            child: TextField(
                                                              controller: tierMinTimeEditor[i],
                                                              onEditingComplete: (){
                                                                print("Completed...");
                                                                setState((){
                                                                });
                                                                print(fixedMinTimeTires.toSet().toList());
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
                                                          ),
                                                          SizedBox(width: 3,),
                                                          GestureDetector(
                                                            onTap: ()=>    showDialog(
                                                                context: context,
                                                                builder: (c)=>AlertDialog(
                                                                  title: Text("Pick session"),
                                                                  content: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      PopupMenuItem(
                                                                        onTap: ()=>setState((){
                                                                          selectedTierDropItem[i] = "Minutes";
                                                                        }),
                                                                        child: Text("Minutes"),
                                                                      ),
                                                                      PopupMenuItem(
                                                                        onTap: ()=>setState((){
                                                                          selectedTierDropItem[i] = "Hours";
                                                                        }),
                                                                        child: Text("Hours"),
                                                                      ),
                                                                      PopupMenuItem(
                                                                        onTap: ()=>setState((){
                                                                          selectedTierDropItem[i] = "Days";
                                                                        }),
                                                                        child: Text("Days"),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                            ),
                                                            child:Row(
                                                              children: [
                                                                SizedBox(width: 3,),
                                                                Text('${selectedTierDropItem[i]}' , style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontFamily: "Poppins"
                                                                ),) ,
                                                                SizedBox(width: 3,),
                                                                Icon(Icons.arrow_drop_down , color: Colors.red,)
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 3,),
                                                          tierMinTimeEditor[i].text.isNotEmpty?
                                                          GestureDetector(
                                                            onTap: ()=>setState((){
                                                              fixedMinTimeTires[i] = {
                                                                "Tier":"${fixedTierList[i]["Tier"]}",
                                                                "MinTime":"${tierMinTimeEditor[i].text}"
                                                                    "${selectedTierDropItem[i].toString().toLowerCase()}"
                                                              };
                                                              fixedMinTimeTires.removeWhere((element) =>
                                                              element=="value");
                                                              print(fixedMinTimeTires);
                                                            }),
                                                            child: Icon(Icons.check_circle , color: Colors.green,size: 30,),
                                                          ):Container()
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Divider(height: 1,color: Colors.grey,)
                                                ],
                                              ),
                                            );
                                          }
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    left: 12,
                                    top: -5,
                                    child: Text(
                                      "Tier Cakes Delivery Minimum Time",
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
                          SizedBox(height: 10,),
                        ],
                      ):Container(),

                      //full custom
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

                      //Never/1-3times/4-7times/7-10times/more
                      // than 10 times

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
                                value:"1-3times",
                                child: Text("1-3 Times")
                            ),
                            DropdownMenuItem(
                                value:"4-7times",
                                child: Text("4 - 7 Times")
                            ),
                            DropdownMenuItem(
                                value:"7-10times",
                                child: Text("7 - 10 Times")
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
                            setState((){
                              basicCus = item.toString();
                            });
                            print("basicCus $basicCus");
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
                                             controller: extraFlavCtrl,
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
                                             if(extraFlavCtrl.text.isNotEmpty){
                                               addExtraFlav(extraFlavCtrl.text);
                                             }
                                           },
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
                                                  controller: extrWightCtrl,
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
                                              onPressed: (){
                                                if(extrWightCtrl.text.isNotEmpty){
                                                  addExtraWeight(extrWightCtrl.text);
                                                }
                                              },
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
                                                if(extraShapeCtrl.text.isNotEmpty){
                                                  addExtraShape(extraShapeCtrl.text);
                                                }
                                              },
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
      ),
    );
  }
}
