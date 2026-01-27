
abstract class FindDriversState {}

class FindDriversInitial extends FindDriversState {}

class FindDriversLoading extends FindDriversState {}

class FindDriversSuccess extends FindDriversState {
  final String message;
  FindDriversSuccess({required this.message});
}

class FindDriversError extends FindDriversState {
  final String message;
  FindDriversError({required this.message});
}


abstract class CheckTripStatusState {}

class CheckTripInitial extends CheckTripStatusState {}

class CheckTripLoading extends CheckTripStatusState {}

class CheckTripAccepted extends CheckTripStatusState {
  final int tripId;
  final Map<String, dynamic> driverData;

  CheckTripAccepted({
    required this.tripId,
    required this.driverData,
  });
}


class CheckTripWaiting extends CheckTripStatusState {}

class CheckTripError extends CheckTripStatusState {
  final String message;
  CheckTripError(this.message);
}
