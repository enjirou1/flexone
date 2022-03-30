import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  User? get user => _user;

  Future signUp(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    _user = result.user;

    notifyListeners();
  }

  Future signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    _user = result.user;

    notifyListeners();
  }

  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future signOut() async {
    _auth.signOut();
  }
}
