import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/consultation_result.dart';
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

class EditConsultationScreen extends StatefulWidget {
  Consultation consultation;

  EditConsultationScreen({ Key? key, required this.consultation }) : super(key: key);

  @override
  State<EditConsultationScreen> createState() => _EditConsultationScreenState();
}

class _EditConsultationScreenState extends State<EditConsultationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _proofDetailController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();

  InputValidation _nameValidation = InputValidation(isValid: true, message: '');
  InputValidation _topicValidation = InputValidation(isValid: true, message: '');
  InputValidation _proofDetailValidation = InputValidation(isValid: true, message: '');
  InputValidation _priceValidation = InputValidation(isValid: true, message: '');

  String? _image = "";
  XFile? _file;
  String? _proofImage = "";
  XFile? _proofFile;

  @override
  void initState() {
    _nameController.text = widget.consultation.name;
    _descriptionController.text = widget.consultation.description;
    _proofDetailController.text = widget.consultation.proof!.detail;
    _topicController.text = widget.consultation.topic;
    _linkController.text = widget.consultation.link;
    _priceController.text = widget.consultation.price.toString();
    _discountPriceController.text = widget.consultation.discountPrice.toString();
    _image = widget.consultation.photo;
    _proofImage = widget.consultation.proof!.image;
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
        title: const Text('edit_consultation').tr(),
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

              if (_topicController.text.isEmpty) {
                isValid = false;
                _topicValidation = InputValidation(isValid: false, message: tr('error.topic.empty'));
              } else {
                _topicValidation = InputValidation(isValid: true, message: '');
              }

              if (_proofDetailController.text.isEmpty) {
                isValid = false;
                _proofDetailValidation = InputValidation(isValid: false, message: tr('error.detail.empty'));
              } else {
                _proofDetailValidation = InputValidation(isValid: true, message: '');
              }

              if (_priceController.text.isEmpty) {
                isValid = false;
                _priceValidation = InputValidation(isValid: false, message: tr('error.price.empty'));
              } else {
                _priceValidation = InputValidation(isValid: true, message: '');
              }

              if (_proofImage == "") {
                isValid = false;
                Get.snackbar(tr('failed'), tr('error.certificate.empty'),
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                  animationDuration: const Duration(milliseconds: 300),
                  duration: const Duration(seconds: 2)
                );
              }

              if (isValid) {
                await Consultation.updateConsultation(
                  widget.consultation.id,
                  _image!, 
                  _descriptionController.text, 
                  _linkController.text, 
                  _priceController.text, 
                  _discountPriceController.text
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
                              _image = await UploadService.uploadImage(_file!, "consultation", _provider.user!.userId!);
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
                              _image = await UploadService.uploadImage(_file!, "consultation", _provider.user!.userId!);
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
                      width: 200,
                      height: 200,
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
              TextField(
                controller: _nameController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: tr("name:"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _nameValidation.isValid ? null : _nameValidation.message,
                  isDense: true
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _topicController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: tr("topic:"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _topicValidation.isValid ? null : _topicValidation.message,
                  isDense: true
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _linkController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: "Link:",
                  labelStyle: TextStyle(color: _fontColor),
                  isDense: true
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
                        labelText: tr("price:"),
                        labelStyle: TextStyle(color: _fontColor),
                        errorText: _priceValidation.isValid ? null : _priceValidation.message,
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
                        labelText: tr("discount_price:"),
                        labelStyle: TextStyle(color: _fontColor),
                        isDense: true
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
                  onTap: () => Get.to(PreviewImage(image: widget.consultation.proof!.image)),
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
                  labelText: tr("detail:"),
                  labelStyle: TextStyle(color: _fontColor),
                  errorText: _proofDetailValidation.isValid ? null : _proofDetailValidation.message,
                  isDense: true
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}