import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/login/cubit/TokenManager.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final ApiRepository repository;

  LogoutCubit({required this.repository}) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    debugPrint('🔹 Logout started...');

    try {
      final token = CacheHelper.getData(key: 'token');
      if (token == null) throw Exception('Token not found');

      final data = await repository.logout(token: token);

      debugPrint('📨 Response data: $data');

      if (data['successful'] == true) {
        // ✅ إيقاف TokenManager قبل مسح الكاش
        debugPrint('🛑 Stopping TokenManager...');
        TokenManager.instance.stopAutoRefresh();
        
        // مسح جميع البيانات
        await CacheHelper.removeAllData();
        debugPrint('🧹 All cache data cleared');
        
        emit(LogoutSuccess(message: data['message'] ?? S.current.Logout));
      } else {
        emit(
          LogoutError(message: data['message'] ?? S.current.ErrorUnexpected),
        );
      }
    } catch (e) {
      debugPrint('💥 Logout error: $e');
      emit(LogoutError(message: S.current.ErrorUnexpected));
    }
  }
}