import 'dart:convert';
import 'dart:io';
import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:cakey_vendor/Drawer/MainDrawer.dart';
import 'package:cakey_vendor/Screens/NotificationScreen.dart';
import 'package:cakey_vendor/Screens/OrderDetails.dart';
import 'package:cakey_vendor/Screens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List OrdersList = [];
  AlertsAndColors alertsAndColors = new AlertsAndColors();
  var drawerKey = GlobalKey<ScaffoldState>();

//vendors
  List myVendorList = [];
  String currentVendorMail = "";
  String currentVendorName = "";
  String currentVendorStreet = "";
  String currentVendorCity = "";
  String currentVendorState = "";
  String currentVendorPin = "";
  String currentVendorPhn1 = "";
  String currentVendorPhn2 = "";
  String currentVendor_id = "";
  String currentVendorId = "";
  String authToken = '';
  String profileUrl = "";
  var vendorId;
  bool loading = true;

  Future<void> getIntitalpref() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      authToken = pref.getString('authToken') ?? 'null';
      currentVendorMail = pref.getString('authMail') ?? 'null';
    });
    print(authToken);
    print(currentVendor_id);
    getVendors();
  }

//vendor details
  Future<void> getVendors() async {
    alertsAndColors.showLoader(context);

    var list = [];
    try {
      var headers = {'Authorization': '$authToken'};

      var request = http.Request(
          'GET',
          Uri.parse(
              'https://cakey-database.vercel.app/api/vendors/listbyemail/$currentVendorMail'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        list = jsonDecode(await response.stream.bytesToString());

        setState(() {
          vendorId = list[0]['_id'];
          profileUrl = list[0]['ProfileImage'];
        });

        getOrderList(vendorId);

        Navigator.pop(context);
      } else {
        checkNetwork();
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error Occurred"),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      print(e);
      checkNetwork();
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }
  }

//orderlist
  Future<void> getOrderList(String id) async {
    alertsAndColors.showLoader(context);
    print(currentVendor_id);

    try {
      var res = await http.get(
          Uri.parse(
              "https://cakey-database.vercel.app/api/order/listbyvendorid/$id"),
          headers: {"Authorization": "$authToken"});
      if (res.statusCode == 200) {
        setState(() {
          OrdersList = jsonDecode(res.body);
          // OrdersList.reversed.toList();
        });
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Check Your Connection! try again'),
        backgroundColor: Colors.amber,
        action: SnackBarAction(
          label: "Retry",
          onPressed: () => setState(() {}),
        ),
      ));
    }
  }

//pass data to next screen
  Future<void> passDetails( index) async {
    var pref = await SharedPreferences.getInstance();
    //flav
    List flavs = index['Flavour'];

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

    pref.setString("_id", index['_id']);
    pref.setString("Shape", index['Shape'].toString());
    pref.setString("CakeID", index['CakeID']);
    pref.setString("Cake_ID", index['Cake_ID']);
    pref.setString("CakeName", index['CakeName']);
    pref.setString("CakeCommonName", index['CakeCommonName']);
    pref.setString("CakeType", index['CakeType']);
    pref.setString("CakeSubType", index['CakeSubType']);
    pref.setString("EggOrEggless", index['EggOrEggless']);
    pref.setString("Image", index['Image']);
    pref.setString("Weight", index['Weight']);
    pref.setString("VendorID", index['VendorID']);
    pref.setString("Vendor_ID", index['Vendor_ID']);
    pref.setString("VendorName", index['VendorName']);
    pref.setString(
        "VendorPhoneNumber1", index['VendorPhoneNumber1']);
    pref.setString(
        "VendorPhoneNumber2", index['VendorPhoneNumber2']);
    pref.setString("VendorAddress", index['VendorAddress']);
    pref.setString("UserID", index['UserID']);
    pref.setString("User_ID", index['User_ID']);
    pref.setString("UserName", index['UserName']);
    pref.setString("UserPhoneNumber", index['UserPhoneNumber']);
    pref.setString("DeliveryAddress", index['DeliveryAddress']);
    pref.setString("DeliveryDate", index['DeliveryDate']);
    pref.setString("DeliverySession", index['DeliverySession']);
    pref.setString(
        "DeliveryInformation", index['DeliveryInformation']);
    pref.setString("Price", index['Price']);
    pref.setString("ItemCount", index['ItemCount'].toString());
    pref.setString("Discount", index['Discount'].toString());
    pref.setString("ExtraCharges", index['ExtraCharges']);
    pref.setString("DeliveryCharge", index['DeliveryCharge']);
    pref.setString("Gst", index['Gst']);
    pref.setString("Sgst", index['Sgst'].toString());
    pref.setString("Total", index['Total'].toString());
    pref.setString("Status", index['Status']);
    pref.setString("PaymentType", index['PaymentType']);
    pref.setString("PaymentStatus", index['PaymentStatus']);
    pref.setString("Created_On", index['Created_On']);
    pref.setString("Id", index['Id']);
    pref.setString("CustomizeCake", index['CustomizeCake']);
    var newCreated_On =
        index['Created_On'].toString().split(' ').first;
    print(newCreated_On);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetail(flavour: flavs.toList())));
  }

