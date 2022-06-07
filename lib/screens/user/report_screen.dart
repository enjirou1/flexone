import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
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

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _controller = TextEditingController();
  InputValidation _reasonValidation =
      InputValidation(isValid: true, message: '');
  String? _image = "";
  XFile? _file;

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final Color _fontColor =
        _preferencesProvider.isDarkTheme ? Colors.white : secondaryColor;

    return Scaffold(
      appBar: AppBar(
          leading: Align(
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () => Get.back(result: null),
                  icon: const FaIcon(FontAwesomeIcons.xmark))),
          title: const Text('report').tr(),
          actions: [
            IconButton(
                onPressed: () async {
                  if (_controller.text.isEmpty) {
                    _reasonValidation = InputValidation(
                        isValid: false, message: tr('error.reason.empty'));
                  } else {
                    _reasonValidation =
                        InputValidation(isValid: true, message: '');
                    await UserModel.report(_provider.user!.userId!,
                            Get.parameters['id']!, _controller.text, _image)
                        .catchError((error) {
                      Get.snackbar('error', error.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          animationDuration: const Duration(milliseconds: 300),
                          duration: const Duration(seconds: 2));
                    });

                    Get.back(result: true);
                  }
                  setState(() {});
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ))
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: null,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.text_snippet_rounded),
                  labelText: tr("reason"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _reasonValidation.isValid
                      ? null
                      : _reasonValidation.message),
            ),
            const SizedBox(height: 20),
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
                              _image = await UploadService.uploadImage(
                                  _file!, "report", Get.parameters['id']!);
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
                              _image = await UploadService.uploadImage(
                                  _file!, "report", Get.parameters['id']!);
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
                  }),
              child: (_image != "")
                  ? Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(_image!), fit: BoxFit.contain)),
                    )
                  : Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          image: const DecorationImage(
                              image: AssetImage('assets/images/image-icon.png'),
                              fit: BoxFit.cover)),
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}
