import 'dart:convert';

import 'package:http/http.dart' as http;

class RajaOngkirModel {
  static const String _baseUrl = 'https://api.rajaongkir.com/starter';
  static const String _apiKey = '91dbea69b642a4faddbcd9fbbf15644e';

  static Future<List<Province>?> getProvinces() async {
    try {
      const String url = '$_baseUrl/province';
      final response =
          await http.get(Uri.parse(url), headers: {"key": _apiKey});
      final jsonObject = json.decode(response.body);
      final data =
          (jsonObject as Map<String, dynamic>)['rajaongkir']['results'];
      List<Province> provinces = [];
      for (var item in data) {
        provinces.add(Province.createProvince(item));
      }
      return provinces;
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<List<City>?> getCities() async {
    try {
      final String url = '$_baseUrl/city';
      final response =
          await http.get(Uri.parse(url), headers: {"key": _apiKey});
      final jsonObject = json.decode(response.body);
      final data =
          (jsonObject as Map<String, dynamic>)['rajaongkir']['results'];
      List<City> cities = [];
      for (var item in data) {
        cities.add(City.createCity(item));
      }
      return cities;
    } catch (e) {
      print(e);
    }

    return null;
  }
}

class Province {
  String? provinceId;
  String? provinceName;

  Province({this.provinceId, this.provinceName});

  factory Province.createProvince(Map<String, dynamic> object) {
    return Province(
        provinceId: object['province_id'], provinceName: object['province']);
  }
}

class City {
  String? cityId;
  String? cityName;
  String? provinceId;
  String? provinceName;

  City({this.cityId, this.cityName, this.provinceId, this.provinceName});

  factory City.createCity(Map<String, dynamic> object) {
    return City(
        cityId: object['city_id'],
        cityName: "${object['type']} ${object['city_name']}",
        provinceId: object['province_id'],
        provinceName: object['province']);
  }
}
