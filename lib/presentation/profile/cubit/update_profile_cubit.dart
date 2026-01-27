import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/profile/cubit/update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final ApiRepository repository;

  UpdateProfileCubit({required this.repository})
      : super(UpdateProfileInitial());

  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    File? photo,
  }) async {
    emit(UpdateProfileLoading());
    try {
      final response = await repository.updateDriverProfile(
        name: name,
        phoneNumber: phoneNumber,
        photo: photo,
      );

      if (response['successful'] == true) {
        emit(UpdateProfileSuccess(message: response['message'] ?? S.current.ProfileUpdated));
      } else {
        emit(UpdateProfileError(message: response['message'] ?? S.current.ErrorServer));
      }
    } catch (e) {
      debugPrint("💥 UpdateProfile Error: $e");
      emit(UpdateProfileError(message: S.current.ErrorUnexpected));
    }
  }
}
