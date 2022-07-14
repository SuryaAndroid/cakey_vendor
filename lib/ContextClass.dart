import 'package:flutter/material.dart';

class ContextClass extends ChangeNotifier{

  bool cakeUpdated = false;
  String cakePrice = "";
  List flavours = [];
  List shape = [];
  List weight = [];
  List tiers = [];

  //cakeupdated
  void setCakeUpdated(bool update){
    cakeUpdated = update;
    notifyListeners();
  }
  bool getCakeUpdate()=>cakeUpdated;

  //price
  void setCakePrice(String price){
    cakePrice = price;
    notifyListeners();
  }
  String getCakePrice()=>cakePrice;

  //flavours
  void setFlavour(List flav){
    flavours = flav;
  }
  List getFlavour()=>flavours;

  //shape
  void setShape(List shap){
    shape = shap;
  }
  List getShape()=>shape;

  //weight
  void setWeight(List weig){
    weight = weig;
  }
  List getWeigth()=>weight;

  void clearAllData(){
    cakeUpdated = false;
    cakePrice = "";
    flavours.clear();
    shape.clear();
    weight.clear();
    tiers.clear();
  }

}