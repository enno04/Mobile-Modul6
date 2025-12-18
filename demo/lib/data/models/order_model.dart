class Order {
  final String id;
  final String userId;
  final DateTime createdAt;
  final List<Map<String, dynamic>> items;
  final int totalPrice;
  final String status;
  final String? notes;

  Order({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.items,
    required this.totalPrice,
    required this.status,
    this.notes,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      items: (map['items'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      totalPrice: map['total_price'] as int,
      status: map['status'] as String,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'items': items,
      'total_price': totalPrice,
      'status': status,
      'notes': notes,
    };
  }
}
