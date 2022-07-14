import 'dart:convert';
import 'dart:io';

import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'NotificationScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  AlertsAndColors alertsAndColors = new AlertsAndColors();
  String authToken = "";
  String authMail = "";
  String gender = "";
  String egg = "";
  String jobType = "";
  String profileUrl = "";
  List vendorProfile = [];

  //region ctrls
  var vendorName = new TextEditingController();
  var vendorEmail = new TextEditingController();
  var vendorDOB = new TextEditingController();
  var street = new TextEditingController();
  var city = new TextEditingController();
  var state = new TextEditingController();
  var pincode = new TextEditingController();
  var phn1 = new TextEditingController();
  var phn2 = new TextEditingController();
  var bnkName = new TextEditingController();
  var branch = new TextEditingController();
  var accNo = new TextEditingController();
  var ifscCode = new TextEditingController();
  var upiId = new TextEditingController();
  var aadhar = new TextEditingController();
  var pan = new TextEditingController();
  var ifssai = new TextEditingController();
  var ifssaiExp = new TextEditingController();
  var gstNo = new TextEditingController();
  var yearsOfExp = new TextEditingController();
  var maxCakeDay = new TextEditingController();
  var maxCakeWeek = new TextEditingController();
  var specialize = new TextEditingController();
  var preferVenName = new TextEditingController();
  var description = new TextEditingController();
  //endregion

  @override
  void initState(){
    super.initState();
    getInitialPrefs();
  }

  Future<void> getInitialPrefs() async{
    var pref = await SharedPreferences.getInstance();
    setState((){
      authToken = pref.getString('authToken')??"";
      authMail = pref.getString('authMail')??"";
    });
    getVendorByMail(authMail);
  }

  Future<void> getVendorByMail(String authMail) async{
    alertsAndColors.showLoader(context);
    try{
      var headers = {
        'Authorization': '$authToken'
      };
      var request = http.Request('GET',
          Uri.parse('https://cakey-database.vercel.app/api/vendors/listbyemail/$authMail'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        List data = jsonDecode(await response.stream.bytesToString());
        print(data.length);
        setState((){
          vendorProfile = data;
          profileUrl = vendorProfile[0]["ProfileImage"].toString();
          gender = vendorProfile[0]["Gender"].toString();
          egg = vendorProfile[0]["EggOrEggless"].toString();
          jobType = vendorProfile[0]["JobType"].toString();
          vendorName.text = vendorProfile[0]["VendorName"].toString();
          vendorEmail.text = vendorProfile[0]["Email"].toString();
          vendorDOB.text = vendorProfile[0]["DateOfBirth"].toString();
          street.text = vendorProfile[0]["Address"]["Street"].toString();
          city.text = vendorProfile[0]["Address"]["City"].toString();
          state.text = vendorProfile[0]["Address"]["State"].toString();
          pincode.text = vendorProfile[0]["Address"]["Pincode"].toString();
          phn1.text = vendorProfile[0]["PhoneNumber1"].toString();
          phn2.text = vendorProfile[0]["PhoneNumber2"].toString();
          bnkName.text = vendorProfile[0]["BankName"].toString();
          branch.text = vendorProfile[0]["Branch"].toString();
          accNo.text = vendorProfile[0]["AccountNumber"].toString();
          ifscCode.text = vendorProfile[0]["IFSCCode"].toString();
          upiId.text = vendorProfile[0]["UPIId"].toString();
          aadhar.text = vendorProfile[0]["AadhaarNumber"].toString();
          pan.text = vendorProfile[0]["PANNumber"].toString();
          ifssai.text = vendorProfile[0]["FSSAINumber"].toString();
          ifssaiExp.text = vendorProfile[0]["FSSAIExpiryDate"].toString();
          gstNo.text = vendorProfile[0]["GSTNumber"].toString();
          yearsOfExp.text = vendorProfile[0]["YearsOfExperienceAsBaker"].toString();
          maxCakeDay.text = vendorProfile[0]["MaximumCakesPerDay"].toString();
          maxCakeWeek.text = vendorProfile[0]["MaximumCakesPerWeek"].toString();
          specialize.text = vendorProfile[0]["YourSpecialityCakes"].toString().replaceAll("[", "").replaceAll("]", "");
          preferVenName.text = vendorProfile[0]["PreferredNameOnTheApp"].toString();
          description.text = vendorProfile[0]["Description"].toString();
        });
        Navigator.pop(context);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.reasonPhrase.toString()),
              backgroundColor: Colors.brown,
              behavior: SnackBarBehavior.floating,
            )
        );
        Navigator.pop(context);
      }
    }catch(e){
      checkNetwork();
      print(e);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'MY PROFILE',
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
                                  MaterialPageRoute(builder: (c)=>NotificationScreen())
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
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
      backgroundColor: Colors.white,
      body: Container(
        width:double.infinity,
        padding: EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: () async{
            setState((){
              getInitialPrefs();
            });
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:30,),
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1.5,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(profileUrl),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 15.0),
                  child: Text("BASIC INFORMATIONS",style: TextStyle(
                        color: alertsAndColors.darkBlue,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),),
                ),
                //user name
                Padding(
                  padding:EdgeInsets.only(top: 20.0),
                  child: TextField(
                    controller: vendorName,
                    style: TextStyle(
                        color: alertsAndColors.darkBlue,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Name",
                      label: Text("Your Name *",style: TextStyle(
                        fontFamily: "Poppins"
                      ),),
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                    ),
                  )
                ),
                //email
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: vendorEmail,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Name",
                        label: Text("Email *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //gender
                Padding(
                  padding:EdgeInsets.only(top: 20.0),
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 7),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child:ExpansionTile(
                            title: Text("$gender",style: TextStyle(
                              color: alertsAndColors.darkBlue,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                            ),),
                            trailing: Container(
                              alignment: Alignment.center,
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: alertsAndColors.lightPink,
                                size: 25,
                              ),
                            ),
                            children: [
                              InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text("Male"),
                                ),
                              ),InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text("Female"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: -4,
                            left: 12,
                            child: Text(
                              "Gender * ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Poppins",
                                  backgroundColor: Colors.white
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                //DOB
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: vendorDOB,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Name",
                        label: Text("Date Of Birth *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //Egg
                Padding(
                  padding:EdgeInsets.only(top: 20.0),
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 7),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child:ExpansionTile(
                            title: Text("$egg",style: TextStyle(
                              color: alertsAndColors.darkBlue,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                            ),),
                            trailing: Container(
                              alignment: Alignment.center,
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: alertsAndColors.lightPink,
                                size: 25,
                              ),
                            ),
                            children: [
                              InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text("Egg"),
                                ),
                              ),InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text("Eggless"),
                                ),
                              ),
                              InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text("Egg And Eggless"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: -4,
                            left: 12,
                            child: Text(
                              "Egg Or Eggless * ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Poppins",
                                  backgroundColor: Colors.white
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                //basic end

                //address
                Padding(
                  padding:EdgeInsets.only(top: 15.0),
                  child: Text("ADDRESS",style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                //street
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: street,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Street *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //city
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: city,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Name",
                        label: Text("City *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //user state
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: state,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Name",
                        label: Text("State *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //user pin
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: pincode,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Name",
                        label: Text("Pincode *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //user phone1
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: phn1,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Name",
                        label: Text("Phone Number *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //user phn2
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: phn2,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Name",
                        label: Text("Alternative Phone Number *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //adress end


                //bank start
                Padding(
                  padding:EdgeInsets.only(top: 15.0),
                  child: Text("BANK DETAILS",style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                //bnk name
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: bnkName,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Bank Name *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //branch
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: branch,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Branch *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //ac num
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: accNo,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Account Number *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //ifsc
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: ifscCode,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("IFSC Code *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //upi
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: upiId,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("UPI ID/Number *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //bank end

                //id start
                Padding(
                  padding:EdgeInsets.only(top: 15.0),
                  child: Text("YOUR IDENTITY AND LICENCE DETAILS",style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                //aadhar
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: aadhar,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Aadhar Number *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //branch
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: pan,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("PAN Number *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //ac num
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: ifssai,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("FSSAI Number *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //ifsc
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: ifssaiExp,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("FSSAI Expiry Date *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //gst
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: gstNo,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("GST Number *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //id end

                //others start
                Padding(
                  padding:EdgeInsets.only(top: 15.0),
                  child: Text("OTHER DETAILS",style: TextStyle(
                    color: alertsAndColors.darkBlue,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                //job
                Padding(
                  padding:EdgeInsets.only(top: 20.0),
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 7),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child:ExpansionTile(
                            title: Text("$jobType",style: TextStyle(
                              color: alertsAndColors.darkBlue,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                            ),),
                            trailing: Container(
                              alignment: Alignment.center,
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: alertsAndColors.lightPink,
                                size: 25,
                              ),
                            ),
                            children: [
                              InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text("Full Time"),
                                ),
                              ),InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text("Part Time"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: -4,
                            left: 12,
                            child: Text(
                              "Job Type * ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Poppins",
                                  backgroundColor: Colors.white
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                //exp
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: yearsOfExp,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Years Of Experience As Bake *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //mincakes day
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: maxCakeDay,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Maximum Cakes Per Day *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //mincakeweek
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: maxCakeWeek,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Maximum Cakes Per Week *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //spesl
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: specialize,
                      maxLines: 5,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Specialized In *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //PRE VEN NAME
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: preferVenName,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Preferred Vendor Name *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),
                //spesl
                Padding(
                    padding:EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: description,
                      maxLines: 5,
                      style: TextStyle(
                          color: alertsAndColors.darkBlue,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        label: Text("Description *",style: TextStyle(
                            fontFamily: "Poppins"
                        ),),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.grey)),
                      ),
                    )
                ),

                //others end

                SizedBox(height: 30,),

                Center(
                  child: Container(
                    height: 40,
                    width:200,
                    child: RaisedButton(
                      color: alertsAndColors.lightPink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      onPressed: (){

                      },
                      child: Text(
                        "DONE" ,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins"
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15,),

                Center(
                  child: InkWell(
                    onTap: ()=>Navigator.pop(context),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        color: alertsAndColors.lightPink,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

