import 'package:flutter/material.dart';

class ContextClass extends ChangeNotifier{

  bool cakeUpdated = false;
  String cakePrice = "";

  void setCakeUpdated(bool update){
    cakeUpdated = update;
    notifyListeners();
  }
  bool getCakeUpdate()=>cakeUpdated;

  void setCakePrice(String price){
    cakePrice = price;
    notifyListeners();
  }
  String getCakePrice()=>cakePrice;

  void clearAllData(){
    cakeUpdated = false;
    cakePrice = "";
  }

}