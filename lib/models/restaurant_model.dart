class Restaurant {
  final int id;
  final String name;
  final String description;
  final String address;
  final String cuisineType;
  final double rating;
  final int ownerId;
  final bool isActive;
  final bool isApproved;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String openingTime;
  final String closingTime;
  final double? distance;
  final bool? isOpen;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.cuisineType,
    required this.rating,
    required this.ownerId,
    required this.isActive,
    required this.isApproved,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
    this.distance,
    this.isOpen,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      cuisineType: json['cuisine_type'],
      rating: json['rating']?.toDouble() ?? 0.0,
      ownerId: json['owner_id'],
      isActive: json['is_active'],
      isApproved: json['is_approved'],
      imageUrl: json['image_url'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      distance: json['distance']?.toDouble(),
      isOpen: json['is_open'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'cuisine_type': cuisineType,
      'rating': rating,
      'owner_id': ownerId,
      'is_active': isActive,
      'is_approved': isApproved,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'opening_time': openingTime,
      'closing_time': closingTime,
    };
  }
}
