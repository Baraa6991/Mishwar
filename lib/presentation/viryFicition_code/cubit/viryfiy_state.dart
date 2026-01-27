abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationSuccess extends VerificationState {
  final String message;
  final Map<String, dynamic> userData;
  VerificationSuccess({required this.message, required this.userData});
}
class ResendCodeLoading extends VerificationState {}

class VerificationError extends VerificationState {
  final String message;
  VerificationError({required this.message});
}

class ResendCodeSuccess extends VerificationState {
  final String message;
  ResendCodeSuccess({required this.message});
}
