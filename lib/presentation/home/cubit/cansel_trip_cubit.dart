import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';
import 'package:mishwar/presentation/home/cubit/cansel_trip_state.dart';

class CancelTripCubit extends Cubit<CancelTripState> {
  final ApiTripRepository repository;

  CancelTripCubit(this.repository) : super(CancelTripInitial());

  Future<void> cancelTrip({String? tripId}) async {
    dev.log("[CancelTripCubit] cancelTrip called with tripId: $tripId");

    emit(CancelTripLoading());
    dev.log("[CancelTripCubit] State emitted: CancelTripLoading");

    try {
      // محاولة جلب tripId من الكاش إذا لم يُرسل
      String? tripIdToSend = tripId;

      if (tripIdToSend == null) {
        final cachedTripId = CacheHelper.getData(key: "trip_id");
        if (cachedTripId != null) {
          // تحويل أي نوع بيانات (int أو String) إلى String
          tripIdToSend = cachedTripId.toString();
          
          // التحقق من أن القيمة ليست 'null' كنص
          if (tripIdToSend == 'null' || tripIdToSend.isEmpty) {
            tripIdToSend = null;
            dev.log("[CancelTripCubit] Cached tripId is null or empty");
          } else {
            dev.log("[CancelTripCubit] tripId fetched from cache: $tripIdToSend");
          }
        } else {
          dev.log("[CancelTripCubit] No tripId found in cache");
        }
      }

      dev.log("[CancelTripCubit] tripId to send: $tripIdToSend");

      dev.log("[CancelTripCubit] Calling repository.cancelTrip...");
      final response = await repository.cancelTrip(tripId: tripIdToSend);

      dev.log(
        "[CancelTripCubit] API response received: ${response.toString()}",
      );

      final message = response['message'] ?? 'Trip cancelled successfully';
      dev.log("[CancelTripCubit] Emitting success message: $message");
      emit(CancelTripSuccess(message));
      dev.log("[CancelTripCubit] State emitted: CancelTripSuccess");
    } catch (e, stackTrace) {
      dev.log("[CancelTripCubit] Error occurred: $e", stackTrace: stackTrace);
      emit(CancelTripError(e.toString()));
      dev.log("[CancelTripCubit] State emitted: CancelTripError");
    }
  }
}