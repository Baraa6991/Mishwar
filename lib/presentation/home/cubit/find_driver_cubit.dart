import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/home/cubit/check_end_cubit.dart';
import 'package:mishwar/presentation/home/cubit/find_driver_state.dart';

class FindDriversCubit extends Cubit<FindDriversState> {
  final ApiTripRepository repository;
  final CheckEndCubit checkEndCubit;

  FindDriversCubit({required this.repository, required this.checkEndCubit})
      : super(FindDriversInitial());

  Future<void> findDrivers({
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
    emit(FindDriversLoading());
    
    debugPrint('🔹 Finding drivers started...');
    debugPrint('📍 user: $userId');
    debugPrint('📍 Source: $sourceList');
    debugPrint('🎯 Destination: $destinationList');
    debugPrint('🚗 Vehicle ID: $vehicleClassificationsId');
    debugPrint('💰 Price: \$$dollarPrice');
    debugPrint('💰 s: \$$sysPrice');
    debugPrint('💰 k: \$$kmNumber');
    debugPrint('💰 d: \$$duration');

    try {
      final data = await repository.findDrivers(
        sourceList: sourceList,
        sourceIon: sourceIon,
        userId: userId,
        vehicleClassificationsId: vehicleClassificationsId,
        destinationList: destinationList,
        destinationIon: destinationIon,
        dollarPrice: dollarPrice,
        sysPrice: sysPrice,
        kmNumber: kmNumber,
        duration: duration,
      );

      debugPrint('📨 Find drivers response: $data');

      if (data['successful'] == true) {
        emit(
          FindDriversSuccess(
            message: data['message'] ?? S.current.findDriversSuccess,
          ),
        );
        
        // ✅ لا تستدعي checkEndCubit هنا
        // سيتم استدعاؤه من CheckTripStatusCubit عندما يتم قبول الرحلة
        // لأن trip_id غير موجود في هذه الاستجابة
        
        debugPrint('✅ Request sent to driver successfully');
      } else {
        emit(
          FindDriversError(
            message: data['message'] ?? S.current.findDriversFailed,
          ),
        );
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        debugPrint("📌 Server Validation Error: ${e.response?.data}");
      }
      debugPrint("❌ Error finding drivers: $e");
      debugPrint("Stack trace: $stackTrace");
      
      emit(FindDriversError(message: S.current.findDriversFailed));
    }
  }
}

class CheckTripStatusCubit extends Cubit<CheckTripStatusState> {
  final ApiTripRepository repo;
  Timer? _timer;

  CheckTripStatusCubit(this.repo) : super(CheckTripInitial());

  void startCheckingStatus(String userId) {
    debugPrint('🔍 Starting to check trip status for user: $userId');
    emit(CheckTripLoading());
    
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        debugPrint('⏱️ Checking trip status...');
        final data = await repo.checkTripStatus(userId: userId);
        
        debugPrint('📨 Trip status response: $data');

        if (data['data']['status'] == "accept") {
          final tripId = data['data']['trip_id'];
          final driver = data['data']['Driver'];
          
          debugPrint('✅ Trip accepted! Trip ID: $tripId');
          
          await CacheHelper.saveData(key: "trip_id", value: tripId);
          
          emit(CheckTripAccepted(tripId: tripId, driverData: driver));
          
          timer.cancel();
        } else {
          debugPrint('⏳ Still waiting for driver acceptance...');
          emit(CheckTripWaiting());
        }
      } catch (e, stackTrace) {
        debugPrint('❌ Error checking trip status: $e');
        debugPrint('Stack trace: $stackTrace');
        emit(CheckTripError("خطأ أثناء التحقق من حالة الرحلة"));
      }
    });
  }

  void stopChecking() {
    debugPrint('🛑 Stopping trip status check');
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}