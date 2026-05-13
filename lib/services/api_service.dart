import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']['token'];
        await saveToken(token);
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<ProductModel>> getProducts() async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final url = Uri.parse('$baseUrl/api/products');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final dataField = jsonResponse['data'];

      List<dynamic> productsJson = [];

      if (dataField is List) {
        productsJson = dataField;
      } else if (dataField is Map) {
        if (dataField.containsKey('products')) {
          productsJson = dataField['products'] as List;
        } else if (dataField.containsKey('items')) {
          productsJson = dataField['items'] as List;
        } else if (dataField.containsKey('data')) {
          productsJson = dataField['data'] as List;
        } else {
          throw Exception('Struktur data tidak dikenal: $dataField');
        }
      } else {
        throw Exception('Field "data" bukan List atau Map: $dataField');
      }

      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil produk: ${response.body}');
    }
  }

  Future<bool> createProduct(String name, int price, String description) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final url = Uri.parse('$baseUrl/api/products');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> submitAssignment({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final url = Uri.parse('$baseUrl/api/products/submit');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    return response.statusCode == 200;
  }
}
