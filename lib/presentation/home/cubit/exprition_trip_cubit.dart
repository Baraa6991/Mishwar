import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';
import 'package:mishwar/presentation/home/cubit/exprition_trip_state.dart';

class RateTripCubit extends Cubit<RateTripState> {
  final ApiTripRepository repository;

  int? _driverId;
  int? _userId;
  int? _tripId;

  RateTripCubit(this.repository) : super(RateTripInitial());

  // ✅ دالة شاملة لتعيين جميع البيانات المطلوبة
  void setTripData({
    required int driverId,
    required int userId,
    required int tripId,
  }) {
    _driverId = driverId;
    _userId = userId;
    _tripId = tripId;
    print(
      "RateTripCubit: Trip data set - driverId: $_driverId, userId: $_userId, tripId: $_tripId",
    );
  }

  Future<void> rateTrip(double rating, {String? comment}) async {
    print("RateTripCubit: rateTrip called with rating = $rating");
    emit(RateTripLoading());

    try {
      if (_driverId == null || _userId == null || _tripId == null) {
        print("RateTripCubit: Missing trip data");
        emit(RateTripError("Missing trip data"));
        return;
      }

      final response = await repository.rateTrip(
        tripId: _tripId!,
        driverId: _driverId!,
        userId: _userId!,
        rating: rating,
        comment: comment,
      );

      print("RateTripCubit: API response received - $response");
      emit(RateTripSuccess(response["message"] ?? "Trip rated successfully"));
    } catch (e, stack) {
      print("RateTripCubit: Error rating trip - $e");
      print("Stack trace: $stack");
      emit(RateTripError("فشل في تقييم الرحلة: ${e.toString()}"));
    }
  }
}
