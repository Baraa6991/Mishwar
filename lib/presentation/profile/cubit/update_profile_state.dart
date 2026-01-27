import 'package:equatable/equatable.dart';

abstract class UpdateProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final String message;
  UpdateProfileSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdateProfileError extends UpdateProfileState {
  final String message;
  UpdateProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
