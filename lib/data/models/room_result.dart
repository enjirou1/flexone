import 'dart:convert';

import 'package:http/http.dart' as http;

class Room {
  late String id;
  late String name;
  late String status;
  late User user;
  late String photo;
  late String description;
  late int maxSlot;
  late int totalMembers;
  late String createdAt;
  static const String _baseUrl = 'https://api.flexone.online/v1/room';

  Room({required this.id, required this.name, required this.status, required this.user, required this.photo, required this.description, required this.maxSlot, required this.totalMembers, required this.createdAt});

  factory Room.createRoom(Map<String, dynamic> object) {
    return Room(
      id: object['id'],
      name: object['name'],
      status: object['status'],
      user: User.createUser(object['user']),
      photo: object['photo'] ?? "",
      description: object['description'] ?? "",
      maxSlot: object['max_slot'],
      totalMembers: object['total_members'],
      createdAt: object['created_at']
    );
  }

  static Future<List<Room>> getRooms(int start, int limit, String keywords) async {
    final url = '$_baseUrl/all?start=$start&limit=$limit&keywords=$keywords';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Room>((room) => Room.createRoom(room)).toList();
  }

  static Future<List<Room>> getJoinedRooms(String userId, int start, int limit, String keywords) async {
    final url = 'https://api.flexone.online/v1/user/$userId/room/all?start=$start&limit=$limit&keywords=$keywords';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Room>((room) => Room.createRoom(room)).toList();
  }

  static Future deleteRoom(String id) async {
    final url = '$_baseUrl/$id';
    await http.delete(Uri.parse(url));
  }

  static Future<Room> createNewRoom(String userId, String name, String photo, String description, String password, String maxSlot) async {
    const url = '$_baseUrl/new';
    final response = await http.post(Uri.parse(url), body: {
      "user_id": userId,
      "name": name,
      "photo": photo,
      "description": description,
      "password": password,
      "max_slot": maxSlot
    });
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Room.createRoom(data);
  }

  static Future<Room> updateRoom(String roomId, String userId, String name, String photo, String description, String password, String maxSlot) async {
    final url = '$_baseUrl/$roomId';
    final response = await http.put(Uri.parse(url), body: {
      "user_id": userId,
      "name": name,
      "photo": photo,
      "description": description,
      "password": password,
      "max_slot": maxSlot
    });
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Room.createRoom(data);
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