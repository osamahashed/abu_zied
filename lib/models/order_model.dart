class Order {
  final int? id;
  final int userId;
  final int productId;
  final String? notes;
  final String orderDate;
  final String status; // 'pending', 'confirmed', 'completed'

  Order({
    this.id,
    required this.userId,
    required this.productId,
    this.notes,
    required this.orderDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'notes': notes,
      'order_date': orderDate,
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
      notes: map['notes'],
      orderDate: map['order_date'],
      status: map['status'] ?? 'pending',
    );
  }
}
