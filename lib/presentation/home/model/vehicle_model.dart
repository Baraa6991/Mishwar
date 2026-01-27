class VehicleClassificationsResponse {
  final bool successful;
  final String message;
  final List<VehicleClassification> vehicleClassifications;
  final int totalPages;
  final int currentPage;
  final bool hasMorePages;

  VehicleClassificationsResponse({
    required this.successful,
    required this.message,
    required this.vehicleClassifications,
    required this.totalPages,
    required this.currentPage,
    required this.hasMorePages,
  });

  factory VehicleClassificationsResponse.fromJson(
      Map<String, dynamic> json, String languageCode) {
    final data = json['data'] ?? {};
    final classifications = (data['VehicleClassifications'] as List<dynamic>?)
            ?.map((e) => VehicleClassification.fromJson(e, languageCode))
            .toList() ??
        [];

    return VehicleClassificationsResponse(
      successful: json['successful'] ?? false,
      message: json['message'] ?? '',
      vehicleClassifications: classifications,
      totalPages: data['total_pages'] ?? 0,
      currentPage: data['current_page'] ?? 0,
      hasMorePages: data['hasMorePages'] ?? false,
    );
  }
}

class VehicleClassification {
  final int id;
  final String vehicleType;
  final String displayName;
  final String priceKey;
  final String vehicleImage;

  VehicleClassification({
    required this.id,
    required this.vehicleType,
    required this.displayName,
    required this.priceKey,
    required this.vehicleImage,
  });

  factory VehicleClassification.fromJson(Map<String, dynamic> json, String lang) {
    String vehicleType = json['vehicle_type'] ?? '';
    String priceKey = lang == 'ar'
        ? _arabicToEnglish[vehicleType] ?? vehicleType
        : vehicleType;

    String vehicleImage = _getVehicleImage(priceKey);

    return VehicleClassification(
      id: json['id'] ?? 0,
      vehicleType: vehicleType,
      displayName: vehicleType,
      priceKey: priceKey,
      vehicleImage: vehicleImage,
    );
  }

  // خريطة تحويل من عربي لإنجليزي
  static const Map<String, String> _arabicToEnglish = {
    'دراجة نارية': 'bike',
    'سيارة بمكيف': 'car with ac',
    'سيارة بدون مكيف': 'car without ac',
    'سيارة فاخرة': 'luxury car',
    'شاحنة صغيرة': 'mini truck',
    'فان': 'van',
  };

  // خريطة الصور لكل نوع مركبة
  static const Map<String, String> _vehicleImages = {
    'bike': 'assets/Bike.jpg',
    'car with ac': 'assets/with Ac.jpg',
    'car without ac': 'assets/No AC.jpg',
    'luxury car': 'assets/Luxury.jpg',
    'mini truck': 'assets/Suzuki.jpg',
    'van': 'assets/Mini Van.jpg',
  };

  // دالة للحصول على مسار الصورة
  static String _getVehicleImage(String vehicleKey) {
    return _vehicleImages[vehicleKey.toLowerCase()] ?? 'assets/مشوار.png';
  }
}