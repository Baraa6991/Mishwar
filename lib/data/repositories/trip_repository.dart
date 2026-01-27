import 'package:dio/dio.dart';
import 'package:mishwar/Constant/Apis.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/presentation/home/model/exchange_model.dart';
import 'package:mishwar/presentation/home/model/vehicle_model.dart';
import 'package:mishwar/presentation/old_trips/model/old_trip_model.dart';

class ApiTripRepository {
  final Dio _dio;
  ApiTripRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 450),
              receiveTimeout: const Duration(seconds: 450),
              headers: {'Accept': 'application/json'},
            ),
          );

  /// ====================== VEHICLES ======================
  Future<VehicleClassificationsResponse> getVehicleClassifications({
    String languageCode = 'ar',
  }) async {
    final response = await _dio.get(
      ApiConstants.getVehicleClassifications(),
      options: Options(headers: {'lang': languageCode}),
    );
    return VehicleClassificationsResponse.fromJson(response.data, languageCode);
  }

  /// ====================== EXCHANGE ======================
  Future<ExchangeResponse> getExchange() async {
    try {
      final token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception("Token not found");
      }

      final response = await _dio.get(
        ApiConstants.getExchangeDollar(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return ExchangeResponse.fromJson(response.data);
      } else {
        throw Exception(
          "Failed to fetch exchange data. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("⚠️ [getExchange] Error fetching exchange: $e");
      rethrow;
    }
  }

  /// ====================== FIND DRIVERS ======================
  Future<Map<String, dynamic>> findDrivers({
    required List<double> sourceList,
    required String sourceIon,
    required String userId,
    required String vehicleClassificationsId,
    required List<double> destinationList,
    required String destinationIon,
    required double dollarPrice,
    required double sysPrice,
    required double kmNumber,
    required double duration,
  }) async {
    try {
      final token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception("Token not found");
      }

      final response = await _dio.post(
        ApiConstants.findDriver(),
        data: {
          'source_lat': sourceList[0],
          'source_lon': sourceList[1],
          'user_id': userId,
          'vehicle_classifications_id': vehicleClassificationsId,
          'destination_lat': destinationList[0],
          'destination_lon': destinationList[1],
          'dollar_price': dollarPrice,
          'syp_price': sysPrice,
          'km_number': kmNumber,
          'duration': duration,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> cancelTrip({String? tripId}) async {
    final userId = CacheHelper.getUserId()?.toString();
    if (userId == null) {
      throw Exception("User ID not found in cache");
    }

    // بناء الـ data بشكل ديناميكي
    final data = {'user_id': userId, 'cancelled_by': 'user'};

    // إضافة trip_id فقط إذا كان موجوداً وليس فارغاً
    if (tripId != null && tripId.isNotEmpty && tripId != 'null') {
      data['trip_id'] = tripId;
    }

    final token = CacheHelper.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await _dio.post(
      ApiConstants.cancelTrip(),
      data: data,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> checkTripStatus({required String userId}) async {
    final token = CacheHelper.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await _dio.post(
      ApiConstants.checkTripStatus(),
      data: {"user_id": userId},
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getTripDetails({required int tripId}) async {
    try {
      final token = CacheHelper.getToken();
      if (token == null) throw Exception("Token not found");

      final response = await _dio.get(
        ApiConstants.checkTripStatusUserToEnd(tripId),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Map<String, dynamic>> rateTrip({
  //   required int tripId,
  //   required int userId,
  //   required int driverId,
  //   required double rating,
  //   String? comment,
  // }) async {
  //   final token = CacheHelper.getData(key: "token");

  //   FormData formData = FormData.fromMap({
  //     "trip_id": tripId,
  //     "user_id": userId,
  //     "driver_id": driverId,
  //     "rating": rating.round(),
  //     "comment": comment ?? "",
  //   });

  //   print("📤 Sending RateTrip data:");
  //   print("info_id: $tripId");
  //   print("tabu_id: $userId");
  //   print("dhvw_i_id: $driverId");
  //   print("rating: $rating");
  //   print("comment: ${comment ?? ''}");
  //   print("token: $token");

  //   try {
  //     final response = await _dio.post(
  //       ApiConstants.createExpression(),
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $token",
  //           "Content-Type": "multipart/form-data",
  //           "Accept": "application/json",
  //         },
  //         validateStatus: (status) {
  //           return status! < 500;
  //         },
  //       ),
  //     );

  //     print("📥 RateTrip Response: ${response.statusCode}");
  //     print("📥 Response Data: ${response.data}");

  //     if (response.statusCode == 400) {
  //       throw DioException(
  //         requestOptions: response.requestOptions,
  //         response: response,
  //         error: "Bad Request: ${response.data}",
  //       );
  //     }

  //     return response.data;
  //   } on DioException catch (e) {
  //     print("❌ Dio Error: ${e.message}");
  //     print("❌ Response: ${e.response?.data}");
  //     rethrow;
  //   }
  // }
  Future<Map<String, dynamic>> rateTrip({
    required int tripId,
    required int userId,
    required int driverId,
    required double rating,
    String? comment,
  }) async {
    final token = CacheHelper.getData(key: "token");

    FormData formData = FormData.fromMap({
      "trip_id": tripId,
      "user_id": userId,
      "driver_id": driverId,
      "rating": rating.round(),
      "user_comment": comment ?? "",
    });

    print("📤 Sending RateTrip data:");
    print("info_id: $tripId");
    print("tabu_id: $userId");
    print("dhvw_i_id: $driverId");
    print("rating: $rating");
    print("comment: ${comment ?? ''}");
    print("token: $token");

    try {
      final response = await _dio.post(
        ApiConstants.createExpression(),
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      print("📥 RateTrip Response: ${response.statusCode}");
      print("📥 Response Data: ${response.data}");

      if (response.statusCode == 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Bad Request: ${response.data}",
        );
      }

      return response.data;
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.message}");
      print("❌ Response: ${e.response?.data}");
      rethrow;
    }
  }

  Future<TripHistoryResponse> getDriverTrips(int driverId) async {
    final token = CacheHelper.getData(key: "token");

    final response = await _dio.get(
      ApiConstants.oldTrip(driverId),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return TripHistoryResponse.fromJson(response.data);
  }
}
