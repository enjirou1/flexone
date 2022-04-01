import 'package:flexone/data/models/user_result.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future setUser(UserModel user) async {
    _user = user;
    notifyListeners();
  }
}
