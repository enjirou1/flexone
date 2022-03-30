import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/models/input_validation.dart';
import 'package:flexone/models/user_result.dart';
import 'package:flexone/providers/email_sign_in.dart';
import 'package:flexone/providers/google_sign_in.dart';
import 'package:flexone/providers/preferences.dart';
import 'package:flexone/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController2 = TextEditingController();
  InputValidation _emailValidation =
      InputValidation(isValid: true, message: '');
  InputValidation _passwordValidation =
      InputValidation(isValid: true, message: '');

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _fontColor =
        _provider.isDarkTheme ? Colors.white : Colors.black;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            'sign_in',
            style: poppinsTheme.headline4,
          ).tr(),
          Column(
            children: [
              Container(
                width: 300,
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email, color: secondaryColor),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: secondaryColor)),
                        labelText: "Email: ",
                        labelStyle: TextStyle(color: secondaryColor),
                        errorText: _emailValidation.isValid
                            ? null
                            : _emailValidation.message),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key, color: secondaryColor),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: secondaryColor)),
                        labelText: "Password: ",
                        labelStyle: TextStyle(color: secondaryColor),
                        errorText: _passwordValidation.isValid
                            ? null
                            : _passwordValidation.message),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              InputValidation _emailValidation2 =
                                  InputValidation(isValid: true, message: '');
                              return StatefulBuilder(
                                builder: (context, setState) => AlertDialog(
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  actionsPadding: const EdgeInsets.only(
                                      left: 10, top: 0, right: 10, bottom: 10),
                                  title: const Text('Forgot Password'),
                                  actions: [
                                    TextField(
                                        controller: _emailController2,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            labelText: "Email: ",
                                            labelStyle: TextStyle(
                                                color: secondaryColor),
                                            errorText: _emailValidation2.isValid
                                                ? null
                                                : _emailValidation2.message)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (_emailController2
                                                .text.isNotEmpty) {
                                              final provider = Provider.of<
                                                      EmailSignInProvider>(
                                                  context,
                                                  listen: false);
                                              try {
                                                await provider.resetPassword(
                                                    _emailController2.text);
                                                Navigator.pop(context);
                                              } on FirebaseAuthException catch (e) {
                                                setState(() {
                                                  _emailValidation2 =
                                                      InputValidation(
                                                          isValid: false,
                                                          message: tr(e.code));
                                                });
                                              }
                                            }
                                          },
                                          child: const Text('submit').tr()),
                                    )
                                  ],
                                ),
                              );
                            }),
                        child: const Text('forgot_password').tr()),
                  )
                ]),
              ),
              SizedBox(
                width: 300,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    _emailController.text.isEmpty
                        ? _emailValidation = InputValidation(
                            isValid: false, message: tr('error.email.empty'))
                        : _emailValidation =
                            InputValidation(isValid: true, message: '');
                    _passwordController.text.isEmpty
                        ? _passwordValidation = InputValidation(
                            isValid: false, message: tr('error.password.empty'))
                        : _passwordValidation =
                            InputValidation(isValid: true, message: '');

                    if (_emailValidation.isValid &&
                        _passwordValidation.isValid) {
                      try {
                        final provider = Provider.of<EmailSignInProvider>(
                            context,
                            listen: false);
                        await provider.signIn(
                            _emailController.text, _passwordController.text);
                        Get.offAllNamed('/');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "invalid-email" ||
                            e.code == "user-not-found") {
                          _emailValidation = InputValidation(
                              isValid: false, message: tr(e.code));
                        } else if (e.code == "weak-password" ||
                            e.code == "wrong-password") {
                          _passwordValidation = InputValidation(
                              isValid: false, message: tr(e.code));
                        } else {
                          Get.snackbar("Error", tr(e.code),
                              snackPosition: SnackPosition.BOTTOM,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              duration: const Duration(seconds: 2));
                        }

                        print(e.code);
                      } catch (e) {
                        print(e);
                      }
                    }

                    setState(() {});
                  },
                  label:
                      Text('sign_in', style: TextStyle(color: _fontColor)).tr(),
                  icon: FaIcon(
                    FontAwesomeIcons.rightToBracket,
                    color: _fontColor,
                  ),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    await provider.googleLogin();

                    final User? _user = FirebaseAuth.instance.currentUser;

                    if (_user != null) {
                      try {
                        await UserModel.register(
                            _user.email!, "", _user.displayName!, "1");
                        final userModel =
                            await UserModel.getUserByEmail(_user.email);
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        userProvider.setUser(userModel!);
                        Get.offAllNamed('/');
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  label: Text('sign_in_with_google',
                          style: TextStyle(color: _fontColor))
                      .tr(),
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: _fontColor,
                  ),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('new_here').tr(),
              const SizedBox(width: 10),
              TextButton(
                child: const Text('create_an_account').tr(),
                onPressed: () {
                  Get.offNamed('/register');
                },
              )
            ],
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailController2.dispose();
    super.dispose();
  }
}
