import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/screens/class/editor_screen.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flexone/widgets/dialog/single_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyllabusScreen extends StatefulWidget {
  String classId;

  SyllabusScreen({ Key? key, required this.classId }) : super(key: key);

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  final TextEditingController _controller = TextEditingController();
  Class? classModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('syllabus').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<Class>(
          future: Class.getClass(widget.classId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (classModel == null) {
                Future.delayed(Duration.zero, () {
                  classModel = snapshot.data!;
                  setState(() {});
                });
              }
            }

            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.sections!.map((section) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(section.name, style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold))),
                          IconButton(
                            onPressed: () async {
                              final result = await Get.to(EditorScreen(classId: classModel!.id, name: "", sectionId: section.id, content: ""));
                              if (result != null) {
                                classModel = null;
                                setState(() {});
                              }
                            }, 
                            icon: const Icon(Icons.add_circle)
                          ),
                          IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  InputValidation _validation = InputValidation(isValid: true, message: '');
                                  _controller.text = section.name;

                                  return StatefulBuilder(
                                    builder: (context, setState) => SingleInputDialog(
                                      title: tr('edit_section'), 
                                      label: tr('name'), 
                                      buttonText: tr("edit"), 
                                      controller: _controller, 
                                      inputValidation: _validation, 
                                      inputType: TextInputType.text, 
                                      obsecureText: false, 
                                      onPressed: () async {
                                        setState(() {
                                          _validation = InputValidation(isValid: _controller.text.isNotEmpty, message: tr('error.name.empty'));
                                        });

                                        if (_controller.text.isNotEmpty) {
                                          await Class.updateSection(section.id, _controller.text);
                                          Navigator.pop(context);
                                          classModel = null;
                                          this.setState(() {});
                                        }
                                      }
                                    )
                                  );
                                }
                              );
                            }, 
                            icon: const Icon(Icons.edit)
                          ),
                          IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context, 
                                builder: (context) => ConfirmationDialog(
                                  title: 'confirmation.delete_section.title',
                                  buttonText: 'delete', 
                                  onCancel: () {
                                    Navigator.pop(context);
                                  }, 
                                  onPressed: () async {
                                    await Class.deleteSection(section.id);
                                    Navigator.pop(context);
                                    classModel = null;
                                    setState(() {});
                                  }
                                )
                              );
                            }, 
                            icon: const Icon(Icons.delete)
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: section.modules!.map((module) {
                          return ListTile(
                            title: Text(module.name, style: poppinsTheme.caption),
                            trailing: IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context, 
                                  builder: (context) => ConfirmationDialog(
                                    title: 'confirmation.delete_module.title',
                                    buttonText: 'delete', 
                                    onCancel: () {
                                      Navigator.pop(context);
                                    }, 
                                    onPressed: () async {
                                      await Class.deleteModule(module.id);
                                      Navigator.pop(context);
                                      classModel = null;
                                      setState(() {});
                                    }
                                  )
                                );
                              }, 
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20)
                            ),
                            dense: true,
                            onTap: () async {
                              final result = await Get.to(EditorScreen(moduleId: module.id, name: module.name, content: jsonDecode(module.content)));
                              if (result != null) {
                                classModel = null;
                                setState(() {});
                              }
                            },
                          );
                        }).toList(),
                      )
                    ],
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context, 
            builder: (BuildContext context) {
              InputValidation _validation = InputValidation(isValid: true, message: '');

              return StatefulBuilder(
                builder: (context, setState) => SingleInputDialog(
                  title: tr('new_section'), 
                  label: tr('name'), 
                  buttonText: tr("add"), 
                  controller: _controller, 
                  inputValidation: _validation, 
                  inputType: TextInputType.text, 
                  obsecureText: false, 
                  onPressed: () async {
                    setState(() {
                      _validation = InputValidation(isValid: _controller.text.isNotEmpty, message: tr('error.name.empty'));
                    });

                    if (_controller.text.isNotEmpty) {
                      await Class.addSection(widget.classId, _controller.text);
                      Navigator.pop(context);
                      classModel = null;
                      this.setState(() {});
                    }
                  }
                )
              );
            }
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}