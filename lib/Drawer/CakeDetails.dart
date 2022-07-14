import 'package:cakey_vendor/CommonClass/AlertsAndColors.dart';
import 'package:cakey_vendor/ContextClass.dart';
import 'package:cakey_vendor/Drawer/AddCakes.dart';
import 'package:cakey_vendor/Drawer/EditCake.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String cakeName = "";
  String cakePrice = "";
  String cakeDesc = "";
  String egg = "";
  String status = "";
  String cake_id = "";
  String cakeId = "";
  String cakeCustomPossible = "";
  String cakeTierPoss = "";

  List<String> images = [];
  var weights = [];

  //pg dots
  int pageViewCurIndex = 0;
  var myPgCntrl = new PageController();
  @override
  void initState(){
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

      images = pref.getStringList('cakeImages')??[];
      weights = pref.getStringList('cakeWeight')??[];

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
                    SizedBox(height: 15,),
                    //descriptions
                    Text("$cakeDesc" , style: TextStyle(
                        color: Colors.grey[400],
                        fontSize:13,
                        fontFamily: "Poppins"
                    ),),
                    SizedBox(height: 15,),

                    //status....
                    Text("STATUS" , style: TextStyle(
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
                    Text("$status" , style: TextStyle(
                        color: status.toLowerCase()=="new"?
                        Colors.red:status.toLowerCase()=="approved"?
                        Colors.green:Colors.grey[400],
                        fontSize:14,
                        fontFamily: "Poppins"
                    ),),
                    SizedBox(height: 10,),

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
                    SizedBox(height: 15,),

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
                    SizedBox(height: 15,),

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
                    SizedBox(height: 15,),

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
                        SizedBox(height: 15,),
                      ],
                    )

                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
