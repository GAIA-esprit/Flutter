
import 'dart:ffi';

class Product {
  final String id;
  final String category;
  final String description;
  final double price;
  final String image;
  final String name;

  Product({
    required this.id,
    required this.category,
    required this.description,
    required this.price,
    required this.image,
    required this.name,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      category: json['category'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      name: json['name'],
    );
  }
}
