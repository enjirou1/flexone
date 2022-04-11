import 'dart:convert';

import 'package:http/http.dart' as http;

class Expert {
  String? expertId;
  String? userId;
  String? identityPhoto;
  String? bank;
  String? accountHolderName;
  String? accountnumber;
  String? education;
  String? job;
  int? balance;
  int? isBanned;
  String? createdAt;
  List<Certificate>? certificates;
  static const String _baseUrl = 'https://api.flexone.online/v1/expert';

  Expert(
      {this.expertId,
      this.userId,
      this.identityPhoto,
      this.bank,
      this.accountHolderName,
      this.accountnumber,
      this.education,
      this.job,
      this.balance,
      this.isBanned,
      this.createdAt,
      this.certificates});

  factory Expert.createExpert(Map<String, dynamic> object) {
    return Expert(
        expertId: object['expert_id'],
        userId: object['user_id'],
        identityPhoto: object['identity_photo'],
        bank: object['bank'],
        accountHolderName: object['account_holder_name'],
        accountnumber: object['account_number'],
        education: object['education'],
        job: object['job'],
        balance: object['balance'],
        isBanned: object['is_banned'],
        createdAt: object['created_at'],
        certificates: List<Map<String, dynamic>>.from(object['certificates'] as List)
          .map((certificate) => Certificate.createCertificate(certificate)).toList());
  }

  static Future<Expert?> getExpertByID(String id) async {
    try {
      final url = '$_baseUrl/$id';
      final response = await http.get(Uri.parse(url));
      final jsonObject = json.decode(response.body);
      final data = (jsonObject as Map<String, dynamic>)['data'];
      return Expert.createExpert(data);
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future createNew(
      String userId,
      String identity,
      String bank,
      String accountName,
      String accountNumber,
      String education,
      String job) async {
    const url = '$_baseUrl/new';
    final response = await http.post(Uri.parse(url), body: {
      "user_id": userId,
      "identity_photo": identity,
      "bank": bank,
      "account_holder_name": accountName,
      "account_number": accountNumber,
      "education": education,
      "job": job
    });

    if (response.statusCode != 201) {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future update(
      String expertId,
      String identity,
      String bank,
      String accountName,
      String accountNumber,
      String education,
      String job) async {
    final url = '$_baseUrl/$expertId';
    final response = await http.put(Uri.parse(url), body: {
      "identity_photo": identity,
      "bank": bank,
      "account_holder_name": accountName,
      "account_number": accountNumber,
      "education": education,
      "job": job
    });

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future withdraw(String expertId, String nominal) async {
    final url = '$_baseUrl/$expertId/withdraw';
    final response = await http.post(Uri.parse(url), body: {
      "nominal": nominal
    });

    if (response.statusCode != 201) {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future<List<Skill>> getSkills(String expertId) async {
    final url = '$_baseUrl/$expertId/skill/all';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Skill>((skill) => Skill.createSkill(skill)).toList();
  }

  static Future removeSkill(String expertId, int skillId) async {
    final url = '$_baseUrl/$expertId/skill/$skillId';
    final response = await http.delete(Uri.parse(url));
    
    if (response.statusCode != 200) throw Exception(json.decode(response.body)['message']);
  }

  static Future<List<Skill>> addSkill(String expertId, List<int> skills) async {
    List<Skill> results = [];

    for (var skill in skills) {
      final url = '$_baseUrl/$expertId/skill/$skill';
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 201) {
        final jsonObject = json.decode(response.body)['data'];
        results.add(Skill.createSkill(jsonObject));
      }
    }

    return results;
  }

  static Future<List<Certificate>> getCertificates(String expertId) async {
    final url = '$_baseUrl/$expertId/certificate/all';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Certificate>((certificate) => Certificate.createCertificate(certificate)).toList();
  }

  static Future<Certificate> addCertificate(String expertId, String photo, String? detail) async {
    final url = '$_baseUrl/$expertId/certificate/new';
    final response = await http.post(Uri.parse(url), body: {
      "photo": photo,
      "detail": detail
    });
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Certificate.createCertificate(data);
  }

  static Future deleteCertificate(String expertId, String certificateId) async {
    final url = '$_baseUrl/$expertId/certificate/$certificateId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) throw Exception(json.decode(response.body)['message']);
  }
}

class Skill {
  late int id;
  late int skillId;
  late String name;

  Skill({required this.id, required this.skillId, required this.name});

  factory Skill.createSkill(Map<String, dynamic> object) {
    return Skill(
      id: object['id'],
      skillId: object['skill']['id'],
      name: object['skill']['name']
    );
  }
}

class Certificate {
  late String certificateId;
  late String photo;
  late String detail;

  Certificate({required this.certificateId, required this.photo, required this.detail});

  factory Certificate.createCertificate(Map<String, dynamic> object) {
    return Certificate(
      certificateId: object['certificate_id'],
      photo: object['photo'],
      detail: object['detail']
    );
  }
}
