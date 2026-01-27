import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mishwar/Constant/Apis.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/presentation/profile/model/profile_model.dart';

class ApiRepository {
  final Dio _dio;

  ApiRepository({Dio? dio}) : _dio = dio ?? Dio();

  // ====================== LOGIN ======================
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.login(),
      data: {
        'phone_number': phone.trim(),
        'password': password.trim(),
        'remember_me': true,
      },
      options: Options(
        headers: {'Accept': 'application/json'},
        contentType: Headers.jsonContentType,
      ),
    );

    return response.data;
  }

  // ====================== REFRESH TOKEN ======================
  Future<Map<String, dynamic>> refreshToken({required String token}) async {
    try {
      final formData = FormData.fromMap({'token': token});

      final response = await _dio.post(
        ApiConstants.refreshToken(),
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ====================== REGISTER ======================
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required File? photo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name.trim(),
        'phone_number': phone.trim(),
        'password': password.trim(),
        'password_confirmation': passwordConfirmation.trim(),
        if (photo != null)
          'photo': await MultipartFile.fromFile(
            photo.path,
            filename: 'profile.jpg',
          ),
      });

      final response = await _dio.post(
        ApiConstants.register(),
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ====================== VERIFY PHONE ======================
  Future<Map<String, dynamic>> verifyPhone({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyPhone(),
        data: {'phone_number': phoneNumber.trim(), 'otp': code.trim()},
        options: Options(
          headers: {'Accept': 'application/json'},
          contentType: Headers.jsonContentType,
        ),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ====================== RESEND CODE ======================
  Future<Map<String, dynamic>> resendCode({required String phoneNumber}) async {
    try {
      final response = await _dio.post(
        ApiConstants.resendCode(),
        data: {'phone_number': phoneNumber.trim()},
        options: Options(
          headers: {'Accept': 'application/json'},
          contentType: Headers.jsonContentType,
        ),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ====================== FORGET PASSWORD ======================
  Future<Map<String, dynamic>> forget({required String phone}) async {
    try {
      final formData = FormData.fromMap({'phone_number': phone.trim()});

      final response = await _dio.post(
        ApiConstants.forgetPassword(),
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ====================== RESET PASSWORD ======================
  Future<Map<String, dynamic>> resetPassword({
    required String phoneNumber,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final formData = FormData.fromMap({
        'phone_number': phoneNumber.trim(),
        'otp': otp.trim(),
        'password': password.trim(),
        'password_confirmation': passwordConfirmation.trim(),
      });

      final response = await _dio.post(
        ApiConstants.resetPassword(),
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ====================== GET PROFILE ======================
  Future<ProfileModel> getProfile(int id) async {
    final token = CacheHelper.getData(key: "token");
    print("🔍 Fetching profile for user_id: $id");
    print("🔍 Token: $token");
    print("🔍 Full URL: ${ApiConstants.getProfile()}");
    final response = await _dio.get(
      ApiConstants.getProfile(),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['successful'] == true) {
      return ProfileModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  // ====================== UPDATE PROFILE ======================
  Future<Map<String, dynamic>> updateDriverProfile({
    String? name,
    String? phoneNumber,
    File? photo,
  }) async {
    try {
      final token = CacheHelper.getData(key: "token");

      final formData = FormData.fromMap({
        if (name != null) 'name': name,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (photo != null)
          'photo': await MultipartFile.fromFile(
            photo.path,
            filename: 'profile.jpg',
          ),
      });

      final response = await _dio.post(
        ApiConstants.updateProfile(),
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      return response.data;
    } catch (e) {
      print("❌ [updateDriverProfile] Error: $e");
      return {
        "successful": false,
        "message": "حدث خطأ أثناء تحديث الملف الشخصي",
      };
    }
  }

  // ====================== LOGOUT ======================
  Future<Map<String, dynamic>> logout({required String token}) async {
    try {
      final response = await _dio.post(
        ApiConstants.logout(),
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

  //// ====================== DELETE ACCOUNT ======================
  // ====================== DELETE ACCOUNT - المعدل ======================
  Future<Map<String, dynamic>> deleteAccount({required dynamic userId}) async {
    try {
      final token = CacheHelper.getToken();
      final url = ApiConstants.deleteAccount(); // ⬅️ بدون userId

      print("🔑 [DeleteAccount] Token المستخدم: $token");
      print("🌐 [DeleteAccount] URL الكامل: $url");
      print("🆔 [DeleteAccount] User ID: $userId");
      print("📤 [DeleteAccount] إرسال طلب DELETE...");

      final response = await _dio.delete(
        url,
        data: {
          'user_id': userId, // ⬅️ إرسال userId في الـ body
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("✅ [DeleteAccount] الاستجابة: ${response.data}");
      return response.data;
    } catch (e) {
      print("❌ [DeleteAccount] خطأ: $e");
      rethrow;
    }
  }
}
