import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/rajaongkir_result.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  InputValidation _nameValidation = InputValidation(isValid: true, message: '');
  List<Province> _provinces = [];
  List<String> _provincesStr = [];
  List<City> _cities = [];
  List<String> _citiesStr = [];
  String _selectedProvince = "";
  String _selectedCity = "";
  String? _imageUrl = null;
  String? _imagePath = null;
  XFile? _file;

  @override
  void initState() {
    RajaOngkirModel.getProvinces().then((value) {
      _provinces = value!;
      value.forEach((province) {
        _provincesStr.add(province.provinceName!);
      });
      setState(() {});
    });
    RajaOngkirModel.getCities().then((value) {
      _cities = value!;
      value.forEach((city) {
        _citiesStr.add(city.cityName!);
      });
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    final _user = FirebaseAuth.instance.currentUser;
    final _provider = Provider.of<UserProvider>(context, listen: true);
    final Color _fontColor =
        _preferencesProvider.isDarkTheme ? Colors.white : secondaryColor;

    if (_imageUrl == null) {
      _imagePath = _provider.user!.photo ?? _user!.photoURL;
    } else if (_imageUrl == "no photo") {
      _imagePath = "";
    } else {
      _imagePath = _imageUrl;
    }

    _selectedProvince = _provider.user!.province ?? "";
    _selectedCity = _provider.user!.city ?? "";
    _nameController.text =
        (!_nameValidation.isValid) ? "" : _provider.user!.fullname!;
    _aboutController.text = _provider.user?.about ?? "";
    _phoneController.text = _provider.user?.phone ?? "";
    _addressController.text = _provider.user?.address ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("edit_profile").tr(),
        actions: [
          IconButton(
              onPressed: () async {
                if (_nameController.text.isEmpty) {
                  _nameValidation = InputValidation(
                      isValid: false, message: tr('error.name.empty'));
                } else {
                  _nameValidation = InputValidation(
                      isValid: true, message: tr('error.name.empty'));

                  await UserModel.updateUser(
                      _provider.user!.userId!,
                      _user!.email!,
                      _nameController.text,
                      _selectedProvince,
                      _selectedCity,
                      _addressController.text,
                      _phoneController.text,
                      _imagePath,
                      _aboutController.text);

                  await UserModel.getUserByEmail(_user.email).then((value) {
                    _provider.setUser(value!);
                  });

                  Get.snackbar(
                      tr('success'), tr('success_detail.update_profile'),
                      snackPosition: SnackPosition.BOTTOM,
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      icon: const Icon(Icons.check, color: Colors.white),
                      duration: const Duration(seconds: 1));
                }

                setState(() {});
              },
              icon: const Icon(
                Icons.save,
                color: Color(0XFFD6D6D6),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              Stack(
                children: [
                  (_imagePath != null && _imagePath != "")
                      ? Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                              image: DecorationImage(
                                  image: NetworkImage(_imagePath!),
                                  fit: BoxFit.cover)),
                        )
                      : Container(
                          width: 150,
                          height: 150,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/profile-icon.png'),
                                  fit: BoxFit.cover)),
                        ),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: IconButton(
                        alignment: const Alignment(0.8, 1.2),
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
                                        _imageUrl =
                                            await UploadService.uploadImage(
                                                _file!, "user", _user!.uid);
                                      } on FirebaseException catch (e) {
                                        Get.snackbar('Error', e.message!,
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                            duration:
                                                const Duration(seconds: 2));
                                      } catch (e) {
                                        Get.snackbar('Error', e.toString(),
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                            duration:
                                                const Duration(seconds: 2));
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
                                        _imageUrl =
                                            await UploadService.uploadImage(
                                                _file!, "user", _user!.uid);
                                      } on FirebaseException catch (e) {
                                        Get.snackbar('Error', e.message!,
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                            duration:
                                                const Duration(seconds: 2));
                                      } catch (e) {
                                        Get.snackbar('Error', e.toString(),
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                            duration:
                                                const Duration(seconds: 2));
                                      }
                                      setState(() {});

                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("delete_photo").tr(),
                                    tileColor: Colors.white,
                                    textColor: Colors.black,
                                    onTap: () {
                                      _file = null;
                                      _imageUrl = "no photo";
                                      setState(() {});

                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            }),
                        icon: Icon(
                          Icons.add_a_photo_rounded,
                          color: primaryColor,
                          size: 30,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: tr("fullname:"),
                    labelStyle: TextStyle(color: _fontColor),
                    errorText: _nameValidation.isValid
                        ? null
                        : _nameValidation.message),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _aboutController,
                minLines: 2,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.note_rounded),
                    labelText: tr("about_me:"),
                    labelStyle: TextStyle(color: _fontColor)),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelText: tr("phone_number:"),
                    labelStyle: TextStyle(color: _fontColor)),
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownSearch<String>(
                mode: Mode.DIALOG,
                showSearchBox: true,
                showClearButton: true,
                showSelectedItems: true,
                items: _provincesStr,
                selectedItem: _selectedProvince,
                label: tr("province:"),
                dropdownSearchDecoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                  prefixIcon: const Icon(Icons.location_city_rounded),
                  labelStyle: TextStyle(color: _fontColor),
                ),
                popupBackgroundColor: _preferencesProvider.isDarkTheme
                    ? const Color(0xFF212121)
                    : Colors.white,
                onChanged: (value) {
                  _citiesStr = [];
                  if (value != null) {
                    for (var city in _cities) {
                      if (city.provinceName == value) {
                        _citiesStr.add(city.cityName!);
                      }
                    }
                  } else {
                    for (var city in _cities) {
                      _citiesStr.add(city.cityName!);
                    }
                  }
                  _selectedProvince = value ?? "";
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownSearch<String>(
                mode: Mode.DIALOG,
                showSearchBox: true,
                showClearButton: true,
                showSelectedItems: true,
                items: _citiesStr,
                selectedItem: _selectedCity,
                label: tr("city:"),
                dropdownSearchDecoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                  prefixIcon: const Icon(Icons.location_city_rounded),
                  labelStyle: TextStyle(color: _fontColor),
                ),
                popupBackgroundColor: _preferencesProvider.isDarkTheme
                    ? const Color(0xFF212121)
                    : Colors.white,
                onChanged: (value) {
                  _selectedCity = value!;
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.home),
                    labelText: tr("address:"),
                    labelStyle: TextStyle(color: _fontColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
