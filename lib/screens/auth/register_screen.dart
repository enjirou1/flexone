import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/data/providers/email_sign_in.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  InputValidation _emailValidation = InputValidation(isValid: true, message: '');
  InputValidation _passwordValidation = InputValidation(isValid: true, message: '');
  InputValidation _nameValidation = InputValidation(isValid: true, message: '');

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _fontColor = _provider.isDarkTheme ? Colors.white : Colors.black;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            Text('sign_up', style: poppinsTheme.headline4).tr(),
            Column(
              children: [
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: tr("fullname:"),
                          errorText: _nameValidation.isValid ? null : _nameValidation.message
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.email),
                          labelText: "Email: ",
                          errorText: _emailValidation.isValid ? null : _emailValidation.message
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.vpn_key),
                          labelText: "Password: ",
                          errorText: _passwordValidation.isValid ? null : _passwordValidation.message
                        ),
                      ),
                    ]
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      _emailController.text.isEmpty
                        ? _emailValidation = InputValidation(isValid: false, message: tr('error.email.empty'))
                        : _emailValidation = InputValidation(isValid: true, message: '');
                      _passwordController.text.isEmpty
                        ? _passwordValidation = InputValidation(isValid: false, message: tr('error.password.empty'))
                        : _passwordValidation = InputValidation(isValid: true, message: '');
                      _nameController.text.isEmpty
                        ? _nameValidation = InputValidation(isValid: false, message: tr('error.name.empty'))
                        : _nameValidation = InputValidation(isValid: true, message: '');

                      if (_emailValidation.isValid && _passwordValidation.isValid && _nameValidation.isValid) {
                        try {
                          final provider = Provider.of<EmailSignInProvider>(context, listen: false);
                          await provider.signUp(_emailController.text, _passwordController.text);
                          await UserModel.register(_emailController.text, _passwordController.text, _nameController.text, "0");
                          Get.offAllNamed('/');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "invalid-email" || e.code == "email-already-in-use") {
                            _emailValidation = InputValidation(isValid: false, message: tr(e.code));
                          } else if (e.code == "weak-password") {
                            _passwordValidation = InputValidation(isValid: false, message: tr(e.code));
                          } else {
                            Get.snackbar("Error", tr(e.code),
                              snackPosition: SnackPosition.BOTTOM,
                              animationDuration: const Duration(milliseconds: 300),
                              duration: const Duration(seconds: 2)
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      }

                      setState(() {});
                    },
                    label: Text('sign_up', style: TextStyle(color: _fontColor)).tr(),
                    icon: FaIcon(FontAwesomeIcons.rightToBracket, color: _fontColor),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('already_have_an_account').tr(),
                const SizedBox(width: 10),
                TextButton(
                  child: const Text('sign_in').tr(),
                  onPressed: () {
                    Get.offNamed('/login');
                  },
                )
              ],
            )
          ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
