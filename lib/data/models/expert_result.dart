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
            .map((certificate) => Certificate.createCertificate(object))
            .toList());
  }

  static Future<Expert?> getExpertByID(String id) async {
    final url = '$_baseUrl/$id';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];

    if (response.statusCode != 200) return null;

    return Expert.createExpert(data);
  }
}

class Certificate {
  String? certificateId;
  String? photo;

  Certificate({this.certificateId, this.photo});

  factory Certificate.createCertificate(Map<String, dynamic> object) {
    return Certificate(
        certificateId: object['certificate_id'], photo: object['photo']);
  }
}
