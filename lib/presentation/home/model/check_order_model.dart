class UserModel {
  final int id;
  final String name;
  final String phone;
  final String photo;
  final double rating;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.photo,
    required this.rating,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      photo: json['photo'],
      rating: (json['rating'] as num).toDouble(),
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'photo': photo,
      'rating': rating,
      'role': role,
    };
  }
}

class TripModel {
  final int driverId;
  final String status;
  final double sourceLat;
  final double sourceLon;
  final double destinationLat;
  final double destinationLon;
  final double dollarPrice;
  final double sypPrice;
  final double kmNumber;
  final double duration;
  final UserModel user; // ← الآن المستخدم موديل كامل

  TripModel({
    required this.driverId,
    required this.status,
    required this.sourceLat,
    required this.sourceLon,
    required this.destinationLat,
    required this.destinationLon,
    required this.dollarPrice,
    required this.sypPrice,
    required this.kmNumber,
    required this.duration,
    required this.user,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      driverId: json['driver_id'],
      status: json['status'] ?? '',
      sourceLat: (json['source_lat'] is String)
          ? double.parse(json['source_lat'])
          : (json['source_lat']?.toDouble() ?? 0.0),
      sourceLon: (json['source_lon'] is String)
          ? double.parse(json['source_lon'])
          : (json['source_lon']?.toDouble() ?? 0.0),
      destinationLat: (json['destination_lat'] is String)
          ? double.parse(json['destination_lat'])
          : (json['destination_lat']?.toDouble() ?? 0.0),
      destinationLon: (json['destination_lon'] is String)
          ? double.parse(json['destination_lon'])
          : (json['destination_lon']?.toDouble() ?? 0.0),
      dollarPrice: (json['dollar_price'] is String)
          ? double.parse(json['dollar_price'])
          : (json['dollar_price']?.toDouble() ?? 0.0),
      sypPrice: (json['syp_price'] is String)
          ? double.parse(json['syp_price'])
          : (json['syp_price']?.toDouble() ?? 0.0),
      kmNumber: (json['km_number'] is String)
          ? double.parse(json['km_number'])
          : (json['km_number']?.toDouble() ?? 0.0),
      duration: (json['duration'] is String)
          ? double.parse(json['duration'])
          : (json['duration']?.toDouble() ?? 0.0),
      user: UserModel.fromJson(json['User'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "driver_id": driverId,
      "status": status,
      "source_lat": sourceLat,
      "source_lon": sourceLon,
      "destination_lat": destinationLat,
      "destination_lon": destinationLon,
      "dollar_price": dollarPrice,
      "syp_price": sypPrice,
      "km_number": kmNumber,
      "duration": duration,
      "User": user.toJson(),
    };
  }
}
