abstract class RateTripState {}

class RateTripInitial extends RateTripState {}

class RateTripLoading extends RateTripState {}

class RateTripSuccess extends RateTripState {
  final String message;
  RateTripSuccess(this.message);
}

class RateTripError extends RateTripState {
  final String message;
  RateTripError(this.message);
}
