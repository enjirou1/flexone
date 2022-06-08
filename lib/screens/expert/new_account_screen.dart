import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/expert_result.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewAccountScreen extends StatefulWidget {
  const NewAccountScreen({Key? key}) : super(key: key);

  @override
  State<NewAccountScreen> createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  InputValidation _accountNameValidation = InputValidation(isValid: true, message: '');
  InputValidation _accountNumberValidation = InputValidation(isValid: true, message: '');
  InputValidation _educationValidation = InputValidation(isValid: true, message: '');
  InputValidation _jobValidation = InputValidation(isValid: true, message: '');
  InputValidation _identityCardValidation = InputValidation(isValid: true, message: '');
  String _bank = "BCA";
  String? _image = "";
  XFile? _file;

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final Color _fontColor = _preferencesProvider.isDarkTheme ? Colors.white : secondaryColor;
    final Color _borderColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.xmark),
          onPressed: () {
            Get.back(result: null);
          },
        ),
        title: const Text('create_expert_account').tr(),
        actions: [
          IconButton(
            onPressed: () async {
              _accountNameValidation = InputValidation(isValid: _accountNameController.text.isNotEmpty, message: tr('error.account_name.empty'));
              _accountNumberValidation = InputValidation(isValid: _accountNumberController.text.isNotEmpty, message: tr('error.account_number.empty'));
              _educationValidation = InputValidation(isValid: _educationController.text.isNotEmpty, message: tr('error.education.empty'));
              _jobValidation = InputValidation(isValid: _jobController.text.isNotEmpty, message: tr('error.job.empty'));
              _identityCardValidation = InputValidation(isValid: _image == "" ? false : true, message: tr('error.personal_identity_card.empty'));

              if (_accountNameValidation.isValid && _accountNumberValidation.isValid && _educationValidation.isValid && _jobValidation.isValid && _identityCardValidation.isValid) {
                try {
                  await Expert.createNew(
                    _provider.user!.userId!,
                    _image!,
                    _bank,
                    _accountNameController.text,
                    _accountNumberController.text,
                    _educationController.text,
                    _jobController.text
                  );

                  await UserModel.getUserByEmail(_provider.user!.email).then((value) {
                    _provider.setUser(value!);
                  });

                  Get.back(result: true);
                } catch (e) {
                  Get.snackbar('Error', e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    animationDuration: const Duration(milliseconds: 300),
                    duration: const Duration(seconds: 2)
                  );
                }
              }

              setState(() {});
            },
            icon: const Icon(Icons.check)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('personal_identity_card').tr(),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: [
                        ListTile(
                          title: const Text("open_camera").tr(),
                          tileColor: Colors.white,
                          textColor: Colors.black,
                          onTap: () async {
                            try {
                              _file = await UploadService.getImage(0);
                              Navigator.pop(context);
                              _image = await UploadService.uploadImage(_file!, "identity", _provider.user!.userId!);
                            } on FirebaseException catch (e) {
                              print(e.message!);
                            } catch (e) {
                              print(e.toString());
                            }
                            setState(() {});
                          },
                        ),
                        ListTile(
                          title: const Text("select_photo").tr(),
                          tileColor: Colors.white,
                          textColor: Colors.black,
                          onTap: () async {
                            try {
                              _file = await UploadService.getImage(1);
                              Navigator.pop(context);
                              _image = await UploadService.uploadImage(_file!, "identity", _provider.user!.userId!);
                            } on FirebaseException catch (e) {
                              print(e.message!);
                            } catch (e) {
                              print(e.toString());
                            }
                            setState(() {});
                          },
                        ),
                        ListTile(
                          title: const Text("delete_photo").tr(),
                          tileColor: Colors.white,
                          textColor: Colors.black,
                          onTap: () {
                            _file = null;
                            _image = "";
                            setState(() {});

                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
                ),
                child: (_image != "")
                ? Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 9 / 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(_image!),
                        fit: BoxFit.contain
                      )
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 9 / 16,
                    decoration: BoxDecoration(
                      border: Border.all(color: _borderColor),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/image-icon.png'),
                        fit: BoxFit.fill
                      )
                    ),
                  ),
              ),
              if (!_identityCardValidation.isValid)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 5),
                  child: Text(
                    _identityCardValidation.message,
                    style:
                        poppinsTheme.caption!.copyWith(color: Colors.red[700]),
                  ),
                ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                items: ['BCA', 'BNI', 'BRI', 'MANDIRI', 'PERMATA'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value), 
                    value: value
                  );
                }).toList(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_balance_rounded),
                  labelText: tr('bank'),
                  labelStyle: TextStyle(color: _fontColor),
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                value: _bank,
                onChanged: (value) {
                  setState(() {
                    _bank = value!;
                  });
                }
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _accountNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: tr("account_holder_name"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _accountNameValidation.isValid ? null : _accountNameValidation.message
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: tr("account_number"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _accountNumberValidation.isValid ? null : _accountNumberValidation.message
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _educationController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.school_rounded),
                  labelText: tr("education"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _educationValidation.isValid ? null : _educationValidation.message
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _jobController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.work_rounded),
                  labelText: tr("job"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _jobValidation.isValid ? null : _jobValidation.message
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
