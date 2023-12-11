import 'dart:convert';
import 'package:flutter_web_dashboard/model/Product.dart';
import 'package:http/http.dart' as http;

// Fetch products data
Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:3000/api/products'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((product) => Product.fromJson(product)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

// Delete a product by ID
Future<void> deleteProduct(String id) async {
  final response = await http.delete(Uri.parse('http://127.0.0.1:3000/api/product/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
}
