import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/expert_result.dart';
import 'package:flexone/data/providers/certificates.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCertificateScreen extends StatefulWidget {
  const AddCertificateScreen({Key? key}) : super(key: key);

  @override
  State<AddCertificateScreen> createState() => _AddCertificateScreenState();
}

class _AddCertificateScreenState extends State<AddCertificateScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _image = "";
  XFile? _file;

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final _certificateProvider = Provider.of<CertificateProvider>(context, listen: false);
    final Color _fontColor = _preferencesProvider.isDarkTheme ? Colors.white : secondaryColor;
    final Color _borderColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () => Get.back(result: false),
            icon: const FaIcon(FontAwesomeIcons.xmark)
          )
        ),
        title: const Text('add_certificate').tr(),
        actions: [
          IconButton(
            onPressed: () async {
              if (_image != "") {
                try {
                  final Certificate result = await Expert.addCertificate(_provider.user!.expertId!, _image!, _controller.text);
                  _certificateProvider.addCertificate(result);
                  Get.back(result: true);
                } catch (e) {
                  Get.snackbar('Error', e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    animationDuration: const Duration(milliseconds: 300),
                    duration: const Duration(seconds: 2)
                  );
                }
              } else {
                Get.snackbar('Error', tr('error.image.empty'),
                  snackPosition: SnackPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 300),
                  duration: const Duration(seconds: 2)
                );
              }
            },
            icon: const Icon(Icons.check, color: Colors.white)
          )
        ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) {
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
                                _file!,
                                "certificate",
                                _provider.user!.expertId!
                              );
                            } on FirebaseException catch (e) {
                              Get.snackbar('Error', e.message!,
                                snackPosition: SnackPosition.BOTTOM,
                                animationDuration: const Duration(milliseconds: 300),
                                duration: const Duration(seconds: 2)
                              );
                            } catch (e) {
                              Get.snackbar('Error', e.toString(),
                                snackPosition: SnackPosition.BOTTOM,
                                animationDuration: const Duration(milliseconds: 300),
                                duration: const Duration(seconds: 2)
                              );
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
                                _file!,
                                "certificate",
                                _provider.user!.expertId!
                              );
                            } on FirebaseException catch (e) {
                              Get.snackbar('Error', e.message!,
                                snackPosition: SnackPosition.BOTTOM,
                                animationDuration: const Duration(milliseconds: 300),
                                duration: const Duration(seconds: 2)
                              );
                            } catch (e) {
                              Get.snackbar('Error', e.toString(),
                                snackPosition: SnackPosition.BOTTOM,
                                animationDuration: const Duration(milliseconds: 300),
                                duration: const Duration(seconds: 2)
                              );
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  }
                ),
                child: (_image != "") ? 
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: _borderColor),
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(_image!), 
                        fit: BoxFit.cover
                      )
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: _borderColor),
                      borderRadius: BorderRadius.circular(5),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/image-icon.png'),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.text_snippet_rounded),
                  labelText: tr("detail:"),
                  labelStyle: TextStyle(color: _fontColor)
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
