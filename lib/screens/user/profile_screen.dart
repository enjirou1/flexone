import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/models/input_validation.dart';
import 'package:flexone/providers/preferences.dart';
import 'package:flexone/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  InputValidation _nameValidation = InputValidation(isValid: true, message: '');

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    final _user = FirebaseAuth.instance.currentUser;
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final Color _fontColor =
        _preferencesProvider.isDarkTheme ? Colors.white : secondaryColor;

    _nameController.text = _provider.user!.fullname!;
    _aboutController.text = _provider.user?.about ?? "";
    _phoneController.text = _provider.user?.phone ?? "";
    _addressController.text = _provider.user?.address ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("edit_profile").tr(),
        actions: const [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.save,
                color: Color(0XFFD6D6D6),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  icon: Icon(Icons.person, color: _fontColor),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _preferencesProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black)),
                  labelText: "fullname:".tr(),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText:
                      _nameValidation.isValid ? null : _nameValidation.message),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _aboutController,
              minLines: 2,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  icon: Icon(Icons.note_rounded, color: _fontColor),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _preferencesProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black)),
                  labelText: "about_me:".tr(),
                  labelStyle: TextStyle(color: _fontColor)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  icon: Icon(Icons.phone, color: _fontColor),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _preferencesProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black)),
                  labelText: "phone_number:".tr(),
                  labelStyle: TextStyle(color: _fontColor)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                  icon: Icon(Icons.home, color: _fontColor),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _preferencesProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black)),
                  labelText: "address:".tr(),
                  labelStyle: TextStyle(color: _fontColor)),
            ),
          ],
        ),
      ),
    );
  }
}
