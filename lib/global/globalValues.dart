import 'package:flutter/material.dart';

class Global extends ChangeNotifier {
  int userType = 0;

  void setUserType(data) {
    userType = data;
    notifyListeners();
  }
}
