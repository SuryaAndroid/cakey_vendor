
import 'dart:convert';
import 'dart:io';
import 'package:cakey_vendor/Drawer/MainDrawer.dart';
import 'package:cakey_vendor/Screens/NotificationScreen.dart';
import 'package:cakey_vendor/Screens/ProfileScreen.dart';
import 'package:http/http.dart' as http;
import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:cakey_vendor/Screens/CustomizeDetails.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

List _elements = [
  {'name': 'John', 'group': 'Team A'},
  {'name': 'Will', 'group': 'Team B'},
  {'name': 'Beth', 'group': 'Team A'},
  {'name': 'Miranda', 'group': 'Team B'},
  {'name': 'Mike', 'group': 'Team C'},
  {'name': 'Danny', 'group': 'Team C'},
];

class CustomizeList extends StatefulWidget {
  const CustomizeList({Key? key}) : super(key: key);

  @override
  State<CustomizeList> createState() => _CustomizeListState();
}

class _CustomizeListState extends State<CustomizeList> {
  List CusList = [];
  AlertsAndColors alertsAndColors = new AlertsAndColors();

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
  var drawerKey = GlobalKey<ScaffoldState>();

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

        getCustomizeList(vendorId);

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

  Future<void> getCustomizeList(String id) async {
    alertsAndColors.showLoader(context);
    try {
      var res = await http.get(
          Uri.parse(
              "https://cakey-database.vercel.app/api/customize/cake/listbyvendorid/$id"),
          headers: {"Authorization": "$authToken"});
      if (res.statusCode == 200) {
        setState(() {
          CusList = jsonDecode(res.body);
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

  Future<void> passDetailsCus(element) async {
    var pref = await SharedPreferences.getInstance();
    //flav

    List flavs = element['Flavour'];

    if (flavs.isEmpty || flavs == null) {
      flavs = [
        {"Name": "Vanilla", "Price": "0"}
      ];
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

    pref.setString("Cus_id", element['_id']);
    pref.setString("Cus_Shape", element['Shape'].toString());
    pref.setString("Cus_EggOrEggless", element['EggOrEggless']);
    pref.setString("Cus_Image",
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkp-kR6zRZP6qPx7e-Uvy6lDvv05Ud6TT2Yw&usqp=CAU');
    pref.setString("Cus_CakeType", 'Customized Cake');
    pref.setString("Cus_Weight", element['Weight']);
    pref.setString("Cus_VendorID", element['VendorID']);
    pref.setString("Cus_Vendor_ID", element['Vendor_ID']);
    pref.setString("Cus_UserID", element['UserID']);
    pref.setString("Cus_User_ID", element['User_ID']);
    pref.setString("Cus_UserName", element['UserName']);
    pref.setString("Cus_VendorName", element['VendorName']);
    pref.setString("Cus_VendorPhoneNumber1", element['VendorPhoneNumber1']);
    pref.setString("Cus_VendorPhoneNumber2", element['VendorPhoneNumber2']);
    pref.setString("Cus_VendorAddress", element['VendorAddress']);
    pref.setString("Cus_UserPhoneNumber", element['UserPhoneNumber']);
    pref.setString("Cus_DeliveryAddress", element['DeliveryAddress']);
    pref.setString("Cus_DeliveryDate", element['DeliveryDate']);
    pref.setString("Cus_DeliverySession", element['DeliverySession']);
    pref.setString("Cus_DeliveryInformation", element['DeliveryInformation']);
    pref.setString("Cus_ItemCount", element['ItemCount'].toString());
    pref.setString("Cus_Status", element['Status']);
    pref.setString("Cus_Created_On", element['Created_On']);
    pref.setString("Cus_Id", element['Id']);

    print(flavs);
    print('flavourrrrrsss');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomizeDetails(flavour: flavs)));
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
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: MainDrawer(screen: "cus"),
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
                          'CUSTOMIZE LIST',
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
                                      builder: (context) =>
                                          NotificationScreen()));
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
      body: GroupedListView<dynamic, String>(
          elements: CusList,
          groupBy: (element) => simplyFormat(
                      time: DateTime.now(), dateOnly: true) ==
                  element['Created_On'].toString().split(" ").first
              ? "Today"
              : formateToDay(element['Created_On'].toString().split(" ").first),
          groupSeparatorBuilder: (groupByValue) => Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                groupByValue,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: alertsAndColors.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
          itemBuilder: (c, element) => Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        passDetailsCus(element);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0Xffd4d4d4)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 123,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            child: Text(
                                          'ID : ' + element['Id'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: "Poppins"),
                                        )),
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
                                                  fontSize: 10,
                                                  fontFamily: "Poppins"),
                                            ))
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 1),
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
                                      margin:
                                          EdgeInsets.only(top: 3, bottom: 3),
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
                                                  Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      size: 12,
                                                      color: Colors.black54),
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
                                                  Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      size: 12,
                                                      color: Colors.black54),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 1),
                              decoration: BoxDecoration(
                                  color: alertsAndColors.lightPink,
                                  borderRadius: new BorderRadius.only(
                                      topRight: const Radius.circular(30.0),
                                      bottomRight:
                                          const Radius.circular(30.0))),
                              child: Text(
                                'New',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontFamily: "Poppins"),
                              ),
                            )
                          : element['Status'] == 'Ordered'
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 1),
                                  decoration: BoxDecoration(
                                      color: Color(0XFF6b55bd),
                                      borderRadius: new BorderRadius.only(
                                          topRight: const Radius.circular(30.0),
                                          bottomRight:
                                              const Radius.circular(30.0))),
                                  child: Text(
                                    'Ordered',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontFamily: "Poppins"),
                                  ),
                                )
                              : element['Status'] == 'Delivered'
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 1),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: new BorderRadius.only(
                                              topRight:
                                                  const Radius.circular(30.0),
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
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topRight:
                                                          const Radius.circular(
                                                              30.0),
                                                      bottomRight:
                                                          const Radius.circular(
                                                              30.0))),
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
                                                  borderRadius: new BorderRadius
                                                          .only(
                                                      topRight:
                                                          const Radius.circular(
                                                              30.0),
                                                      bottomRight:
                                                          const Radius.circular(
                                                              30.0))),
                                              child: Text(
                                                'Assigned',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontFamily: "Poppins"),
                                              ),
                                            )
                                          : element['Status'] == 'Sent'
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: new BorderRadius
                                                              .only(
                                                          topRight: const Radius
                                                              .circular(30.0),
                                                          bottomRight:
                                                              const Radius
                                                                      .circular(
                                                                  30.0))),
                                                  child: Text(
                                                    'Sent',
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
                      ))
                ],
              ),
        order: GroupedListOrder.ASC,
      ),
    );
  }
}
