import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';
import 'package:mishwar/presentation/profile/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiRepository repository;
  ProfileCubit({required this.repository}) : super(ProfileInitial());

  Future<void> fetchProfile(int id) async {
    
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile(id);
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      debugPrint('💥 Profile Error: $e');
      emit(ProfileError(message: S.current.ErrorServer));
    }
  }
}
