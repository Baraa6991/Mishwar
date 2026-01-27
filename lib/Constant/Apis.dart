import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final baseUrl = dotenv.env['BASE_URL']!;
  static final googleKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  static String tripDetails(int tripId) => '$baseUrl/trips/$tripId';
  static String startTrip(int tripId) => '$baseUrl/trips/$tripId/start';
  static String endTrip(int tripId) => '$baseUrl/trips/$tripId/end';
  static String login() => '$baseUrl/users/login';
  static String register() => '$baseUrl/users/register';
  static String verifyPhone() => '$baseUrl/users/phoneVerify';
  static String resendCode() => '$baseUrl/users/resendOTP?subject=phoneVerify';
  static String forgetPassword() => '$baseUrl/users/forgetPassword';
  static String resetPassword() => '$baseUrl/users/resetPassword';
  static String refreshToken() => '$baseUrl/users/refreshToken';
  static String getProfile() => '$baseUrl/users/profile/';
  static String updateProfile() => '$baseUrl/users/update';
  static String logout() => '$baseUrl/users/logout';
  static String deleteAccount() => '$baseUrl/users/delete';
  static String getVehicleClassifications() =>
      '$baseUrl/vehicleClassifications';
  static String getExchangeDollar() => '$baseUrl/exchanges/dollar';
  static String findDriver() => '$baseUrl/driver_location/find_drivers';
  static String cancelTrip() => '$baseUrl/driver_location/cancel_trip';
  static String checkTripStatus() => '$baseUrl/driver_location/check_status';
  static String checkTripStatusUserToEnd(int id) => '$baseUrl/trips/$id';
  static String createExpression() => '$baseUrl/expressions';
  static String oldTrip(int id) => '$baseUrl/trips/user/$id';
}
