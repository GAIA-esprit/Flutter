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

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      image: map['image'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'price': price,
      'image': image,
      'name': name,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'price': price,
      'image': image,
      'name': name,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] != null ? json['_id'] as String : '',
      category: json['category'] != null ? json['category'].toString() : '',
      description:
          json['description'] != null ? json['description'].toString() : '',
      price: json['price'] != null ? json['price'] as double : 0.0,
      image: json['image'] != null ? json['image'].toString() : '',
      name: json['name'] != null ? json['name'].toString() : '',
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, category: $category, description: $description, price: $price, image: $image, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.category == category &&
        other.description == description &&
        other.price == price &&
        other.image == image &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        category.hashCode ^
        description.hashCode ^
        price.hashCode ^
        image.hashCode ^
        name.hashCode;
  }
}