//pass customize list
  Future<void> passDetailsCus( index) async {
    var pref = await SharedPreferences.getInstance();
    //flav
    List flavs = index['Flavour'];

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

    pref.setString("_id", index['_id']);
    pref.setString("Shape", index['Shape'].toString());
    pref.setString("CakeID", index['CakeID']);
    pref.setString("Cake_ID", index['Cake_ID']);
    pref.setString("EggOrEggless", index['EggOrEggless']);
    pref.setString("Image",
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkp-kR6zRZP6qPx7e-Uvy6lDvv05Ud6TT2Yw&usqp=CAU');
    pref.setString("CakeType", 'Customized Cake');
    pref.setString("Weight", index['Weight']);
    pref.setString("VendorID", index['VendorID']);
    pref.setString("Vendor_ID", index['Vendor_ID']);
    pref.setString("UserID", index['UserID']);
    pref.setString("User_ID", index['User_ID']);
    pref.setString("UserName", index['UserName']);
    pref.setString("UserPhoneNumber", index['UserPhoneNumber']);
    pref.setString("DeliveryAddress", index['DeliveryAddress']);
    pref.setString("DeliveryDate", index['DeliveryDate']);
    pref.setString("DeliverySession", index['DeliverySession']);
    pref.setString(
        "DeliveryInformation", index['DeliveryInformation']);
    pref.setString("Price", index['Price']);
    pref.setString("ItemCount", index['ItemCount'].toString());
    pref.setString("Discount", index['Discount'].toString());
    pref.setString("ExtraCharges", index['ExtraCharges']);
    pref.setString("DeliveryCharge", index['DeliveryCharge']);
    pref.setString("Gst", index['Gst']);
    pref.setString("Sgst", index['Sgst'].toString());
    pref.setString("Total", index['Total'].toString());
    pref.setString("Status", index['Status']);
    pref.setString("PaymentType", index['PaymentType']);
    pref.setString("PaymentStatus", index['PaymentStatus']);
    pref.setString("Created_On", index['Created_On']);
    pref.setString("Id", index['Id']);
    pref.setString("CustomizeCake", index['CustomizeCake']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetail(flavour: flavs.toList())));
  }

