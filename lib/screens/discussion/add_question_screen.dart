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

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({ Key? key }) : super(key: key);

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  InputValidation _pointValidation = InputValidation(isValid: true, message: '');
  InputValidation _textValidation = InputValidation(isValid: true, message: '');
  List<Subject> _subjects = [];
  List<Grade> _grades = [];
  int _selectedSubject = 0, _selectedGrade = 0;
  String? _image = "";
  XFile? _file;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _containerColor = _preferencesProvider.isDarkTheme ? Colors.grey[800]! : Colors.white;
    final Color _borderColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () => Get.back(result: null),
            icon: const FaIcon(FontAwesomeIcons.xmark)
          )
        ),
        title: const Text('ask_a_question').tr(),
        actions: [
          IconButton(
            onPressed: () async {
              bool isValid = true;

              if (_pointController.text.isEmpty) {
                isValid = false;
                _pointValidation = InputValidation(isValid: false, message: tr('error.point.empty'));
              } else {
                _pointValidation = InputValidation(isValid: true, message: '');
              }

              if (_controller.text.isEmpty) {
                isValid = false;
                _textValidation = InputValidation(isValid: false, message: tr('error.text.empty'));
              } else {
                 _textValidation = InputValidation(isValid: true, message: '');
              }

              if (_pointController.text.isNotEmpty) {
                if (_provider.user!.point! - int.parse(_pointController.text) < 0) {
                  isValid = false;
                  _pointValidation = InputValidation(isValid: false, message: tr('error.point.not_enough'));
                } else if (_pointController.text == "0") {
                  isValid = false;
                  _pointValidation = InputValidation(isValid: false, message: tr('error.point.empty'));
                } else {
                  _pointValidation = InputValidation(isValid: true, message: '');
                }
              }

              if (_selectedGrade == 0 || _selectedSubject == 0) {
                isValid = false;
                Get.snackbar('Failed', tr('error.grade_subject.empty'),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 300),
                  duration: const Duration(seconds: 2)
                );
              }

              if (isValid) {
                final result = await Question.createNewQuestion(
                  _provider.user!.userId!, 
                  _selectedSubject.toString(), 
                  _selectedGrade.toString(), 
                  _controller.text, 
                  _pointController.text, 
                  _image ?? ""
                );

                _provider.updatePoint(_provider.user!.point! - int.parse(_pointController.text));

                Get.back(result: result);
              }
              
              setState(() {});
            },
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            )
          )
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: Future.wait([
            Subject.getSubjects(),
            Grade.getGrades()
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (_subjects.isEmpty) {
              Future.delayed(Duration.zero, () {
                setState(() {
                  _subjects = snapshot.data![0];
                });
              });
            }

            if (_grades.isEmpty) {
              Future.delayed(Duration.zero, () {
                setState(() {
                  _grades = snapshot.data![1];
                });
              });
            }

            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ActionChip(
                        label: Text('grade_and_subject', style: poppinsTheme.bodyText2).tr(),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)
                              )
                            ),
                            builder: (BuildContext context) {
                              int selectedSubject = 0, selectedGrade = 0;

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)
                                      ),
                                      color: _containerColor
                                    ),
                                    height: MediaQuery.of(context).size.height * 0.8,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("subject", style: poppinsTheme.headline6).tr(),
                                            Wrap(
                                              spacing: 10.0,
                                              children: _subjects.map<Widget>((subject) => ChoiceChip(
                                                elevation: 3,
                                                label: Text(
                                                  subject.name, 
                                                  style: poppinsTheme.caption!.copyWith(fontSize: 10)
                                                ),
                                                selectedColor: Colors.indigo[300],
                                                selected: (_selectedSubject == 0) ? selectedSubject == subject.id : _selectedSubject == subject.id,
                                                onSelected: (value) {
                                                  setState(() {
                                                    selectedSubject = subject.id;
                                                    this.setState(() {
                                                      _selectedSubject = subject.id;
                                                    });
                                                  });
                                                },
                                              )).toList()
                                            ),
                                            const SizedBox(height: 20),
                                            Text("grade", style: poppinsTheme.headline6).tr(),
                                            Wrap(
                                              spacing: 10.0,
                                              children: _grades.map<Widget>((grade) => ChoiceChip(
                                                elevation: 3,
                                                label: Text(
                                                  grade.name, 
                                                  style: poppinsTheme.caption!.copyWith(fontSize: 10)
                                                ),
                                                selectedColor: Colors.indigo[300],
                                                selected: (_selectedGrade == 0) ? selectedGrade == grade.id : _selectedGrade == grade.id,
                                                onSelected: (value) {
                                                  setState(() {
                                                    selectedGrade = grade.id;
                                                    this.setState(() {
                                                      _selectedGrade = grade.id;
                                                    });
                                                  });
                                                },
                                              )).toList()
                                            ),
                                          ],
                                        )
                                      ),
                                    )
                                  );
                                }
                              );
                            }
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextField(
                            controller: _pointController,
                            keyboardType: TextInputType.number,
                            style: poppinsTheme.caption!.copyWith(fontSize: 12),
                            cursorColor: Colors.indigo,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: _borderColor)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: _borderColor)
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              labelText: tr("point:"),
                              labelStyle: TextStyle(color: _borderColor),
                              errorText: _pointValidation.isValid ? null : _pointValidation.message
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 15,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
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
                        labelStyle: TextStyle(color: _borderColor),
                        errorText: _textValidation.isValid ? null : _textValidation.message
                      ),
                    ),
                  ),
                  if (_image != "") ...[
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(PreviewImage(image: _image!)),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(_image!), 
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
                    )
                  ],
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
                                    "question", 
                                    _provider.user!.userId!
                                  );
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
                                    _file!, 
                                    "question", 
                                    _provider.user!.userId!
                                  );
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
                    icon: const Icon(Icons.add_a_photo_rounded)
                  )
                ]
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          }
        ),
      )
    );
  }
}