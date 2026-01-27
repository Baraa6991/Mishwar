import 'package:mishwar/presentation/old_trips/model/old_trip_model.dart';

abstract class OldTripState {}

class OldTripInitial extends OldTripState {}

class OldTripLoading extends OldTripState {}

class OldTripLoaded extends OldTripState {
  final TripHistoryResponse trips;
  OldTripLoaded({required this.trips});
}

class OldTripError extends OldTripState {
  final String message;
  OldTripError({required this.message});
}
