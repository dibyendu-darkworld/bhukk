class CarouselItem {
  final int id;
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String? redirectUrl;
  final int position;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  CarouselItem({
    required this.id,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.redirectUrl,
    required this.position,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CarouselItem.fromJson(Map<String, dynamic> json) {
    return CarouselItem(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['image_url'] ?? '',
      redirectUrl: json['redirect_url'],
      position: json['position'],
      isActive: json['is_active'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
