import 'dart:convert';
import 'package:http/http.dart' as http;

class ConsultationRequest {
  late int id;
  int? transactionConsultationId;
  late SimpleUser user;
  late Consultation consultation;
  late String appointmentDate;
  late String explanation;
  late bool isDone;
  late int rating;
  String? review;
  late String status;
  String? reason;
  late String requestedAt;
  String? finishedAt;
  static const String _baseUrl = 'https://api.flexone.online/v1/expert';

  ConsultationRequest({required this.id, this.transactionConsultationId, required this.user, required this.consultation, required this.appointmentDate, required this.explanation, required this.isDone, required this.rating, this.reason, this.review, required this.status, required this.requestedAt, this.finishedAt});

  factory ConsultationRequest.createRequest(Map<String, dynamic> object) {
    return ConsultationRequest(
      id: object['id'], 
      transactionConsultationId: object['transaction_consultation_id'],
      user: SimpleUser.createUser(object['user']), 
      consultation: Consultation.createConsultation(object['consultation']), 
      appointmentDate: object['appointment_date'], 
      explanation: object['explanation'], 
      isDone: object['is_done'], 
      rating: object['rating'],
      review: object['review'], 
      reason: object['reason'], 
      status: object['status'], 
      requestedAt: object['requested_at'],
      finishedAt: object['finished_at']
    );
  }

  static Future<List<ConsultationRequest>> getRequests(String expertId, int start, int limit, int status) async {
    String url = '$_baseUrl/$expertId/consultation?start=$start&limit=$limit&status=$status';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<ConsultationRequest>((request) => ConsultationRequest.createRequest(request)).toList();
  }
}

class Consultation {
  late String id;
  int? itemId;
  late SimpleExpert? expert;
  late SimpleUser? user;
  String? expertId;
  late String name;
  Proof? proof;
  late String topic;
  late String photo;
  late String description;
  late String link;
  late int price;
  late int discountPrice;
  late double rating;
  late int totalRatings;
  late String status;
  late int totalParticipants;
  late String createdAt;
  Detail? detail;
  static const String _baseUrl = 'https://api.flexone.online/v1/consultation';

  Consultation({required this.id, this.itemId, required this.expert, required this.user, this.expertId, required this.name, this.proof, required this.topic, required this.photo, required this.description, required this.link, required this.price, required this.discountPrice, required this.rating, required this.totalRatings, required this.status, required this.totalParticipants, required this.createdAt, this.detail});

  factory Consultation.createConsultation(Map<String, dynamic> object) {
    return Consultation(
      id: object['id'],
      itemId: object['item_id'],
      expert: object['expert'] != null ? SimpleExpert.createExpert(object['expert']) : null,
      user: object['user'] != null ? SimpleUser.createUser(object['user']) : null,
      expertId: object['expert_id'],
      name: object['name'],
      proof: object['proof'] != null ? Proof.createProof(object['proof']) : null,
      topic: object['topic'],
      photo: object['photo'] ?? "",
      description: object['description'] ?? "",
      link: object['link'],
      price: object['price'],
      discountPrice: object['discount_price'],
      rating: (object['rating'] is int) ? (object['rating'] as int).toDouble() : object['rating'],
      totalRatings: object['total_ratings'],
      status: object['status'] != null ? object['status'].toString() : "",
      totalParticipants: object['total_participants'],
      createdAt: object['created_at'],
      detail: object['detail'] != null ? Detail.createDetail(object['detail']) : null
    );
  }

  static Future<List<Consultation>> getConsultations(int start, int limit, String keywords, int? rating, int? lowest, int? highest) async {
    String url = '$_baseUrl/all?start=$start&limit=$limit&status=1&keywords=$keywords';
    if (rating != null) url += '&rating=$rating';
    if (lowest != null) url += '&lowest=$lowest';
    if (highest != null) url += '&highest=$highest';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Consultation>((consultation) => Consultation.createConsultation(consultation)).toList();
  }

  static Future<List<Consultation>> getTopConsultations(int start, int limit, String keywords, int? lowest, int? highest) async {
    String url = '$_baseUrl/top?start=$start&limit=$limit&keywords=$keywords';
    if (lowest != null) url += '&lowest=$lowest';
    if (highest != null) url += '&highest=$highest';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Consultation>((consultation) => Consultation.createConsultation(consultation)).toList();
  }

  static Future<List<Consultation>> getConsultationsOwned(String expertId, int start, int limit, String keywords) async {
    String url = 'https://api.flexone.online/v1/expert/$expertId/consultations?start=$start&limit=$limit&keywords=$keywords';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Consultation>((consultation) => Consultation.createConsultation(consultation)).toList();
  }

