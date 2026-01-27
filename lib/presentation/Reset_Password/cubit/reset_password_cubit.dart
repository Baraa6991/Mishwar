import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ApiRepository repository;

  ResetPasswordCubit({required this.repository}) : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String phoneNumber,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ResetPasswordLoading());
    debugPrint('🔹 Reset Password started...');
    debugPrint('📞 Phone: $phoneNumber');
    debugPrint('🔑 OTP: $otp');
    debugPrint('🔒 Password: $password');

    try {
      final data = await repository.resetPassword(
        phoneNumber: phoneNumber,
        otp: otp,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      debugPrint('📨 Response data: $data');

      if (data['successful'] == true) {
        emit(ResetPasswordSuccess(message: data['message'] ?? S.current.PasswordResetSuccess));
      } else {
        emit(ResetPasswordError(message: data['message'] ?? S.current.PasswordResetFailed));
      }
    } catch (e) {
      debugPrint('💥 Reset Password error: $e');
      emit(ResetPasswordError(message: S.current.PasswordResetFailed));
    }
  }
}
