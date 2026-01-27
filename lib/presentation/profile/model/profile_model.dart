class ProfileModel {
  final int id;
  final String name;
  final String phone;
  final String? photo; 
  final double rating;

  ProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    this.photo,
    required this.rating,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']?['user'] ?? {};
    return ProfileModel(
      id: user['id'] ?? 0,
      name: user['name'] ?? '',
      phone: user['phone'] ?? '',
      photo: user['photo'], 
      rating: (user['rating'] ?? 0).toDouble(),
    );
  }
}
