import 'dart:convert';

import 'package:http/http.dart' as http;

class Merchandise {
  late int id;
  late String name;
  late String? photo;
  late String? description;
  late int price;
  late int stock;
  late String createdAt;
  static const String _baseUrl = 'https://api.flexone.online/v1/merchandise';

  Merchandise({required this.id, required this.name, required this.photo, required this.description, required this.price, required this.stock, required this.createdAt});

  factory Merchandise.createMerchandise(Map<String, dynamic> object) {
    return Merchandise(
      id: object['merchandise_id'],
      name: object['name'],
      photo: object['photo'],
      description: object['description'],
      price: object['price'],
      stock: object['stock'],
      createdAt: object['created_at']
    );
  }

  static Future<List<Merchandise>> getMerchandises(int start, int limit, String keywords, int lowestPrice, int highestPrice) async {
    var url = '$_baseUrl/all?start=$start&limit=$limit&keywords=$keywords';

    if (lowestPrice != 0 || highestPrice != 0) url += '&lowest_price=$lowestPrice&highest_price=$highestPrice';

    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Merchandise>((merchandise) => Merchandise.createMerchandise(merchandise)).toList();
  }

  static Future<Merchandise> getMerchandiseByID(int id) async {
    final url = '$_baseUrl/$id';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Merchandise.createMerchandise(data);
  }

  static Future<Merchandise> buyMerchandise(int id, String userId) async {
    final url = '$_baseUrl/$id/buy';
    final response = await http.post(Uri.parse(url), body: {
      "user_id": userId
    });
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    return Merchandise.createMerchandise(data);
  }
}

class MerchandiseHistory {
  int id;
  String status;
  String courier;
  int cost;
  String boughtAt;
  Merchandise merchandise;

  MerchandiseHistory({required this.id, required this.status, required this.courier, required this.cost, required this.boughtAt, required this.merchandise});

  factory MerchandiseHistory.createMerchandiseHistory(Map<String, dynamic> object) {
    return MerchandiseHistory(
      id: object['id'], 
      status: object['status'] ?? "", 
      courier: object['courier'] ?? "", 
      cost: object['shipping_cost'] ?? 0, 
      boughtAt: object['bought_at'],
      merchandise: Merchandise.createMerchandise({...object['merchandise'], "merchandise_id": object['merchandise']['id']})
    );
  }

  static Future<List<MerchandiseHistory>> getOwnedMerchandises(String userId, int start, int limit) async {
    var url = 'https://api.flexone.online/v1/user/$userId/merchandise/all?start=$start&limit=$limit';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<MerchandiseHistory>((history) => MerchandiseHistory.createMerchandiseHistory(history)).toList();
  }
}