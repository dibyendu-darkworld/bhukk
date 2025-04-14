class User {
  final int id;
  final String email;
  final String username;
  final bool isActive;
  final bool isRestaurant;
  final bool isAdmin;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.isActive,
    required this.isRestaurant,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      isActive: json['is_active'],
      isRestaurant: json['is_restaurant'],
      isAdmin: json['is_admin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'is_active': isActive,
      'is_restaurant': isRestaurant,
      'is_admin': isAdmin,
    };
  }
}
