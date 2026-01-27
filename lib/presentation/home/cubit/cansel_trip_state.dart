abstract class CancelTripState {}

class CancelTripInitial extends CancelTripState {}

class CancelTripLoading extends CancelTripState {}

class CancelTripSuccess extends CancelTripState {
  final String message;
  CancelTripSuccess(this.message);
}

class CancelTripError extends CancelTripState {
  final String message;
  CancelTripError(this.message);
}
