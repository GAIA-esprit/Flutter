import 'package:quiz_backoffice/model/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ordereService {
Future<List<Order>> fetchOrders() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse != null && jsonResponse['orders'] is List<dynamic>) {
        List<Order> orderList = (jsonResponse['orders'] as List<dynamic>)
            .map((order) => Order.fromJson(order))
            .toList();
        return orderList;
      } else {
        throw Exception(
            'JSON response does not contain a valid list of orders');
      }
    } else {
      // Failed to fetch orders
      throw Exception(
          'Failed to fetch orders. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error in fetchOrders: $error');
    throw Exception('Failed to fetch orders');
  }
}


//
   Future<void> deleteOrder(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/order/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete order. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in deleteOrder: $error');
      throw Exception('Failed to delete order');
    }
  }

 Future<void> createOrder(Order newOrder) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/order/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newOrder.toJson()), // Corrected this line
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final createdOrder = Order.fromJson(jsonResponse['order']);
        // Do something with the createdOrder if needed
      } else {
        throw Exception(
            'Failed to create order. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in createOrder: $error');
      throw Exception('Failed to create order');
    }
  }

Future<void> updateOrder(String orderId, Order updatedOrder) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/order/$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedOrder.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final updatedOrder = Order.fromJson(jsonResponse['order']);
        // Do something with the updatedOrder if needed
      } else {
        throw Exception(
            'Failed to update order. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in updateOrder: $error');
      throw Exception('Failed to update order');
    }
  }

}