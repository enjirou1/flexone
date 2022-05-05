import 'package:flexone/data/models/user_result.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  int _cartItems = 0;

  UserModel? get user => _user;
  int get cartItems => _cartItems;

  Future setUser(UserModel user) async {
    _user = user;
    notifyListeners();
  }

  void updatePoint(int point) {
    _user!.point = point;
    notifyListeners();
  }

  void logout() async {
    _user = null;
    _cartItems = 0;
    notifyListeners();
  }

  void setCartItems(int value) {
    _cartItems = value;
    notifyListeners();
  }

  void addItem() {
    _cartItems++;
    notifyListeners();
  }

  void removeItem() {
    _cartItems--;
    notifyListeners();
  }
}
