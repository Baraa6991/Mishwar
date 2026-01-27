import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/Constant/Apis.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/forget_password/cubit/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ApiRepository repository;

  ForgetPasswordCubit({required this.repository}) : super(ForgetInitial());

  Future<void> register({required String phone}) async {
    emit(ForgetLoading());
    debugPrint('🔹 Forget password started...');
    debugPrint('📞 Phone: $phone');
    debugPrint('📞 Phone: ${ApiConstants.forgetPassword()}');

    try {
      final data = await repository.forget(phone: phone);

      debugPrint('📨 Response data: $data');

      if (data['successful'] == true) {
        emit(
          ForgetSuccess(
            message: data['message'] ?? S.current.ForgetPasswordSuccess,
          ),
        );
      } else {
        emit(
          ForgetError(
            message: data['message'] ?? S.current.ForgetPasswordFailed,
          ),
        );
      }
    } catch (e) {
      debugPrint('💥 Forget password error: $e');
      emit(ForgetError(message: S.current.ErrorServer));
    }
  }
}
