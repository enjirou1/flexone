import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/expert_result.dart';
import 'package:flexone/data/providers/certificates.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flexone/widgets/card/card_with_header.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flexone/widgets/dialog/single_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ExpertProfileScreen extends StatefulWidget {
  const ExpertProfileScreen({Key? key}) : super(key: key);

  @override
  State<ExpertProfileScreen> createState() => _ExpertProfileScreenState();
}

class _ExpertProfileScreenState extends State<ExpertProfileScreen> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  InputValidation _accountNameValidation = InputValidation(isValid: true, message: '');
  InputValidation _accountNumberValidation = InputValidation(isValid: true, message: '');
  InputValidation _educationValidation = InputValidation(isValid: true, message: '');
  InputValidation _jobValidation = InputValidation(isValid: true, message: '');
  InputValidation _identityCardValidation = InputValidation(isValid: true, message: '');

  Expert? _expert;
  String _bank = "BRI";
  int _saldo = 0;
  String? _image = "";
  XFile? _file;
  List<Skill> _skills = [];

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final _certificateProvider = Provider.of<CertificateProvider>(context, listen: true);
    final Color _fontColor = _preferencesProvider.isDarkTheme ? Colors.white : secondaryColor;
    final Color _borderColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('expert_account').tr(),
      ),
      body: FutureBuilder(
          future: Future.wait([
            Expert.getExpertByID(_provider.user!.expertId!),
            Expert.getSkills(_provider.user!.expertId!)
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              if (_expert == null) {
                Future.delayed(Duration.zero, () {
                  _expert = snapshot.data![0];
                  _image = _expert!.identityPhoto ?? "";
                  _bank = _expert!.bank!;
                  _saldo = _expert!.balance!;
                  _accountNameController.text = _expert!.accountHolderName!;
                  _accountNumberController.text = _expert!.accountnumber!;
                  _educationController.text = _expert!.education!;
                  _jobController.text = _expert!.job!;
                  setState(() {});
                });
              }

              if (_skills.isEmpty) {
                Future.delayed(Duration.zero, () {
                  _skills = snapshot.data![1];
                  setState(() {});
                });
              }

              if (_certificateProvider.certificates.isEmpty) {
                Future.delayed(Duration.zero, () {
                  _certificateProvider.setCertificates(snapshot.data![0].certificates);
                });
              }

              return SingleChildScrollView(
                child: Padding(
                  padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    children: [
                      CardWithHeader(
                        headerText: 'saldo',
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(_saldo),
                              style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton.icon(
                              icon: const FaIcon(FontAwesomeIcons.moneyBillTransfer),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  InputValidation _nominalValidation = InputValidation(isValid: true, message: '');

                                  return StatefulBuilder(
                                    builder: (context, setState) => SingleInputDialog(
                                      title: tr("enter_nominal"),
                                      label: tr("nominal:"),
                                      buttonText: tr('withdraw'),
                                      controller: _nominalController,
                                      inputValidation: _nominalValidation,
                                      inputType: TextInputType.number,
                                      obsecureText: false,
                                      onPressed: () async {
                                        setState(() {
                                          int value = int.parse(_nominalController.text.isEmpty ? "0" : _nominalController.text);
                                          
                                          if (value < 10000) {
                                            _nominalValidation = InputValidation(
                                              isValid: false,
                                              message: tr('error.nominal.minimum')
                                            );
                                          } else {
                                            if (snapshot.data![0].balance! - value < 0) {
                                              _nominalValidation = InputValidation(
                                                isValid: false,
                                                message: tr('error.nominal.not_enough_saldo')
                                              );
                                            } else {
                                              _nominalValidation = InputValidation(
                                                isValid: true,
                                                message: ''
                                              );
                                            }
                                          }


                                          if (_nominalValidation.isValid) {
                                            showDialog(
                                              context: context, 
                                              builder: (context) => ConfirmationDialog(
                                                title: 'confirmation.withdraw.title', 
                                                content: 'confirmation.withdraw.content', 
                                                buttonText: 'confirmation.withdraw.button', 
                                                onCancel: () {
                                                  Navigator.pop(context);
                                                },
                                                onPressed: () {
                                                  try {
                                                    Expert.withdraw(snapshot.data![0].expertId!, _nominalController.text);

                                                    this.setState(() {
                                                      _saldo -= value;
                                                    });

                                                    Get.snackbar(
                                                      tr('success'), tr('success_detail.withdraw_saldo'),
                                                      snackPosition: SnackPosition.BOTTOM,
                                                      animationDuration: const Duration(milliseconds: 300),
                                                      backgroundColor: Colors.green,
                                                      colorText: Colors.white,
                                                      icon: const Icon(Icons.check, color: Colors.white),
                                                      duration: const Duration(seconds: 1)
                                                    );
                                                    
                                                    _nominalController.text = "";

                                                    Navigator.pop(context);
                                                  } catch (e) {
                                                    Get.snackbar('Error', e.toString(),
                                                      snackPosition: SnackPosition.BOTTOM,
                                                      animationDuration: const Duration(milliseconds: 300),
                                                      duration: const Duration(seconds: 2)
                                                    );
                                                  }
                                                  Navigator.pop(context);
                                                }
                                              )
                                            );
                                          }
                                        });
                                      }
                                    ),
                                  );
                                }
                              ),
                              label: const Text('withdraw').tr())
                          ]
                        )
                      ),
                      const SizedBox(height: 15),
                      CardWithHeader(
                        headerText: 'profile',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('personal_identity_card:').tr(),
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
                                            _image = await UploadService.uploadImage(
                                              _file!,
                                              "identity",
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

                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text("select_photo").tr(),
                                        tileColor: Colors.white,
                                        textColor: Colors.black,
                                        onTap: () async {
                                          try {
                                            _file = await UploadService.getImage(1);
                                            _image = await UploadService.uploadImage(
                                              _file!,
                                              "identity",
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

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                }
                              ),
                              child: (_image != "")
                                ? Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.width * 9 / 16,
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
                                    height: MediaQuery.of(context).size.width * 9 / 16,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: _borderColor),
                                      borderRadius: BorderRadius.circular(5),
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
                                  style: poppinsTheme.caption!.copyWith(color: Colors.red[700]),
                                ),
                              ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              items: ['BCA', 'BNI', 'BRI', 'MANDIRI', 'PERMATA'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  child: Text(value), value: value
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.account_balance_rounded),
                                labelText: tr('bank:'),
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
                                labelText: tr("account_holder_name:"),
                                labelStyle: TextStyle(color: _fontColor),
                                errorText: _accountNameValidation.isValid
                                  ? null
                                  : _accountNameValidation.message
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
                                labelText: tr("account_number:"),
                                labelStyle: TextStyle(color: _fontColor),
                                errorText: _accountNumberValidation.isValid
                                  ? null
                                  : _accountNumberValidation.message
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: _educationController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.school_rounded),
                                labelText: tr("education:"),
                                labelStyle: TextStyle(color: _fontColor),
                                errorText: _educationValidation.isValid
                                  ? null
                                  : _educationValidation.message
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: _jobController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.work_rounded),
                                labelText: tr("job:"),
                                labelStyle: TextStyle(color: _fontColor),
                                errorText: _jobValidation.isValid
                                  ? null
                                  : _jobValidation.message
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.save),
                                onPressed: () async {
                                  _accountNameValidation = InputValidation(
                                    isValid: _accountNameController.text.isNotEmpty,
                                    message: tr('error.account_name.empty')
                                  );
                                  _accountNumberValidation = InputValidation(
                                    isValid: _accountNumberController.text.isNotEmpty,
                                    message: tr('error.account_number.empty')
                                  );
                                  _educationValidation = InputValidation(
                                    isValid: _educationController.text.isNotEmpty,
                                    message: tr('error.education.empty')
                                  );
                                  _jobValidation = InputValidation(
                                    isValid: _jobController.text.isNotEmpty,
                                    message: tr('error.job.empty')
                                  );
                                  _identityCardValidation = InputValidation(
                                    isValid: _image == "" ? false : true,
                                    message: tr('error.personal_identity_card.empty')
                                  );

                                  if (_accountNameValidation.isValid &&
                                      _accountNumberValidation.isValid &&
                                      _educationValidation.isValid &&
                                      _jobValidation.isValid &&
                                      _identityCardValidation.isValid) {
                                    try {
                                      await Expert.update(
                                        _provider.user!.expertId!,
                                        _image!,
                                        _bank,
                                        _accountNameController.text,
                                        _accountNumberController.text,
                                        _educationController.text,
                                        _jobController.text
                                      );

                                      Get.snackbar(tr('success'), tr('success_detail.update_profile'),
                                        snackPosition:SnackPosition.BOTTOM,
                                        animationDuration:const Duration(milliseconds: 300),
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        icon: const Icon(Icons.check, color: Colors.white),
                                        duration: const Duration(seconds: 1)
                                      );
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
                                label: const Text('save').tr()
                              ),
                            )
                          ],
                        )
                      ),
                      const SizedBox(height: 15),
                      CardWithHeader(
                        headerText: 'skills', 
                        content: SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 10.0,
                            children: [
                              ..._skills.map<Widget>((skill) => ActionChip(
                                avatar: const FaIcon(FontAwesomeIcons.xmark, size: 14),
                                padding: const EdgeInsets.only(left: 2),
                                labelPadding: const EdgeInsets.only(right: 8),
                                elevation: 3,
                                label: Text(
                                  skill.name, 
                                  style: poppinsTheme.caption!.copyWith(fontSize: 10)
                                ),
                                onPressed: () async {
                                  try {
                                    await Expert.removeSkill(_expert!.expertId!, skill.skillId);
                                    _skills.removeWhere((item) => item.id == skill.id);
                                    setState(() {});
                                  } catch (e) {
                                    Get.snackbar('Error', e.toString(),
                                      snackPosition: SnackPosition.BOTTOM,
                                      animationDuration: const Duration(milliseconds: 300),
                                      duration: const Duration(seconds: 2)
                                    );
                                  }
                                },
                              )).toList(),
                              ActionChip(
                                avatar: const Icon(Icons.add, size: 18),
                                padding: const EdgeInsets.only(left: 2),
                                labelPadding: const EdgeInsets.only(right: 8),
                                elevation: 3,
                                label: Text(
                                  tr('add'), 
                                  style: poppinsTheme.caption!.copyWith(fontSize: 10)
                                ),
                                onPressed: () async {
                                  final results = await Get.toNamed('/add_skill');
                                  if (results != null) {
                                    Expert.addSkill(_expert!.expertId!, results).then((value) {
                                      _skills.addAll(value);
                                      setState(() {});
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ),
                      const SizedBox(height: 15),
                      CardWithHeader(
                        headerText: 'certificates', 
                        content: Column(
                          children: [
                            _certificateProvider.certificates.isNotEmpty ? 
                            CarouselSlider.builder(
                              itemCount: _certificateProvider.certificates.length, 
                              itemBuilder: (context, index, realIdx) {
                                final certificate = _certificateProvider.certificates[index];
                                return Center(
                                  child: GestureDetector(
                                    child: Image.network(certificate.photo, fit: BoxFit.cover),
                                    onTap: () => Get.to(PreviewImage(image: certificate.photo, detail: certificate.detail)),
                                  ),
                                );
                              }, 
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                              )
                            ) : Container(),
                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Get.toNamed('/certificate');
                                }, 
                                label: const Text('edit').tr()
                              ),
                            )
                          ],
                        )
                      )
                    ],
                  )
                ),
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
          }),
    );
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _educationController.dispose();
    _jobController.dispose();
    super.dispose();
  }
}
