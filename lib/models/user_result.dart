import 'dart:convert';

import 'package:http/http.dart' as http;

class UserModel {
  String? userId;
  String? expertId;
  String? email;
  String? fullname;
  String? province;
  String? city;
  String? address;
  String? phone;
  String? photo;
  String? about;
  int? point;
  String? lastLogin;
  bool? updatePoint;
  static const String _baseUrl = 'https://api.flexone.online/v1/user';

  UserModel(
      {this.userId,
      this.expertId,
      this.email,
      this.fullname,
      this.province,
      this.city,
      this.address,
      this.phone,
      this.photo,
      this.about,
      this.point,
      this.lastLogin,
      this.updatePoint});

  factory UserModel.createUser(Map<String, dynamic> object) {
    return UserModel(
        userId: object['user_id'],
        expertId: object['expert_id'],
        email: object['email'],
        fullname: object['fullname'],
        province: object['province'],
        city: object['city'],
        address: object['address'],
        phone: object['phone'],
        photo: object['photo_number'],
        about: object['about'],
        point: object['point'],
        lastLogin: object['last_login'],
        updatePoint: object['update_point']);
  }

  static Future<UserModel?> getUserByEmail(String? email) async {
    try {
      final String url = '$_baseUrl?email=$email';
      final response = await http.get(Uri.parse(url));
      final jsonObject = json.decode(response.body);
      final data = (jsonObject as Map<String, dynamic>)['data'];
      return UserModel.createUser(data);
    } catch (e) {
      print(e);
    }
    
    return null;
  }

  static Future register(
      String email, String? password, String name, String google) async {
    const String url = '$_baseUrl/register';
    final response = await http.post(Uri.parse(url), body: {
      "email": email,
      "password": password,
      "fullname": name,
      "google": google
    });

    if (google == "0") {
      if (response.statusCode != 201) {
        throw Exception(json.decode(response.body)['message']);
      }
    }
  }
}