//network check
  Future<void> checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Internet Not Connected"),
        backgroundColor: Colors.brown,
        behavior: SnackBarBehavior.floating,
      ));
      print('not connected');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      getIntitalpref();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: MainDrawer(screen: "ordlist",),
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
                          'ORDER LIST',
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
                                  MaterialPageRoute(
                                      builder: (context) => NotificationScreen()));
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
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()));
                          },
                          child: profileUrl != "null"
                              ? CircleAvatar(
                                  radius: 14.7,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                      radius: 13,
                                      backgroundImage:
                                          NetworkImage("$profileUrl")),
                                )
                              : CircleAvatar(
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
          getIntitalpref();
        },
        child: GroupedListView<dynamic, dynamic>(
          elements: OrdersList,
          groupBy: (element) => simplyFormat(time: DateTime.now(),dateOnly: true)==
              element['Created_On'].toString().split(" ").first? "Today":formateToDay(element['Created_On'].toString().split(" ").first),
          groupSeparatorBuilder: (groupByValue) => Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(groupByValue,style: TextStyle(fontFamily:"Poppins",color: alertsAndColors.darkBlue,fontWeight:FontWeight.bold,fontSize: 18),)),
          itemBuilder: (c, element) =>
              Stack(
                  children: [
            GestureDetector(
              onTap: () {
                (element['CustomizeCake'] == 'n')
                    ? passDetails(element)
                    : passDetailsCus(element);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0Xffd4d4d4)),
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 135,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        width: 85,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: element['Image'] == null
                                    ? NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkp-kR6zRZP6qPx7e-Uvy6lDvv05Ud6TT2Yw&usqp=CAU')
                                    : NetworkImage(element['Image']))),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ID : ' + element['Id'],
                                    style: TextStyle(
                                        fontSize: 10, fontFamily: "Poppins"),
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.brown,
                                        radius: 8,
                                        child: CircleAvatar(
                                            radius: 6,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.person,
                                              size: 12,
                                              color: Colors.brown,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Container(
                                          child: Text(
                                        element['UserName'] == null
                                            ? 'UserName'
                                            : element['UserName']
                                                .toString()
                                                .split(' ')
                                                .first,
                                        style: TextStyle(
                                            fontSize: 10, fontFamily: "Poppins"),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    element['CakeName'] == null
                                        ? 'Cutomized Cake'
                                        : element['CakeName'],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins"),
                                  )),
                              Container(
                                height: 0.7,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                // width: width*0.63,
                                color: Colors.orange[100],
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_outlined,
                                                size: 12, color: Colors.black54),
                                            Container(
                                                child: Text(
                                              'Order date',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black54,
                                                  fontFamily: "Poppins"),
                                            )),
                                          ],
                                        ),
                                        Text(
                                          element['Created_On'] == null
                                              ? 'Date not specified'
                                              : element['Created_On'],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Poppins"),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_outlined,
                                                size: 12, color: Colors.black54),
                                            Container(
                                                child: Text(
                                              'Delivery',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black54,
                                                  fontFamily: "Poppins"),
                                            )),
                                          ],
                                        ),
                                        Text(
                                          element['DeliveryDate'] == null
                                              ? 'Date not specified'
                                              : element['DeliveryDate'],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Poppins"),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                left: 10,
                top: 15,
                child: element['Status'] == 'New'
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                        decoration: BoxDecoration(
                            color: alertsAndColors.lightPink,
                            borderRadius: new BorderRadius.only(
                                topRight: const Radius.circular(30.0),
                                bottomRight: const Radius.circular(30.0))),
                        child: Text(
                          'New',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontFamily: "Poppins"),
                        ),
                      )
                    : element['Status'] == 'Preparing'
                        ? Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                            decoration: BoxDecoration(
                                color: Color(0XFF6b55bd),
                                borderRadius: new BorderRadius.only(
                                    topRight: const Radius.circular(30.0),
                                    bottomRight: const Radius.circular(30.0))),
                            child: Text(
                              'Preparing',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: "Poppins"
                              ),
                            ),
                          )
                        : element['Status'] == 'Delivered'
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 1),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: new BorderRadius.only(
                                        topRight: const Radius.circular(30.0),
                                        bottomRight:
                                            const Radius.circular(30.0))),
                                child: Text(
                                  'Delivered',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontFamily: "Poppins"),
                                ),
                              )
                            : element['Status'] == 'Cancelled'
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: new BorderRadius.only(
                                            topRight: const Radius.circular(30.0),
                                            bottomRight:
                                                const Radius.circular(30.0))),
                                    child: Text(
                                      'Cancelled',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontFamily: "Poppins"),
                                    ),
                                  )
                                : element['Status'] == 'Assigned'
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 1),
                                        decoration: BoxDecoration(
                                            color: Colors.lightBlue,
                                            borderRadius: new BorderRadius.only(
                                                topRight:
                                                    const Radius.circular(30.0),
                                                bottomRight:
                                                    const Radius.circular(30.0))),
                                        child: Text(
                                          'Assigned',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontFamily: "Poppins"),
                                        ),
                                      )
                                    : Container()),
            Positioned(
                left: 10,
                top: 35,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(100.0),
                      )),
                )),
          ]),
          order: GroupedListOrder.DESC,
        ),
      ),
    );
  }
}
