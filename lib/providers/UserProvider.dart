import 'package:flutter/material.dart';
import 'package:momenta_share/models/UserModel.dart';
import 'package:momenta_share/services/AuthMethods.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  void refreshUser() async {
    _user = await AuthMethods.getUser();
    notifyListeners();
  }
}