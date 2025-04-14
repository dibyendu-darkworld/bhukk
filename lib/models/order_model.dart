class OrderItem {
  final int id;
  final int menuItemId;
  final int orderId;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.id,
    required this.menuItemId,
    required this.orderId,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      menuItemId: json['menu_item_id'],
      orderId: json['order_id'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_item_id': menuItemId,
      'order_id': orderId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }
}

class Order {
  final int id;
  final int restaurantId;
  final int customerId;
  final double totalAmount;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.restaurantId,
    required this.customerId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> items = [];
    if (json['order_items'] != null) {
      items = List<OrderItem>.from(
          json['order_items'].map((item) => OrderItem.fromJson(item)));
    }

    return Order(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      customerId: json['customer_id'],
      totalAmount: json['total_amount'].toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      orderItems: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'customer_id': customerId,
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'order_items': orderItems.map((item) => item.toJson()).toList(),
    };
  }
}
