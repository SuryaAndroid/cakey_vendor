import 'dart:convert';
import 'dart:io';
import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'CustomizeDetails.dart';
import 'OrderDetails.dart';

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
  List newList =[];
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
        // newOrders.reversed.toList();
        // print(newOrders);
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
        // oldList = oldList.reversed.toList();
        print(oldList);
        newOrders = newOrders +oldList ;
        newOrders.sort((a,b)=>a['Created_On'].toString().compareTo(simplyFormat(time: DateTime.now(),dateOnly: false)));
        print(simplyFormat(time: DateTime.now(),dateOnly: true));
        // newOrders = newOrders.reversed.toList();
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> gotoCustomizeOrd(int index) async{

    var pref = await SharedPreferences.getInstance();
    //flav

    List flavs = newOrders[index]['Flavour'];

    if(flavs.isEmpty||flavs==null){
      flavs=[{"Name":"Vanilla","Price":"0"}];
    }

    pref.remove("Cus_Shape");
    pref.remove("Cus_CakeID");
    pref.remove("Cus_Cake_ID");
    pref.remove("Cus_EggOrEggless");
    pref.remove("Cus_Image");
    pref.remove("Cus_Weight");
    pref.remove("Cus_VendorID");
    pref.remove("Cus_Vendor_ID");
    pref.remove("Cus_VendorName");
    pref.remove("Cus_VendorPhoneNumber1");
    pref.remove("Cus_VendorPhoneNumber2");
    pref.remove("Cus_UserID");
    pref.remove("Cus_User_ID");
    pref.remove("Cus_UserName");
    pref.remove("Cus_UserPhoneNumber");
    pref.remove("Cus_DeliveryAddress");
    pref.remove("Cus_DeliveryDate");
    pref.remove("Cus_DeliverySession");
    pref.remove("Cus_DeliveryInformation");
    pref.remove("Cus_Created_On");
    pref.remove("Cus_Status");
    pref.remove("Cus_Id");
    pref.remove("Cus_id");
    pref.remove("Cus_CustomizeCake");
    pref.remove("Cus_VendorAddress");


    pref.setString("Cus_id", newOrders[index]['_id']);
    pref.setString("Cus_Shape", newOrders[index]['Shape'].toString());
    pref.setString("Cus_EggOrEggless", newOrders[index]['EggOrEggless']);
    pref.setString("Cus_Image", 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkp-kR6zRZP6qPx7e-Uvy6lDvv05Ud6TT2Yw&usqp=CAU');
    pref.setString("Cus_CakeType", 'Customized Cake');
    pref.setString("Cus_Weight", newOrders[index]['Weight']);
    pref.setString("Cus_VendorID", newOrders[index]['VendorID']);
    pref.setString("Cus_Vendor_ID", newOrders[index]['Vendor_ID']);
    pref.setString("Cus_UserID", newOrders[index]['UserID']);
    pref.setString("Cus_User_ID", newOrders[index]['User_ID']);
    pref.setString("Cus_UserName", newOrders[index]['UserName']);
    pref.setString("Cus_VendorName", newOrders[index]['VendorName']);
    pref.setString("Cus_VendorPhoneNumber1", newOrders[index]['VendorPhoneNumber1']);
    pref.setString("Cus_VendorPhoneNumber2", newOrders[index]['VendorPhoneNumber2']);
    pref.setString("Cus_VendorAddress", newOrders[index]['VendorAddress']);
    pref.setString("Cus_UserPhoneNumber", newOrders[index]['UserPhoneNumber']);
    pref.setString("Cus_DeliveryAddress", newOrders[index]['DeliveryAddress']);
    pref.setString("Cus_DeliveryDate", newOrders[index]['DeliveryDate']);
    pref.setString("Cus_DeliverySession", newOrders[index]['DeliverySession']);
    pref.setString("Cus_DeliveryInformation", newOrders[index]['DeliveryInformation']);
    pref.setString("Cus_ItemCount", newOrders[index]['ItemCount'].toString());
    pref.setString("Cus_Status", newOrders[index]['Status']);
    pref.setString("Cus_Created_On", newOrders[index]['Created_On']);
    pref.setString("Cus_Id", newOrders[index]['Id']);


    print(flavs);
    print('flavourrrrrsss');
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>CustomizeDetails(flavour:flavs))
    );
  }

  // Future<void> gotoNormalOrd(int index) async{
  //   var pref = await SharedPreferences.getInstance();
  //   //flav
  //   List flavs = newOrders[index]['Flavour'];
  //
  //
  //   if(newOrders[index]['CakeName']==null||newOrders[index]['CakeName']=='NULL'){
  //     pref.setString("CakeName",'Customized cake' );
  //   }else{
  //     pref.setString("CakeName", newOrders[index]['CakeName']);
  //   }
  //
  //   pref.remove("Shape");
  //   pref.remove("CakeID");
  //   pref.remove("Cake_ID");
  //   pref.remove("CakeName");
  //   pref.remove("CakeCommonName");
  //   pref.remove("CakeType");
  //   pref.remove("CakeSubType");
  //   pref.remove("EggOrEggless");
  //   pref.remove("Image");
  //   pref.remove("Weight");
  //   pref.remove("VendorID");
  //   pref.remove("Vendor_ID");
  //   pref.remove("VendorName");
  //   pref.remove("VendorPhoneNumber1");
  //   pref.remove("VendorPhoneNumber2");
  //   pref.remove("UserID");
  //   pref.remove("User_ID");
  //   pref.remove("UserName");
  //   pref.remove("UserPhoneNumber");
  //   pref.remove("DeliveryAddress");
  //   pref.remove("DeliveryDate");
  //   pref.remove("DeliverySession");
  //   pref.remove("DeliveryInformation");
  //   pref.remove("Price");
  //   pref.remove("ItemCount");
  //   pref.remove("Discount");
  //   pref.remove("ExtraCharges");
  //   pref.remove("DeliveryCharge");
  //   pref.remove("Gst");
  //   pref.remove("Sgst");
  //   pref.remove("PaymentType");
  //   pref.remove("PaymentStatus");
  //   pref.remove("Created_On");
  //   pref.remove("Status");
  //   pref.remove("Id");
  //   pref.remove("_id");
  //   pref.remove("CustomizeCake");
  //   pref.remove("VendorAddress");
  //
  //
  //   pref.setString("_id", newOrders[index]['_id']);
  //   pref.setString("Shape", newOrders[index]['Shape'].toString());
  //   pref.setString("CakeID", newOrders[index]['CakeID']);
  //   pref.setString("Cake_ID", newOrders[index]['Cake_ID']);
  //   pref.setString("CakeCommonName", newOrders[index]['CakeCommonName']);
  //   pref.setString("CakeType", newOrders[index]['CakeType']);
  //   pref.setString("CakeSubType", newOrders[index]['CakeSubType']);
  //   pref.setString("EggOrEggless", newOrders[index]['EggOrEggless']);
  //   pref.setString("Image", newOrders[index]['Image']);
  //   pref.setString("Weight", newOrders[index]['Weight']);
  //   pref.setString("VendorID", newOrders[index]['VendorID']);
  //   pref.setString("Vendor_ID", newOrders[index]['Vendor_ID']);
  //   pref.setString("VendorName", newOrders[index]['VendorName']);
  //   pref.setString("VendorPhoneNumber1", newOrders[index]['VendorPhoneNumber1']);
  //   pref.setString("VendorPhoneNumber2", newOrders[index]['VendorPhoneNumber2']);
  //   pref.setString("VendorAddress", newOrders[index]['VendorAddress']);
  //   pref.setString("UserID", newOrders[index]['UserID']);
  //   pref.setString("User_ID", newOrders[index]['User_ID']);
  //   pref.setString("UserName", newOrders[index]['UserName']);
  //   pref.setString("UserPhoneNumber", newOrders[index]['UserPhoneNumber']);
  //   pref.setString("DeliveryAddress", newOrders[index]['DeliveryAddress']);
  //   pref.setString("DeliveryDate", newOrders[index]['DeliveryDate']);
  //   pref.setString("DeliverySession", newOrders[index]['DeliverySession']);
  //   pref.setString("DeliveryInformation", newOrders[index]['DeliveryInformation']);
  //   pref.setString("Price", newOrders[index]['Price']);
  //   pref.setString("ItemCount", newOrders[index]['ItemCount'].toString());
  //   pref.setString("Discount", newOrders[index]['Discount'].toString());
  //   pref.setString("ExtraCharges", newOrders[index]['ExtraCharges']);
  //   pref.setString("DeliveryCharge", newOrders[index]['DeliveryCharge']);
  //   pref.setString("Gst", newOrders[index]['Gst']);
  //   pref.setString("Sgst", newOrders[index]['Sgst'].toString());
  //   pref.setString("Total", newOrders[index]['Total'].toString());
  //   pref.setString("Status", newOrders[index]['Status']);
  //   pref.setString("PaymentType", newOrders[index]['PaymentType']);
  //   pref.setString("PaymentStatus", newOrders[index]['PaymentStatus']);
  //   pref.setString("Created_On", newOrders[index]['Created_On']);
  //   pref.setString("Id", newOrders[index]['Id']);
  //   pref.setString("CustomizeCake", newOrders[index]['CustomizeCake']);
  //
  //
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context)=>OrderDetail(flavour:flavs.toList()))
  //   );
  // }


  //pass data to next screen
  Future<void> gotoNormalOrd(int index) async{

    var pref = await SharedPreferences.getInstance();
    //flav
    List flavs = newOrders[index]['Flavour'];

    pref.remove("Shape");
    pref.remove("CakeID");
    pref.remove("Cake_ID");
    pref.remove("CakeName");
    pref.remove("CakeCommonName");
    pref.remove("CakeType");
    pref.remove("CakeSubType");
    pref.remove("EggOrEggless");
    pref.remove("Image");
    pref.remove("Weight");
    pref.remove("VendorID");
    pref.remove("Vendor_ID");
    pref.remove("VendorName");
    pref.remove("VendorPhoneNumber1");
    pref.remove("VendorPhoneNumber2");
    pref.remove("UserID");
    pref.remove("User_ID");
    pref.remove("UserName");
    pref.remove("UserPhoneNumber");
    pref.remove("DeliveryAddress");
    pref.remove("DeliveryDate");
    pref.remove("DeliverySession");
    pref.remove("DeliveryInformation");
    pref.remove("Price");
    pref.remove("ItemCount");
    pref.remove("Discount");
    pref.remove("ExtraCharges");
    pref.remove("DeliveryCharge");
    pref.remove("Gst");
    pref.remove("Sgst");
    pref.remove("PaymentType");
    pref.remove("PaymentStatus");
    pref.remove("Created_On");
    pref.remove("Status");
    pref.remove("Id");
    pref.remove("_id");
    pref.remove("CustomizeCake");
    pref.remove("VendorAddress");


    pref.setString("_id", newOrders[index]['_id']);
    pref.setString("Shape", newOrders[index]['Shape'].toString());
    pref.setString("CakeID", newOrders[index]['CakeID']);
    pref.setString("Cake_ID", newOrders[index]['Cake_ID']);
    pref.setString("CakeName", newOrders[index]['CakeName']);
    pref.setString("CakeCommonName", newOrders[index]['CakeCommonName']);
    pref.setString("CakeType", newOrders[index]['CakeType']);
    pref.setString("CakeSubType", newOrders[index]['CakeSubType']);
    pref.setString("EggOrEggless", newOrders[index]['EggOrEggless']);
    pref.setString("Image", newOrders[index]['Image']);
    pref.setString("Weight", newOrders[index]['Weight']);
    pref.setString("VendorID", newOrders[index]['VendorID']);
    pref.setString("Vendor_ID", newOrders[index]['Vendor_ID']);
    pref.setString("VendorName", newOrders[index]['VendorName']);
    pref.setString("VendorPhoneNumber1", newOrders[index]['VendorPhoneNumber1']);
    pref.setString("VendorPhoneNumber2", newOrders[index]['VendorPhoneNumber2']);
    pref.setString("VendorAddress", newOrders[index]['VendorAddress']);
    pref.setString("UserID", newOrders[index]['UserID']);
    pref.setString("User_ID", newOrders[index]['User_ID']);
    pref.setString("UserName", newOrders[index]['UserName']);
    pref.setString("UserPhoneNumber", newOrders[index]['UserPhoneNumber']);
    pref.setString("DeliveryAddress", newOrders[index]['DeliveryAddress']);
    pref.setString("DeliveryDate", newOrders[index]['DeliveryDate']);
    pref.setString("DeliverySession", newOrders[index]['DeliverySession']);
    pref.setString("DeliveryInformation", newOrders[index]['DeliveryInformation']);
    pref.setString("Price", newOrders[index]['Price']);
    pref.setString("ItemCount", newOrders[index]['ItemCount'].toString());
    pref.setString("Discount", newOrders[index]['Discount'].toString());
    pref.setString("ExtraCharges", newOrders[index]['ExtraCharges']);
    pref.setString("DeliveryCharge", newOrders[index]['DeliveryCharge']);
    pref.setString("Gst", newOrders[index]['Gst']);
    pref.setString("Sgst", newOrders[index]['Sgst'].toString());
    pref.setString("Total", newOrders[index]['Total'].toString());
    pref.setString("Status", newOrders[index]['Status']);
    pref.setString("PaymentType", newOrders[index]['PaymentType']);
    pref.setString("PaymentStatus", newOrders[index]['PaymentStatus']);
    pref.setString("Created_On", newOrders[index]['Created_On']);
    pref.setString("Id", newOrders[index]['Id']);
    pref.setString("CustomizeCake", newOrders[index]['CustomizeCake']);



    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>OrderDetail(flavour:flavs.toList()))
    );
  }


