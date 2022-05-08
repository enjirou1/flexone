import 'dart:convert';
import 'package:http/http.dart' as http;

class Question {
  late String questionId;
  late User user;
  late Subject subject;
  late Grade grade;
  late String text;
  late int point;
  late String photo;
  late int totalAnswers;
  late int isReported;
  late String createdAt;
  static const String _baseUrl = 'https://api.flexone.online/v1/question';

  Question({required this.questionId, required this.user, required this.subject, required this.grade, required this.text, required this.point, required this.photo, required this.totalAnswers, required this.isReported, required this.createdAt});

  factory Question.createQuestion(Map<String, dynamic> object) {
    return Question(
      questionId: object['question_id'], 
      user: User.createUser(object['user']), 
      subject: Subject.createSubject(object['subject']), 
      grade: Grade.createGrade(object['grade']), 
      text: object['text'], 
      point: object['given_point'], 
      photo: object['photo'] ?? "", 
      totalAnswers: object['total_answers'], 
      isReported: object['is_reported'], 
      createdAt: object['created_at']
    );
  }

  static Future<List<Question>> getQuestions(int start, int limit, String keywords, int grade, int subject, String? userId) async {
    var url = '$_baseUrl?start=$start&limit=$limit&keywords=$keywords';
    if (grade != 0) url += "&grade=$grade";
    if (subject != 0) url += "&subject=$subject";
    if (userId != null) url += "&user_id=$userId";
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Question>((question) => Question.createQuestion(question)).toList();
  }

  static Future deleteQuestion(String id) async {
    final url = '$_baseUrl/$id';
    final response = await http.delete(Uri.parse(url));
    
    if (response.statusCode != 200) {
      throw Exception(response.statusCode);
    }
  }

  static Future<Question> createNewQuestion(String userId, String subjectId, String gradeId, String text, String point, String photo) async {
    const url = '$_baseUrl/new';
    final response = await http.post(Uri.parse(url), body: {
      "user_id": userId,
      "subject_id": subjectId,
      "grade_id": gradeId,
      "text": text,
      "given_point": point,
      "photo": photo
    });
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Question.createQuestion(data);
  }

  static Future<List<Answer>> getAnswers(int start, int limit, String questionId) async {
    final url = '$_baseUrl/answer/all?start=$start&limit=$limit&id=$questionId';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Answer>((answer) => Answer.createAnswer(answer)).toList();
  }

  static Future<Answer> answer(String questionId, String userId, String text, String photo) async {
    final url = '$_baseUrl/$questionId/answer';
    final response = await http.post(Uri.parse(url), body: {
      'user_id': userId,
      'text': text,
      'photo': photo
    });
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Answer.createAnswer(data);
  }

  static Future rating(String answerId, String userId, String rating) async {
    final url = '$_baseUrl/answer/$answerId/rating';
    final response = await http.post(Uri.parse(url), body: {
      'user_id': userId,
      'rating': rating
    });
    
    if (response.statusCode == 400) throw Exception(json.decode(response.body)['message']);
  }

  static Future<bool> checkRating(String answerId, String userId) async {
    final url = '$_baseUrl/answer/$answerId/rating/$userId';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body)['data'];
    return data;
  }

  static Future<List<Comment>> getComments(int start, int limit, String answerId) async {
    final url = '$_baseUrl/answer/$answerId/comment/all?start=$start&limit=$limit';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Comment>((comment) => Comment.createComment(comment)).toList();
  }

  static Future<Comment> comment(String answerId, String userId, String text) async {
    final url = '$_baseUrl/answer/$answerId/comment';
    final response = await http.post(Uri.parse(url), body: {
      'user_id': userId,
      'text': text
    });
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Comment.createComment(data);
  }

  static Future acceptAnswer(String answerId, String questionId, String userId) async {
    final url = '$_baseUrl/answer/$answerId/accept';
    await http.post(Uri.parse(url), body: {
      'question_id': questionId,
      'user_id': userId
    });
  }
}

class Answer {
  late String answerId;
  late User user;
  late String questionId;
  late String text;
  late String photo;
  late double rating;
  late int totalComments;
  late bool accepted;
  late String createdAt;
  late bool updatePoint;

  Answer({required this.answerId, required this.user, required this.questionId, required this.text, required this.photo, required this.rating, required this.totalComments, required this.accepted, required this.createdAt, required this.updatePoint});

  factory Answer.createAnswer(Map<String, dynamic> object) {
    return Answer(
      answerId: object['id'],
      user: User.createUser(object['user']),
      questionId: object['question_id'],
      text: object['text'],
      photo: object['photo'],
      rating: (object['rating'] is int) ? (object['rating'] as int).toDouble() : object['rating'],
      totalComments: object['total_comments'],
      accepted: object['accepted'],
      createdAt: object['created_at'],
      updatePoint: object['update_point'] ?? false
    );
  }
}

class Comment {
  late int commentId;
  late User user;
  late String answerId;
  late String text;
  late String createdAt;

  Comment({required this.commentId, required this.user, required this.answerId, required this.text, required this.createdAt});

  factory Comment.createComment(Map<String, dynamic> object) {
    return Comment(
      commentId: object['id'],
      user: User.createUser(object['user']),
      answerId: object['answer_id'],
      text: object['text'],
      createdAt: object['created_at'],
    );
  }
}

class User {
  late String id;
  late String name;
  late String photo;

  User({required this.id, required this.name, required this.photo});

  factory User.createUser(Map<String, dynamic> object) {
    return User(
      id: object['id'], 
      name: object['name'], 
      photo: object['photo'] ?? ""
    );
  }
}

class Subject {
  late int id;
  late String name;
  static const String _baseUrl = 'https://api.flexone.online/v1/subject';

  Subject({required this.id, required this.name});

  factory Subject.createSubject(Map<String, dynamic> object) {
    return Subject(
      id: object['id'], 
      name: object['name']
    );
  }

  static Future<List<Subject>> getSubjects() async {
    const url = '$_baseUrl/all';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Subject>((subject) => Subject.createSubject({...subject, "id": subject['subject_id']})).toList();
  }
}

class Grade {
  late int id;
  late String name;
  static const String _baseUrl = 'https://api.flexone.online/v1/grade';

  Grade({required this.id, required this.name});

  factory Grade.createGrade(Map<String, dynamic> object) {
    return Grade(
      id: object['id'], 
      name: object['name']
    );
  }

  static Future<List<Grade>> getGrades() async {
    const url = '$_baseUrl/all';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Grade>((grade) => Grade.createGrade({...grade, "id": grade['grade_id']})).toList();
  }
}