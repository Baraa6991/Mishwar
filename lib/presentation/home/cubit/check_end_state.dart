abstract class CheckEndState {}

class CheckEndInitial extends CheckEndState {}

class CheckEndLoading extends CheckEndState {}

class CheckEndSuccess extends CheckEndState {
  final Map<String, dynamic> checkEndData;
  CheckEndSuccess({required this.checkEndData});
}

class CheckEndError extends CheckEndState {
  final String message;
  CheckEndError(this.message);
}
class CheckEndStopped extends CheckEndState {}

