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
  String? createdAt;
  int? followers = 0;
  int? following = 0;
  int? questions = 0;
  int? answers = 0;
  int? rooms = 0;
  int? consultations = 0;
  int? classes = 0;
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
      this.updatePoint,
      this.createdAt,
      this.followers,
      this.following,
      this.questions,
      this.answers,
      this.rooms,
      this.consultations,
      this.classes});

  factory UserModel.createUser(Map<String, dynamic> object) {
    return UserModel(
        userId: object['user_id'],
        expertId: object['expert_id'],
        email: object['email'],
        fullname: object['fullname'],
        province: object['province'],
        city: object['city'],
        address: object['address'],
        phone: object['phone_number'],
        photo: object['photo'],
        about: object['about'],
        point: object['point'],
        lastLogin: object['last_login'],
        updatePoint: object['update_point'],
        createdAt: object['created_at'],
        followers: object['followers'],
        following: object['following'],
        questions: object['questions'],
        answers: object['answers'],
        rooms: object['rooms'],
        consultations: object['consultations'],
        classes: object['classes']);
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

  static Future<UserModel?> getUserByID(String? id) async {
    try {
      final String url = '$_baseUrl/$id';
      final response = await http.get(Uri.parse(url));
      final jsonObject = json.decode(response.body);
      final data = (jsonObject as Map<String, dynamic>)['data'];
      return UserModel.createUser(data);
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<UserModel?> getDetail(String id) async {
    try {
      final String url = '$_baseUrl/detail?id=$id';
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

  static Future updateUser(
      String id,
      String email,
      String fullname,
      String? province,
      String? city,
      String? address,
      String? phone,
      String? photo,
      String? about) async {
    final String url = '$_baseUrl/$id';
    final response = await http.put(Uri.parse(url), body: {
      "email": email,
      "fullname": fullname,
      "province": province,
      "city": city,
      "address": address,
      "phone_number": phone,
      "photo": photo,
      "about": about
    });

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future<List<ActivityLog>> getLogs(String id) async {
    final url = '$_baseUrl/$id/log/all';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonObject = json.decode(response.body);
      List<dynamic> data = (jsonObject as Map<String, dynamic>)['data'];
      List<ActivityLog> logs = [];
      for (var log in data) {
        logs.add(ActivityLog.createActivityLog(log));
      }
      return logs;
    } else {
      throw Exception(response.statusCode);
    }
  }
}

class ActivityLog {
  String? id;
  String? en;

  ActivityLog({this.id, this.en});

  factory ActivityLog.createActivityLog(Map<String, dynamic> object) {
    return ActivityLog(id: object['id'], en: object['en']);
  }
}
