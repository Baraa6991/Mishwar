part of 'delete_account_cubit.dart';

abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {
  final String message;
  DeleteAccountSuccess({required this.message});
}

class DeleteAccountError extends DeleteAccountState {
  final String message;
  DeleteAccountError({required this.message});
}
