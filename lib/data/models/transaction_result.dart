import 'dart:convert';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:http/http.dart' as http;

class Cart {
  late String invoice;
  late int total;
  late List<Consultation> consultationItems;
  late List<Class> classItems;
  static const String _baseUrl = 'https://api.flexone.online/v1';

  Cart({required this.invoice, required this.total, required this.consultationItems, required this.classItems});

  factory Cart.createCart(Map<String, dynamic> object) {
    return Cart(
      invoice: object['invoice'],
      total: object['total'],
      consultationItems: List<Map<String, dynamic>>.from(object['consultations'] as List)
                        .map((consultation) => Consultation.createConsultation(consultation)).toList(),
      classItems: List<Map<String, dynamic>>.from(object['classes'] as List)
                        .map((item) => Class.createClass(item)).toList(),
    );
  }

  static Future<Cart?> getCart(String userId) async {
    final url = '$_baseUrl/user/$userId/cart';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'];
    if (data != null) {
      return Cart.createCart(data);
    } else {
      return null;
    }
  }

  static Future removeItem(String userId, String type, int itemId) async {
    final url = '$_baseUrl/user/$userId/cart/$type/$itemId';
    await http.delete(Uri.parse(url));
  }

  static Future<String> checkout(String invoice) async {
    const url = '$_baseUrl/transaction/checkout';
    final response = await http.post(Uri.parse(url), body: {
      "invoice": invoice
    });
    
    if (response.statusCode != 201) {
      throw Exception(response.statusCode);
    } else {
      return json.decode(response.body)['data']['invoice_url'];
    }
  }
}