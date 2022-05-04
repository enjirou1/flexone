import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddAnswerScreen extends StatefulWidget {
  Question question;

  AddAnswerScreen({ Key? key, required this.question }) : super(key: key);

  @override
  State<AddAnswerScreen> createState() => _AddAnswerScreenState();
}

class _AddAnswerScreenState extends State<AddAnswerScreen> {
  final TextEditingController _controller = TextEditingController();
  InputValidation _textValidation = InputValidation(isValid: true, message: '');
  String _image = "";
  XFile? _file;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _borderColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 50, right: 10, bottom: 20),
                    width: double.infinity,
                    color: Colors.indigo[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(widget.question.text),
                        if (widget.question.photo != "") ...[
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () => Get.to(PreviewImage(image: widget.question.photo)),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 9 / 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(widget.question.photo), 
                                  fit: BoxFit.contain
                                )
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('answer', style: poppinsTheme.bodyText1).tr(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: MediaQuery.of(context).size.height - 300,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      maxLines: null,
                      expands: true,
                      cursorColor: Colors.indigo,
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        labelStyle: TextStyle(color: _borderColor),
                        errorText: _textValidation.isValid ? null : _textValidation.message
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
          if (_image != "") ...[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(PreviewImage(image: _image)),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(_image), 
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _image = "";
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: 100,
                      height: 100,
                      child: Align(
                        alignment: Alignment.topRight, 
                        child: FaIcon(FontAwesomeIcons.xmark, color: Colors.red[800], size: 20)
                      )
                    ),
                  )
                ],
              ),
            )
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => showDialog(
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
                                _file!, 
                                "answer", 
                                _provider.user!.userId!
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
                                "answer", 
                                _provider.user!.userId!
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
                icon: const Icon(Icons.add_a_photo_rounded)
              ),
              IconButton(
                onPressed: () async {
                  setState(() {
                    _textValidation = InputValidation(isValid: _controller.text.isNotEmpty, message: tr('error.text.empty'));
                  });

                  if (_controller.text.isNotEmpty) {
                    final result = await Question.answer(widget.question.questionId, _provider.user!.userId!, _controller.text, _image);
                    Get.back(result: result);
                  }
                }, 
                icon: const Icon(Icons.send)
              )
            ],
          )
        ]
      ),
    );
  }
}