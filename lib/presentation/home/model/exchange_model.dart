class ExchangeResponse {
  final bool? successful;
  final String? message;
  final ExchangeData? data;
  final int? statusCode;

  ExchangeResponse({
    this.successful,
    this.message,
    this.data,
    this.statusCode,
  });

  factory ExchangeResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeResponse(
      successful: json['successful'],
      message: json['message'],
      statusCode: json['status_code'],
      data: json['data'] != null
          ? ExchangeData.fromJson(json['data'])
          : null,
    );
  }
}

class ExchangeData {
  final Exchange? exchange;

  ExchangeData({this.exchange});

  factory ExchangeData.fromJson(Map<String, dynamic> json) {
    return ExchangeData(
      exchange:
          json['exchange'] != null ? Exchange.fromJson(json['exchange']) : null,
    );
  }
}

class Exchange {
  final int id;
  final double dollarPrice;
  final double generalTripPercentage;
  final double kmCost;
  final double minCost;

  final List<VehicleType> vehicleTypes;

  Exchange({
    required this.id,
    required this.dollarPrice,
    required this.generalTripPercentage,
    required this.kmCost,
    required this.minCost,
    required this.vehicleTypes,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['id'],
      dollarPrice: (json['dollar_price']).toDouble(),
      generalTripPercentage: json['general_trip_percentage'].toDouble(),
      kmCost: json['km_cost'].toDouble(),
      minCost: json['min_cost'].toDouble(),

      vehicleTypes: (json['vehicle_types'] as List)
          .map((e) => VehicleType.fromJson(e))
          .toList(),
    );
  }
}

class VehicleType {
  final int id;
  final double vehicleTypePercentage;
  final String vehicleType;

  VehicleType({
    required this.id,
    required this.vehicleTypePercentage,
    required this.vehicleType,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['id'],
      vehicleTypePercentage: json['vehicle_type_percentage'].toDouble(),
      vehicleType: json['vehicle_type'],
    );
  }
}