//pass customize list
  Future<void> gotoNormalOrdCus(int index) async{

    var pref = await SharedPreferences.getInstance();
    //flav
    List flavs = newOrders[index]['Flavour'];

    pref.remove("Shape");
    pref.remove("CakeID");
    pref.remove("Cake_ID");
    pref.remove("CakeName");
    pref.remove("CakeCommonName");
    pref.remove("CakeType");
    pref.remove("CakeSubType");
    pref.remove("EggOrEggless");
    pref.remove("Image");
    pref.remove("Weight");
    pref.remove("VendorID");
    pref.remove("Vendor_ID");
    pref.remove("VendorName");
    pref.remove("VendorPhoneNumber1");
    pref.remove("VendorPhoneNumber2");
    pref.remove("UserID");
    pref.remove("User_ID");
    pref.remove("UserName");
    pref.remove("UserPhoneNumber");
    pref.remove("DeliveryAddress");
    pref.remove("DeliveryDate");
    pref.remove("DeliverySession");
    pref.remove("DeliveryInformation");
    pref.remove("Created_On");
    pref.remove("Status");
    pref.remove("Id");
    pref.remove("_id");
    pref.remove("CustomizeCake");
    pref.remove("VendorAddress");


    pref.setString("_id", newOrders[index]['_id']);
    pref.setString("Shape", newOrders[index]['Shape'].toString());
    pref.setString("CakeID", newOrders[index]['CakeID']);
    pref.setString("Cake_ID", newOrders[index]['Cake_ID']);
    pref.setString("EggOrEggless", newOrders[index]['EggOrEggless']);
    pref.setString("Image", 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkp-kR6zRZP6qPx7e-Uvy6lDvv05Ud6TT2Yw&usqp=CAU');
    pref.setString("CakeType", 'Customized Cake');
    pref.setString("Weight", newOrders[index]['Weight']);
    pref.setString("VendorID", newOrders[index]['VendorID']);
    pref.setString("Vendor_ID", newOrders[index]['Vendor_ID']);
    pref.setString("UserID", newOrders[index]['UserID']);
    pref.setString("User_ID", newOrders[index]['User_ID']);
    pref.setString("UserName", newOrders[index]['UserName']);
    pref.setString("UserPhoneNumber", newOrders[index]['UserPhoneNumber']);
    pref.setString("DeliveryAddress", newOrders[index]['DeliveryAddress']);
    pref.setString("DeliveryDate", newOrders[index]['DeliveryDate']);
    pref.setString("DeliverySession", newOrders[index]['DeliverySession']);
    pref.setString("DeliveryInformation", newOrders[index]['DeliveryInformation']);
    pref.setString("Price", newOrders[index]['Price']);
    pref.setString("ItemCount", newOrders[index]['ItemCount'].toString());
    pref.setString("Discount", newOrders[index]['Discount'].toString());
    pref.setString("ExtraCharges", newOrders[index]['ExtraCharges']);
    pref.setString("DeliveryCharge", newOrders[index]['DeliveryCharge']);
    pref.setString("Gst", newOrders[index]['Gst']);
    pref.setString("Sgst", newOrders[index]['Sgst'].toString());
    pref.setString("Total", newOrders[index]['Total'].toString());
    pref.setString("Status", newOrders[index]['Status']);
    pref.setString("PaymentType", newOrders[index]['PaymentType']);
    pref.setString("PaymentStatus", newOrders[index]['PaymentStatus']);
    pref.setString("Created_On", newOrders[index]['Created_On']);
    pref.setString("Id", newOrders[index]['Id']);
    pref.setString("CustomizeCake", newOrders[index]['CustomizeCake']);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>OrderDetail(flavour:flavs.toList()))
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
              // GroupedListView<dynamic , String>(
              //     elements: newOrders,
              //     shrinkWrap: true,
              //     groupBy: (e)=>e['Created_On'],
              //     order: GroupedListOrder.DESC,
              //     groupSeparatorBuilder: (String i)=>Container(),
              //     itemBuilder: (context , e){
              //       return InkWell(
              //         onTap: (){
              //           print(formateToDay(e['Created_On'].toString().split(" ").first));
              //
              //         },
              //         child: Container(
              //           padding: EdgeInsets.all(15),
              //           child: Row(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               e['Image']==null?
              //               Container(
              //                 alignment: Alignment.center,
              //                 height: 60,
              //                 width: 60,
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: Colors.grey[300],
              //                 ),
              //                 child:
              //                 Icon(Icons.image_outlined , color:alertsAndColors.darkBlue,size: 35,),
              //               ):
              //               Container(
              //                 alignment: Alignment.center,
              //                 height: 60,
              //                 width: 60,
              //                 decoration: BoxDecoration(
              //                     shape: BoxShape.circle,
              //                     color: Colors.grey[300],
              //                     image: DecorationImage(
              //                         image: NetworkImage(e['Image'].toString()),
              //                         fit: BoxFit.cover
              //                     )
              //                 ),
              //               ),
              //               SizedBox(width: 6,),
              //               Expanded(
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       e['CustomizeCake']!=null?
              //                       Text("New Order "+e['CakeName'].toString()+" From ${e['UserName']}",style: TextStyle(
              //                           color: Colors.grey[600],
              //                           fontFamily: "Poppins",
              //                           fontSize: 13
              //                       ),):
              //                       Text("New Customize Cake Is Ordered By ${e['UserName']}. Click to view",style: TextStyle(
              //                           color: Colors.grey[600],
              //                           fontFamily: "Poppins",
              //                           fontSize: 13
              //                       ),),
              //                       SizedBox(height: 10,),
              //                       Text(
              //                         simplyFormat(time: DateTime.now(),dateOnly: true)==
              //                             e['Created_On'].toString().split(" ").first?
              //                         "Today":formateToDay(e['Created_On'].toString().split(" ").first)
              //                         ,style: TextStyle(
              //                           color: alertsAndColors.darkBlue,
              //                           fontSize: 15,
              //                           fontWeight: FontWeight.bold
              //                       ),),
              //                     ],
              //                   )
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              // )
              Column(
                children:newOrders.map((e){
                  return InkWell(
                    onTap: (){
                      print(formateToDay(e['Created_On'].toString().split(" ").first));
                      if(e['CustomizeCake']!=null){
                       if (e['CustomizeCake']=='y'){
                         gotoNormalOrdCus(newOrders.indexWhere((element) => element["Created_On"]==e["Created_On"]));
                       }else{
                         gotoNormalOrd(newOrders.indexWhere((element) => element["Created_On"]==e["Created_On"]));
                       }
                      }else{
                        gotoCustomizeOrd(newOrders.indexWhere((element) => element["Created_On"]==e["Created_On"]));
                      }

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
                                  Text("New Order "+e['CakeName'].toString()+" From ${e['UserName']}",style: TextStyle(
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
                }).toList(),
              ):
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

// class GroupedListView<T, E> extends ListView {
//   GroupedListView({
//     required E Function(T element) groupBy,
//     required Widget Function(E value) groupSeparatorBuilder,
//     required Widget Function(BuildContext context, T element) itemBuilder,
//     GroupedListOrder order = GroupedListOrder.ASC,
//     bool sort = true,
//     Widget separator = const Divider(height: 0.0),
//     List<T>? elements,
//     Key? key,
//     Axis scrollDirection = Axis.vertical,
//     ScrollController? controller,
//     bool? primary,
//     ScrollPhysics? physics,
//     bool shrinkWrap = false,
//     EdgeInsetsGeometry? padding,
//     bool addAutomaticKeepAlives = true,
//     bool addRepaintBoundaries = true,
//     bool addSemanticIndexes = true,
//     double? cacheExtent,
//   }) : super.builder(
//     key: key,
//     scrollDirection: scrollDirection,
//     controller: controller,
//     primary: primary,
//     physics: physics,
//     shrinkWrap: shrinkWrap,
//     padding: padding,
//     itemCount: elements!.length * 2,
//     addAutomaticKeepAlives: addAutomaticKeepAlives,
//     addRepaintBoundaries: addRepaintBoundaries,
//     addSemanticIndexes: addSemanticIndexes,
//     cacheExtent: cacheExtent,
//     itemBuilder: (context, index) {
//       int actualIndex = index ~/ 2;
//       if (index.isEven) {
//         E curr = groupBy(elements![actualIndex]);
//         E prev = (actualIndex - 1 < 0
//             ? null
//             : groupBy(elements[actualIndex - 1])) as E;
//
//         if (prev != curr) {
//           return groupSeparatorBuilder(curr);
//         }
//         return Container();
//       }
//       return itemBuilder(context, elements![actualIndex]);
//     },
//   ) {
//     if (sort && elements.isNotEmpty) {
//       if (groupBy(elements[0]) is Comparable) {
//         elements.sort((e1, e2) =>
//             (groupBy(e1) as Comparable).compareTo(groupBy(e2) as Comparable));
//       } else {
//         elements
//             .sort((e1, e2) => ('${groupBy(e1)}').compareTo('${groupBy(e2)}'));
//       }
//       if (order == GroupedListOrder.DESC) {
//         elements = elements.reversed.toList();
//       }
//     }
//   }
// }
//
// enum GroupedListOrder { ASC, DESC }


