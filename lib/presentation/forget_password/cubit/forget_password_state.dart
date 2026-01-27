
abstract class ForgetPasswordState {}

class ForgetInitial extends ForgetPasswordState {}

class ForgetLoading extends ForgetPasswordState {}

class ForgetSuccess extends ForgetPasswordState {
  final String message;
  ForgetSuccess({required this.message});
}

class ForgetError extends ForgetPasswordState {
  final String message;
  ForgetError({required this.message});
}
