import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/login/cubit/TokenManager.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final ApiRepository repository;

  LoginCubit({required this.repository}) : super(LoginInitial());

  Future<void> login({required String phone, required String password}) async {
    emit(LoginLoading());
    debugPrint('🔹 Login started...');
    debugPrint('📞 Phone: $phone | 🔒 Password: $password');

    try {
      final data = await repository.login(phone: phone, password: password);
      debugPrint('📨 Response data: $data');

      if (data['successful'] == true) {
        final token = data['data']['token'];
        final user = data['data']['user'];

        await CacheHelper.saveData(key: "token", value: token);
        await CacheHelper.saveData(key: "user_id", value: user['id']);
        await CacheHelper.saveData(key: "user_name", value: user['name']);
        await CacheHelper.saveData(key: "user_phone", value: user['phone']);
        
        // ✅ بدء تحديث Token التلقائي كل 20 دقيقة
        TokenManager.instance.startAutoRefresh(intervalMinutes: 20);

        emit(LoginSuccess(message: S.current.LoginSuccess));
      } else {
        emit(LoginError(message: S.current.LoginFailed));
      }
    } catch (e) {
      debugPrint('💥 Unexpected error: $e');
      emit(LoginError(message: S.current.LoginFailed));
    }
  }
}