  static Future<List<Consultation>> getConsultationsJoined(String userId, int start, int limit) async {
    String url = 'https://api.flexone.online/v1/user/$userId/consultation/all?start=$start&limit=$limit';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Consultation>((consultation) => Consultation.createConsultation(consultation)).toList();
  }

  static Future createNewConsultation(String expertId, String name, String proofImage, String proofDetail, String photo, String topic, String description, String link, String price, String discountPrice) async {
    const url = '$_baseUrl/new';
    final response = await http.post(Uri.parse(url), body: {
      "expert_id": expertId,
      "name": name,
      "proof_image": proofImage,
      "proof_detail": proofDetail,
      "photo": photo,
      "topic": topic,
      "description": description,
      "link": link,
      "price": price,
      "discount_price": discountPrice
    });
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Consultation.createConsultation(data);
  }

  static Future updateConsultation(String consultationId, String photo, String description, String link, String price, String discountPrice) async {
    final url = '$_baseUrl/$consultationId';
    await http.put(Uri.parse(url), body: {
      "photo": photo,
      "description": description,
      "link": link,
      "price": price,
      "discount_price": discountPrice
    });
  }

  static Future deleteConsultation(String consultationId) async {
    final url = '$_baseUrl/$consultationId/close';
    final response = await http.delete(Uri.parse(url));
    final jsonObject = json.decode(response.body);

    if (response.statusCode == 400) {
      throw Exception(jsonObject['message']);
    }
  }

  static Future<Consultation> getConsultation(String consultationId) async {
    final url = '$_baseUrl/$consultationId';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Consultation.createConsultation(data);
  }

  static Future joinConsultation(String consultationId, String userId, String appointmentDate, String explanation) async {
    final url = '$_baseUrl/$consultationId/join';
    final response = await http.post(Uri.parse(url), body: {
      "user_id": userId,
      "appointment": appointmentDate,
      "explanation": explanation
    });
  }

  static Future respondRequest(int requestId, int action, String? reason) async {
    final url = '$_baseUrl/request/$requestId';
    await http.put(Uri.parse(url), body: {
      "action": action.toString(),
      "reason": reason
    });
  }

  static Future reschedule(int requestId, String date) async {
    final url = '$_baseUrl/reschedule/$requestId';
    await http.put(Uri.parse(url), body: {
      "date": date
    });
  }

  static Future giveRating(int id, String consultationId, int rating, String review) async {
    final url = '$_baseUrl/$id/rating';
    await http.post(Uri.parse(url), body: {
      "consultation_id": consultationId,
      "rating": rating.toString(),
      "review": review
    });
  }

  static Future<List<Consultation>> getReviews(String expertId, int start, int limit) async {
    String url = 'https://api.flexone.online/v1/expert/$expertId/consultation/reviews?start=$start&limit=$limit';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Consultation>((consultation) => Consultation.createConsultation(consultation)).toList();
  }
}

class Detail {
  late int id;
  String? invoice;
  int? transactionId;
  late String appointmentDate;
  late String explanation;
  late bool isDone;
  late int rating;
  String? review;
  late String status;
  String? reason;
  late String joinedAt;
  bool? finished;

  Detail({required this.id, this.invoice, this.transactionId, required this.appointmentDate, required this.explanation, required this.isDone, required this.rating, this.reason, this.review, required this.status, required this.joinedAt, this.finished});

  factory Detail.createDetail(Map<String, dynamic> object) {
    return Detail(
      id: object['id'],
      invoice: object['invoice'],
      transactionId: object['transaction_id'],
      appointmentDate: object['appointment_date'], 
      explanation: object['explanation'], 
      isDone: object['is_done'], 
      rating: object['rating'],
      review: object['review'], 
      reason: object['reason'], 
      status: object['status'], 
      joinedAt: object['joined_at'],
      finished: object['finished']
    );
  }
}

class SimpleUser {
  late String id;
  late String name;
  late String? photo;

  SimpleUser({required this.id, required this.name, this.photo});

  factory SimpleUser.createUser(Map<String, dynamic> object) {
    return SimpleUser(
      id: object['id'], 
      name: object['name'],
      photo: object['photo'] ?? "",
    );
  }
}

class SimpleExpert {
  late String id;
  late String userId;
  late String name;
  late String? photo;
  late String? education;

  SimpleExpert({required this.id, required this.name, required this.userId, this.photo, this.education});

  factory SimpleExpert.createExpert(Map<String, dynamic> object) {
    return SimpleExpert(
      id: object['id'], 
      name: object['name'],
      userId: object['user_id'],
      photo: object['photo'] ?? "",
      education: object['education'] ?? ""
    );
  }
}

class Proof {
  late String image;
  late String detail;

  Proof({required this.image, required this.detail});

  factory Proof.createProof(Map<String, dynamic> object) {
    return Proof(image: object['image'], detail: object['detail']);
  }
}