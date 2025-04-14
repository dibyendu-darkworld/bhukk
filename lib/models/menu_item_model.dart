class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final int restaurantId;
  final bool isAvailable;
  final String category;
  final String? imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.restaurantId,
    required this.isAvailable,
    required this.category,
    this.imageUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      discountPrice: json['discount_price'] != null
          ? json['discount_price'].toDouble()
          : null,
      restaurantId: json['restaurant_id'],
      isAvailable: json['is_available'],
      category: json['category'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'restaurant_id': restaurantId,
      'is_available': isAvailable,
      'category': category,
      'image_url': imageUrl,
    };
  }
}
