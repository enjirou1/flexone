import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:flexone/screens/class/description_screen.dart';
import 'package:flexone/screens/class/syllabus_screen.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditClassScreen extends StatefulWidget {
  Class classModel;

  EditClassScreen({ Key? key, required this.classModel }) : super(key: key);

  @override
  State<EditClassScreen> createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _proofDetailController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  final TextEditingController _estimatedTimeController = TextEditingController();

  InputValidation _nameValidation = InputValidation(isValid: true, message: '');

  List<Subject> _subjects = [];
  List<Grade> _grades = [];
  int _selectedSubject = 0, _selectedGrade = 0;
  String _description = "";
  String? _image = "";
  XFile? _file;
  String? _proofImage = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.classModel.name;
    _priceController.text = widget.classModel.price.toString();
    _discountPriceController.text = widget.classModel.discountPrice.toString();
    _estimatedTimeController.text = widget.classModel.estimatedTime.toString();
    _proofDetailController.text = widget.classModel.proof!.detail;
    _image = widget.classModel.photo;
    _description = widget.classModel.description!;
    _selectedSubject = widget.classModel.subject!.id;
    _selectedGrade = widget.classModel.grade!.id;
    _description = jsonDecode(widget.classModel.description!);
    _proofImage = widget.classModel.proof!.image;
  }

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final Color _fontColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;
    final Color _containerColor = _preferencesProvider.isDarkTheme ? Colors.grey[800]! : Colors.white;

    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () => Get.back(result: null),
            icon: const FaIcon(FontAwesomeIcons.xmark)
          )
        ),
        title: const Text('edit_class').tr(),
        actions: [
          IconButton(
            onPressed: () async {
              bool isValid = true;

              if (_nameController.text.isEmpty) {
                isValid = false;
                _nameValidation = InputValidation(isValid: false, message: tr('error.name.empty'));
              } else {
                _nameValidation = InputValidation(isValid: true, message: '');
              }

              if (_selectedGrade == 0 || _selectedSubject == 0) {
                isValid = false;
                Get.snackbar(tr('failed'), tr('error.grade_subject.empty'),
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                  animationDuration: const Duration(milliseconds: 300),
                  duration: const Duration(seconds: 2)
                );
              }

              if (isValid) {
                await Class.updateClass(
                  widget.classModel.id, 
                  _selectedSubject, 
                  _selectedGrade, 
                  _nameController.text, 
                  _image!, 
                  _description, 
                  _priceController.text, 
                  _discountPriceController.text, 
                  _estimatedTimeController.text
                );
                Get.back(result: true);
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
      body: SingleChildScrollView(
        child: Padding(
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
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
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
                                    _image = await UploadService.uploadImage(_file!, "class", _provider.user!.userId!);
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
                                    _image = await UploadService.uploadImage(_file!, "class", _provider.user!.userId!);
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
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(_image!), 
                                fit: BoxFit.contain
                              )
                            ),
                          )
                        : Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/photo-icon.png'),
                                fit: BoxFit.contain
                              )
                            ),
                          ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ActionChip(
                      label: Text('grade_and_subject', style: poppinsTheme.bodyText2).tr(),
                      padding: const EdgeInsets.all(10),
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
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: tr("name"),
                        labelStyle: TextStyle(color: _fontColor),
                        errorText: _nameValidation.isValid ? null : _nameValidation.message,
                        isDense: true
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: "Rp",
                              prefixStyle: TextStyle(color: _fontColor),
                              labelText: tr("price"),
                              labelStyle: TextStyle(color: _fontColor),
                              isDense: true
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _discountPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: "Rp",
                              prefixStyle: TextStyle(color: _fontColor),
                              labelText: tr("discount_price"),
                              labelStyle: TextStyle(color: _fontColor),
                              isDense: true
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final result = await Get.to(DescriptionScreen(description: _description, expertId: _provider.user!.expertId!));
                              if (result != null) {
                                _description = result;
                                setState(() {});
                              }
                            },
                            child: const Text('description').tr(),
                          )
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextField(
                              controller: _estimatedTimeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixText: tr("hours"),
                                suffixStyle: TextStyle(color: _fontColor),
                                labelText: tr("estimated_time"),
                                labelStyle: TextStyle(color: _fontColor),
                                isDense: true
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("certificate", style: poppinsTheme.headline6).tr()
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Get.to(PreviewImage(image: widget.classModel.proof!.image)),
                        child: (_proofImage != "")
                          ? Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: (MediaQuery.of(context).size.width - 50) * 9 / 16,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(_proofImage!), 
                                  fit: BoxFit.cover
                                )
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: (MediaQuery.of(context).size.width - 50) * 9 / 16,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/photo-icon.png'),
                                  fit: BoxFit.contain
                                )
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _proofDetailController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: tr("detail"),
                        labelStyle: TextStyle(color: _fontColor),
                        isDense: true
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
            }
          )
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Get.to(SyllabusScreen(classId: widget.classModel.id));
        },
        icon: const FaIcon(FontAwesomeIcons.list, size: 20),
        label: Text('syllabus', style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold)).tr(),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}