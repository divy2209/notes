import 'package:flutter/material.dart';

class ChooseColor extends ChangeNotifier {
  late int index;
  void changeColor(int index){
    this.index = index;
    notifyListeners();
  }
  void assign(int index){
    this.index = index;
  }
}