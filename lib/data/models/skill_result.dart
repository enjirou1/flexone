import 'dart:convert';

import 'package:http/http.dart' as http;

class Skill {
  late int id;
  late String name;
  static const String _baseUrl = 'https://api.flexone.online/v1/skill';

  Skill({required this.id, required this.name});

  factory Skill.createSkill(Map<String, dynamic> object) {
    return Skill(
      id: object['skill_id'],
      name: object['name']
    );
  }

  static Future<List<Skill>> getSkills() async {
    const url = '$_baseUrl/all';
    final response = await http.get(Uri.parse(url));
    final jsonObject = json.decode(response.body);
    final data = (jsonObject as Map<String, dynamic>)['data'] as List;
    return data.map<Skill>((skill) => Skill.createSkill(skill)).toList();
  }
}