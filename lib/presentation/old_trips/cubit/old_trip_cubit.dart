import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/old_trips/cubit/old_trip_state.dart';

class OldTripCubit extends Cubit<OldTripState> {
  final ApiTripRepository repository;

  OldTripCubit({required this.repository}) : super(OldTripInitial());

  Future<void> fetchDriverOldTrips(int driverId) async {
    emit(OldTripLoading());

    try {
      final oldTrips = await repository.getDriverTrips(driverId);

      if (oldTrips.successful) {
        emit(OldTripLoaded(trips: oldTrips));
      } else {
        emit(
          OldTripError(
            message: oldTrips.message.isNotEmpty
                ? oldTrips.message
                : S.current.ErrorServer,
          ),
        );
      }
    } catch (e) {
      debugPrint('💥 OldTrip Unknown Error: $e');
      emit(OldTripError(message: S.current.ErrorUnexpected));
    }
  }
}
