import 'package:quiz_backoffice/model/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class produitService {
Future<List<Product>> fetchProducts() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse != null && jsonResponse['products'] is List<dynamic>) {
        List<Product> productList = (jsonResponse['products'] as List<dynamic>)
            .map((product) => Product.fromJson(product))
            .toList();
        return productList;
      } else {
        throw Exception(
            'JSON response does not contain a valid list of products');
      }
    } else {
      // Failed to fetch products
      throw Exception(
          'Failed to fetch products. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error in fetchProducts: $error');
    throw Exception('Failed to fetch products');
  }
}


//
   Future<void> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/product/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete product. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in deleteProduct: $error');
      throw Exception('Failed to delete product');
    }
  }

 Future<void> createProduct(Product newProduct) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/product/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newProduct.toJson()), // Corrected this line
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final createdProduct = Product.fromJson(jsonResponse['product']);
        // Do something with the createdProduct if needed
      } else {
        throw Exception(
            'Failed to create product. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in createProduct: $error');
      throw Exception('Failed to create product');
    }
  }

Future<void> updateProduct(String productId, Product updatedProduct) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/product/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedProduct.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final updatedProduct = Product.fromJson(jsonResponse['product']);
        // Do something with the updatedProduct if needed
      } else {
        throw Exception(
            'Failed to update product. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in updateProduct: $error');
      throw Exception('Failed to update product');
    }
  }

}