import 'package:demo/data/models/MenuItems.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuService {
  static const String baseUrl = "https://fakerestaurantapi.runasp.net/api/Restaurant/items";
  final http.Client client;

  MenuService({http.Client? client}) : client = client ?? http.Client();

  Future<List<MenuItems>> fetchMenu() async {
    try {
      final response = await client.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return MenuItems.fromJsonList(jsonResponse);
      } else {
        throw Exception("Gagal memuat data dari server");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
