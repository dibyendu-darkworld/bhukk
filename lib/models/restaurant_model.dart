class Restaurant {
  final int id;
  final String name;
  final String? description;
  final String? address;
  final String cuisineType;
  final double rating;
  final int ownerId;
  final bool isActive;
  final bool isApproved;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String? openingTime;
  final String? closingTime;
  final double? distance;
  final bool? isOpen;

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    this.address,
    required this.cuisineType,
    required this.rating,
    required this.ownerId,
    required this.isActive,
    required this.isApproved,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.openingTime,
    this.closingTime,
    this.distance,
    this.isOpen,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    double? parsedDistance;
    if (json['distance'] != null) {
      final d = json['distance'];
      if (d is num) {
        parsedDistance = d.toDouble();
      } else if (d is String) {
        parsedDistance = double.tryParse(d);
      }
    }
    return Restaurant(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description']?.toString(),
      address: json['address']?.toString(),
      cuisineType: json['cuisine_type'] ?? '',
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      ownerId: json['owner_id'] ?? 0,
      isActive: json['is_active'] ?? true,
      isApproved: json['is_approved'] ?? true,
      imageUrl: json['image_url']?.toString(),
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : 0.0,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : 0.0,
      openingTime: json['opening_time']?.toString(),
      closingTime: json['closing_time']?.toString(),
      distance: parsedDistance,
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
