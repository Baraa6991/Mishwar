part of 'refresh_token_cubit.dart';

@immutable
abstract class RefreshTokenState {}

class RefreshTokenInitial extends RefreshTokenState {}

class RefreshTokenLoading extends RefreshTokenState {}

class RefreshTokenSuccess extends RefreshTokenState {
  final String message;
  RefreshTokenSuccess({required this.message});
}

class RefreshTokenError extends RefreshTokenState {
  final String message;
  RefreshTokenError({required this.message});
}
