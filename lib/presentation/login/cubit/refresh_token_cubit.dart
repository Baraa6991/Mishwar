import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';

part 'refresh_token_state.dart';

class RefreshTokenCubit extends Cubit<RefreshTokenState> {
  final ApiRepository repository;

  RefreshTokenCubit({required this.repository}) : super(RefreshTokenInitial());

  Future<void> refreshToken() async {
    emit(RefreshTokenLoading());
    try {
      final oldToken = CacheHelper.getData(key: "token");

      if (oldToken == null) {
        emit(RefreshTokenError(message: S.current.ErrorUnauthorized));
        return;
      }

      debugPrint('🔄 Refreshing token...');
      final response = await repository.refreshToken(token: oldToken);
      debugPrint('📨 Refresh response: $response');

      if (response['successful'] == true && response['data'] != null) {
        final newToken = response['data']['token'];
        await CacheHelper.saveData(key: "token", value: newToken);
        emit(RefreshTokenSuccess(message: S.current.TokenRefreshed));
      } else {
        emit(RefreshTokenError(message: S.current.ErrorUnauthorized));
      }
    } catch (e) {
      debugPrint('💥 Refresh token error: $e');
      emit(RefreshTokenError(message: S.current.ErrorServer));
    }
  }
}
