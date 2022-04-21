import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/models/room_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditRoomScreen extends StatefulWidget {
  Room room;

  EditRoomScreen({ Key? key, required this.room }) : super(key: key);

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _slotController = TextEditingController();
  InputValidation _nameValidation = InputValidation(isValid: true, message: '');
  InputValidation _slotValidation = InputValidation(isValid: true, message: '');
  String? _image = "";
  XFile? _file;

  @override
  void initState() {
    _nameController.text = widget.room.name;
    _descriptionController.text = widget.room.description;
    _slotController.text = widget.room.maxSlot.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final Color _fontColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () => Get.back(result: false),
            icon: const FaIcon(FontAwesomeIcons.xmark)
          )
        ),
        title: const Text('edit_room').tr(),
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

              if (_slotController.text.isEmpty) {
                isValid = false;
                _slotValidation = InputValidation(isValid: false, message: tr('error.slot.empty'));
              } else {
                if (int.parse(_slotController.text) < 3) {
                  isValid = false;
                  _slotValidation = InputValidation(isValid: false, message: tr('error.slot.minimum'));
                } else {
                  _slotValidation = InputValidation(isValid: true, message: '');
                }
              }

              if (isValid) {
                await Room.updateRoom(widget.room.id, _provider.user!.userId!, _nameController.text, _image!, _descriptionController.text, _passwordController.text, _slotController.text);
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
          child: Column(
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
                              _image = await UploadService.uploadImage(_file!, "room", _provider.user!.userId!);
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
                              _image = await UploadService.uploadImage(_file!, "room", _provider.user!.userId!);
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
                  }
                ),
                child: (_image != "")
                  ? Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(_image!), 
                          fit: BoxFit.cover
                        )
                      ),
                    )
                  : Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/room-icon.png'),
                          fit: BoxFit.contain
                        )
                      ),
                    ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: tr("name:"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _nameValidation.isValid ? null : _nameValidation.message
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                cursorColor: Colors.indigo,
                decoration: InputDecoration(
                  labelText: tr("description:"),
                  labelStyle: TextStyle(color: _fontColor),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: tr("password:"),
                  labelStyle: TextStyle(color: _fontColor),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _slotController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: tr("slot:"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _slotValidation.isValid ? null : _slotValidation.message
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          )
        ),
      )
    );
  }
}