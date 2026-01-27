class TripHistoryResponse {
  final bool successful;
  final String message;
  final TripHistoryData data;
  final int statusCode;
  TripHistoryResponse({
    required this.successful,
    required this.message,
    required this.data,
    required this.statusCode,
  });
  factory TripHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TripHistoryResponse(
      successful: json["successful"] ?? false,
      message: json["message"] ?? "",
      data: TripHistoryData.fromJson(json["data"]),
      statusCode: json["status_code"] ?? 0,
    );
  }
}

class TripHistoryData {
  final List<TripItem> trips;
  TripHistoryData({required this.trips});
  factory TripHistoryData.fromJson(Map<String, dynamic> json) {
    return TripHistoryData(
      trips: (json["Trips"] as List).map((e) => TripItem.fromJson(e)).toList(),
    );
  }
}

class TripItem {
  final int id;
  final String tripStatus;
  final String sourceLat;
  final String sourceLon;
  final String destinationLat;
  final String destinationLon;
  final String dollarPrice;
  final String sypPrice;
  final String tripRating;
  final int duration;
  final String kmNumber;
  final UserModel user;
  final DriverModel driver;
  final VehicleModel vehicle;
  TripItem({
    required this.id,
    required this.tripStatus,
    required this.sourceLat,
    required this.sourceLon,
    required this.destinationLat,
    required this.destinationLon,
    required this.dollarPrice,
    required this.sypPrice,
    required this.tripRating,
    required this.duration,
    required this.kmNumber,
    required this.user,
    required this.driver,
    required this.vehicle,
  });
  factory TripItem.fromJson(Map<String, dynamic> json) {
    return TripItem(
      id: json["id"],
      tripStatus: json["trip_status"] ?? "",
      sourceLat: json["source_lat"] ?? "",
      sourceLon: json["source_lon"] ?? "",
      destinationLat: json["destination_lat"] ?? "",
      destinationLon: json["destination_lon"] ?? "",
      dollarPrice: json["dollar_price"] ?? "",
      sypPrice: json["syp_price"] ?? "",
      tripRating: json["trip_rating"] ?? "",
      duration: json["duration"] ?? 0,
      kmNumber: json["km_number"] ?? "",
      user: UserModel.fromJson(json["user"]),
      driver: DriverModel.fromJson(json["driver"]),
      vehicle: VehicleModel.fromJson(json["vehicle"]),
    );
  }
}

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
      id: json["id"],
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      photo: json["photo"] ?? "",
      rating: (json["rating"] ?? 0).toDouble(),
      role: json["role"] ?? "",
    );
  }
}

class DriverModel {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String photo;
  final double rating;
  final String role;
  final int walletSyp;
  final int walletDollar;
  final String certificateImage;
  final String backPersonalImage;
  final String frontPersonalImage;
  final VehicleDetailsModel vehicleDetails;
  DriverModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.photo,
    required this.rating,
    required this.role,
    required this.walletSyp,
    required this.walletDollar,
    required this.certificateImage,
    required this.backPersonalImage,
    required this.frontPersonalImage,
    required this.vehicleDetails,
  });
  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json["id"],
      userId: json["user_id"],
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      photo: json["photo"] ?? "",
      rating: (json["rating"] ?? 0).toDouble(),
      role: json["role"] ?? "",
      walletSyp: json["wallet_syp"] ?? 0,
      walletDollar: json["wallet_dollar"] ?? 0,
      certificateImage: json["certificateImage"] ?? "",
      backPersonalImage: json["backPersonalImage"] ?? "",
      frontPersonalImage: json["frontPersonalImage"] ?? "",
      vehicleDetails: VehicleDetailsModel.fromJson(json["vehicle_Details"]),
    );
  }
}

class VehicleDetailsModel {
  final int id;
  final String number;
  final String type;
  final String model;
  final String frontImage;
  final String behindImage;
  final String papersImage;
  final String modelDate;
  final String status;
  final String vehicleType;
  VehicleDetailsModel({
    required this.id,
    required this.number,
    required this.type,
    required this.model,
    required this.frontImage,
    required this.behindImage,
    required this.papersImage,
    required this.modelDate,
    required this.status,
    required this.vehicleType,
  });
  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    return VehicleDetailsModel(
      id: json["id"],
      number: json["number"] ?? "",
      type: json["type"] ?? "",
      model: json["model"] ?? "",
      frontImage: json["frontImage"] ?? "",
      behindImage: json["behindImage"] ?? "",
      papersImage: json["PapersImage"] ?? "",
      modelDate: json["ModelDate"] ?? "",
      status: json["status"] ?? "",
      vehicleType: json["vehicle_type"] ?? "",
    );
  }
}

class VehicleModel {
  final int id;
  final String number;
  final String type;
  final String model;
  final String frontImage;
  final String behindImage;
  final String papersImage;
  final String modelDate;
  final String status;
  final String vehicleType;
  VehicleModel({
    required this.id,
    required this.number,
    required this.type,
    required this.model,
    required this.frontImage,
    required this.behindImage,
    required this.papersImage,
    required this.modelDate,
    required this.status,
    required this.vehicleType,
  });
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json["id"],
      number: json["number"] ?? "",
      type: json["type"] ?? "",
      model: json["model"] ?? "",
      frontImage: json["frontImage"] ?? "",
      behindImage: json["behindImage"] ?? "",
      papersImage: json["PapersImage"] ?? "",
      modelDate: json["ModelDate"] ?? "",
      status: json["status"] ?? "",
      vehicleType: json["vehicle_type"] ?? "",
    );
  }
}
