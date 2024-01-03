class Order {
  final String id;
  final String location;
  final String date;
  final double totalAmount;
  final String isPaid;

  Order({
    required this.id,
    required this.location,
    required this.date,
    required this.totalAmount,
    required this.isPaid,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      location: map['location'] as String,
      date: map['date'] as String,
      totalAmount: map['totalAmount'] as double,
      isPaid: map['isPaid'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'date': date,
      'totalAmount': totalAmount,
      'isPaid': isPaid,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'date': date,
      'totalAmount': totalAmount,
      'isPaid': isPaid,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] != null ? json['_id'] as String : '',
      location: json['location'] != null ? json['location'].toString() : '',
      date:
          json['date'] != null ? json['date'].toString() : '',
      totalAmount: json['totalAmount'] != null ? json['totalAmount'] as double : 0.0,
      isPaid: json['isPaid'] != null ? json['isPaid'].toString() : '',
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, location: $location, date: $date, totalAmount: $totalAmount, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.id == id &&
        other.location == location &&
        other.date == date &&
        other.totalAmount == totalAmount &&
        other.isPaid == isPaid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        location.hashCode ^
        date.hashCode ^
        totalAmount.hashCode ^
        isPaid.hashCode ;
  }
}
