import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';
import 'package:mishwar/presentation/home/cubit/check_end_state.dart';

class CheckEndCubit extends Cubit<CheckEndState> {
  final ApiTripRepository repo;
  Timer? _timer;

  CheckEndCubit(this.repo) : super(CheckEndInitial());

  void startCheckingTrip(int tripId) {
  if (state is CheckEndStopped) return; // ✅ لا تسمح له بالعمل بعد التوقف

  dev.log("[CheckEndCubit] Start checking tripId: $tripId");

  emit(CheckEndLoading());

  fetchTripDetails(tripId);

  _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    if (state is CheckEndStopped) timer.cancel(); // ✅ أوقف المؤقت نهائيًا
    fetchTripDetails(tripId);
  });
}


  Future<void> fetchTripDetails(int tripId) async {
    try {
      dev.log("[CheckEndCubit] Fetching trip details for ID: $tripId");

      final data = await repo.getTripDetails(tripId: tripId);

      dev.log("[CheckEndCubit] Response: $data");

      if (data["successful"] == true) {
        final trip = data["data"]["Trip"];
        dev.log("[CheckEndCubit] Trip status: ${trip['trip_status']}");

        emit(CheckEndSuccess(checkEndData: trip));
      } else {
        dev.log("[CheckEndCubit] Backend returned error: ${data['message']}");
        emit(CheckEndError(data["message"] ?? "Failed to fetch trip details"));
      }
    } catch (e, s) {
      dev.log("[CheckEndCubit] Exception: $e\nStack: $s");
      emit(CheckEndError("Error fetching trip details"));
    }
  }

  void stopChecking() {
  dev.log("[CheckEndCubit] Stopping timer...");
  _timer?.cancel();
  _timer = null;
  emit(CheckEndStopped()); // ✅ نطلق حالة توقف نهائية
}


  @override
  Future<void> close() {
    dev.log("[CheckEndCubit] Cubit closed, cancelling timer...");
    _timer?.cancel();
    return super.close();
  }
}
