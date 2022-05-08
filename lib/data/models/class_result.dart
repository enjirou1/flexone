import 'dart:convert';

import 'package:flexone/data/models/dicussion_result.dart';
import 'package:http/http.dart' as http;

class Class {
  late String id;
  int? itemId;
  SimpleExpert? expert;
  SimpleUser? user;
  String? expertId;
  Subject? subject;
  Grade? grade;
  late String name;
  String? photo;
  String? description;
  late int price;
  late int discountPrice;
  late int estimatedTime;
  late double rating;
  late int totalRatings;
  late int totalParticipants;
  late int totalModules;
  bool? joined;
  late String createdAt;
  List<Section>? sections;
  Detail? detail;
  static const String _baseUrl = 'https://api.flexone.online/v1/class';

  Class({required this.id, this.itemId, this.expert, this.user, this.expertId, this.subject, this.grade, required this.name, this.photo, this.description, required this.price, required this.discountPrice, required this.estimatedTime, required this.rating, required this.totalRatings, required this.totalParticipants, required this.totalModules, required this.joined, required this.createdAt, this.detail, this.sections});

  factory Class.createClass(Map<String, dynamic> object) {
    return Class(
      id: object['id'], 
      itemId: object['item_id'],
      expert: object['expert'] != null ? SimpleExpert.createExpert(object['expert']) : null,
      user: object['user'] != null ? SimpleUser.createUser(object['user']) : null,
      expertId: object['expert_id'],
      subject: object['subject'] != null ? Subject.createSubject(object['subject']) : null,
      grade: object['grade'] != null ? Grade.createGrade(object['grade']) : null,
      name: object['name'], 
      photo: object['photo'],
      description: object['description'],
      price: object['price'] ?? 0, 
      discountPrice: object['discount_price'] ?? 0, 
      estimatedTime: object['estimated_time'] ?? 0, 
      rating: (object['rating'] is int) ? (object['rating'] as int).toDouble() : object['rating'],
      totalRatings: object['total_ratings'],
      totalParticipants: object['total_participants'], 
      totalModules: object['total_modules'], 
      joined: object['joined'] ?? false, 
      createdAt: object['created_at'],
      detail: object['detail'] != null ? Detail.createDetail(object['detail']) : null,
      sections: object['syllabus'] != null ? List<Map<String, dynamic>>.from(object['syllabus'] as List)
                .map((section) => Section.createSection(section)).toList() : null
    );
  }

  static Future<List<Class>> getClasses(int start, int limit, String keywords, int? rating, int? lowest, int? highest, int? grade, int? subject, String? userId) async {
    String url = '$_baseUrl/all?start=$start&limit=$limit&keywords=$keywords';
    if (rating != null) url += '&rating=$rating';
    if (lowest != null) url += '&lowest=$lowest';
    if (highest != null) url += '&highest=$highest';
    if (grade != null) url += '&grade=$grade';
    if (subject != null) url += '&subject=$subject';
    if (userId != null) url += '&user=$userId';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Class>((item) => Class.createClass(item)).toList();
  }

  static Future<List<Class>> getClassesOwned(String expertId, int start, int limit, String keywords) async {
    String url = 'https://api.flexone.online/v1/expert/$expertId/class?start=$start&limit=$limit&keywords=$keywords';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Class>((item) => Class.createClass(item)).toList();
  }

  static Future deleteClass(String classId) async {
    final String url = '$_baseUrl/$classId';
    await http.delete(Uri.parse(url));
  }

  static Future createNewClass(String expertId, int? subject, int? grade, String name, String photo, String description, String price, String discountPrice, String estimatedTime) async {
    const String url = '$_baseUrl/new';
    await http.post(Uri.parse(url), body: {
      "expert_id": expertId,
      "subject_id": subject.toString(),
      "grade_id": grade.toString(),
      "name": name,
      "photo": photo,
      "description": description,
      "price": price,
      "discount_price": discountPrice,
      "estimated_time": estimatedTime
    });
  }

  static Future updateClass(String classId, int? subject, int? grade, String name, String photo, String description, String price, String discountPrice, String estimatedTime) async {
    final String url = '$_baseUrl/$classId';
    await http.put(Uri.parse(url), body: {
      "subject_id": subject.toString(),
      "grade_id": grade.toString(),
      "name": name,
      "photo": photo,
      "description": description,
      "price": price,
      "discount_price": discountPrice,
      "estimated_time": estimatedTime
    });
  }

