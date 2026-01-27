import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/viryFicition_code/cubit/viryfiy_state.dart';


class VerificationCubit extends Cubit<VerificationState> {
  final ApiRepository repository;

  VerificationCubit({required this.repository}) : super(VerificationInitial());

  Future<void> verifyPhone({
    required String phoneNumber,
    required String code,
    required String fcmToken,
  }) async {
    emit(VerificationLoading());
    debugPrint('🔹 Phone verification started...');
    debugPrint('📞 Phone: $phoneNumber');
    debugPrint('🔢 Code: $code');
    debugPrint('📱 FCM Token: $fcmToken');

    try {
      final data = await repository.verifyPhone(
        phoneNumber: phoneNumber,
        code: code,
        // fcmToken: fcmToken,
      );
      
      debugPrint('📨 Verification response: $data');

      if (data['successful'] == true) {
        final userData = data['data']['user'];
        final token = data['data']['token'];

        // ✅ تخزين بيانات المستخدم في الكاش
        await CacheHelper.saveData(key: "token", value: token);
        await CacheHelper.saveData(key: "user_id", value: userData['id']);
        await CacheHelper.saveData(key: "user_name", value: userData['name']);
        await CacheHelper.saveData(key: "user_phone", value: userData['phone']);
        if (userData['photo'] != null) {
          await CacheHelper.saveData(key: "user_photo", value: userData['photo']);
        }
        emit(VerificationSuccess(
          message: data['message'] ?? S.current.VerificationSuccess,
          userData: userData,
        ));
      } else {
        emit(VerificationError(
          message: data['message'] ?? S.current.VerificationFailed,
        ));
      }
    } catch (e) {
      debugPrint('💥 Verification error: $e');
      emit(VerificationError(message: S.current.VerificationFailed));
    }
  }

  Future<void> resendCode({
    required String phoneNumber,
  }) async {
    emit(ResendCodeLoading());
    debugPrint('🔹 Resending code to: $phoneNumber');

    try {
      final data = await repository.resendCode(phoneNumber: phoneNumber);
      
      debugPrint('📨 Resend code response: $data');

      if (data['successful'] == true) {
        emit(ResendCodeSuccess(
          message: data['message'] ?? S.current.ResendCodeSuccess,
        ));
      } else {
        emit(VerificationError(
          message: data['message'] ?? S.current.ResendCodeFailed,
        ));
      }
    } catch (e) {
      debugPrint('💥 Resend code error: $e');
      emit(VerificationError(message: S.current.ResendCodeFailed));
    }
  }
}