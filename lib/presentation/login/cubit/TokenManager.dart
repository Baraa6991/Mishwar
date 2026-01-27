import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';

class TokenManager {
  static TokenManager? _instance;
  Timer? _refreshTimer;
  final ApiRepository _repository = ApiRepository();

  TokenManager._();
  
  static TokenManager get instance {
    _instance ??= TokenManager._();
    return _instance!;
  }
  void startAutoRefresh({int intervalMinutes = 20}) {
    debugPrint('🔄 [TokenManager] بدء تحديث Token التلقائي كل $intervalMinutes دقيقة');
    
    stopAutoRefresh();
    
    _refreshTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
      (timer) async {
        debugPrint('⏰ [TokenManager] حان وقت تحديث Token...');
        await _performRefresh();
      },
    );
    
    _performRefresh();
  }

  Future<void> _performRefresh() async {
    try {
      final oldToken = CacheHelper.getData(key: "token");
      
      if (oldToken == null) {
        debugPrint('❌ [TokenManager] لا يوجد token للتحديث');
        return;
      }

      debugPrint('🔄 [TokenManager] جاري تحديث Token...');
      final response = await _repository.refreshToken(token: oldToken);
      
      if (response['successful'] == true && response['data'] != null) {
        final newToken = response['data']['token'];
        await CacheHelper.saveData(key: "token", value: newToken);
        debugPrint('✅ [TokenManager] تم تحديث Token بنجاح');
      } else {
        debugPrint('❌ [TokenManager] فشل تحديث Token');
      }
    } catch (e) {
      debugPrint('💥 [TokenManager] خطأ في تحديث Token: $e');
    }
  }

  void stopAutoRefresh() {
    if (_refreshTimer != null) {
      debugPrint('🛑 [TokenManager] إيقاف تحديث Token التلقائي');
      _refreshTimer?.cancel();
      _refreshTimer = null;
    }
  }

  Future<void> manualRefresh() async {
    debugPrint('🔄 [TokenManager] تحديث يدوي للـ Token');
    await _performRefresh();
  }
}