  static Future<Class> getClass(String classId) async {
    final String url = '$_baseUrl/$classId';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Class.createClass(data);
  }

  static Future deleteSection(int sectionId) async {
    final String url = '$_baseUrl/section/$sectionId';
    await http.delete(Uri.parse(url));
  }

  static Future deleteModule(int moduleId) async {
    final String url = '$_baseUrl/module/$moduleId';
    await http.delete(Uri.parse(url));
  }

  static Future addSection(String classId, String name) async {
    final String url = '$_baseUrl/$classId/section/new';
    await http.post(Uri.parse(url), body: {
      "name": name
    });
  }

  static Future updateSection(int sectionId, String name) async {
    final String url = '$_baseUrl/section/$sectionId';
    await http.put(Uri.parse(url), body: {
      "name": name
    });
  }

  static Future addModule(String classId, int sectionId, String name, String content) async {
    final String url = '$_baseUrl/$classId/module/new';
    await http.post(Uri.parse(url), body: {
      "section_id": sectionId.toString(),
      "name": name,
      "content": content
    });
  }

  static Future updateModule(int moduleId, String name, String content) async {
    final String url = '$_baseUrl/module/$moduleId';
    await http.put(Uri.parse(url), body: {
      "name": name,
      "content": content
    });
  }

  static Future joinClass(String classId, String userId) async {
    final String url = '$_baseUrl/$classId/join';
    final response = await http.post(Uri.parse(url), body: {
      "user_id": userId
    });
    
    if (response.statusCode == 400) {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future<List<Class>> getClassesJoined(String userId, int start, int limit) async {
    String url = 'https://api.flexone.online/v1/user/$userId/class/all?start=$start&limit=$limit';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Class>((item) => Class.createClass(item)).toList();
  }

  static Future giveRating(String classId, String userId, int rating, String review) async {
    final url = '$_baseUrl/$classId/rating';
    await http.post(Uri.parse(url), body: {
      "user_id": userId,
      "rating": rating.toString(),
      "review": review
    });
  }

  static Future<List<Class>> getReviews(String expertId, int start, int limit) async {
    String url = 'https://api.flexone.online/v1/expert/$expertId/class/reviews?start=$start&limit=$limit';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Class>((item) => Class.createClass(item)).toList();
  }

  static Future<List<Review>> getClassReviews(String id, int start, int limit) async {
    final url = '$_baseUrl/$id/reviews?start=$start&limit=$limit';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Review>((review) => Review.createReview(review)).toList();
  }
}

class Review {
  late SimpleUser user;
  late Detail detail;

  Review({required this.user, required this.detail});

  factory Review.createReview(Map<String, dynamic> object) {
    return Review(
      user: SimpleUser.createUser(object['user']), 
      detail: Detail.createDetail(object['detail'])
    );
  }
}

class Detail {
  late int id;
  late String invoice;
  late int rating;
  String? review;
  late String joinedAt;

  Detail({required this.id, required this.invoice, required this.rating, this.review, required this.joinedAt});

  factory Detail.createDetail(Map<String, dynamic> object) {
    return Detail(
      id: object['id'],
      invoice: object['invoice'],
      rating: object['rating'],
      review: object['review'],
      joinedAt: object['joined_at'] 
    );
  }
}

class Section {
  late int id;
  late String name;
  late String createdAt;
  List<Module>? modules;

  Section({required this.id, required this.name, required this.createdAt, required this.modules});

  factory Section.createSection(Map<String, dynamic> object) {
    return Section(
      id: object['id'], 
      name: object['name'], 
      createdAt: object['created_at'], 
      modules: List<Map<String, dynamic>>.from(object['modules'] as List)
              .map((module) => Module.createModule(module)).toList()
    );
  }
}

class Module {
  late int id;
  late String name;
  late String content;
  late String createdAt;

  Module({required this.id, required this.name, required this.content, required this.createdAt});

  factory Module.createModule(Map<String, dynamic> object) {
    return Module(
      id: object['module_id'],
      name: object['name'],
      content: object['content'],
      createdAt: object['created_at']
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