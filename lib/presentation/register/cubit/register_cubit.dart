import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/generated/l10n.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final ApiRepository repository;

  RegisterCubit({required this.repository}) : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required File? photo,
  }) async {
    emit(RegisterLoading());
    debugPrint('🔹 Register started...');
    debugPrint('👤 Name: $name');
    debugPrint('📞 Phone: $phone');
    debugPrint('🔒 Password: $password');
    debugPrint('📷 Photo: ${photo?.path}');

    try {
      final data = await repository.register(
        name: name,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        photo: photo,
      );
      
      debugPrint('📨 Response data: $data');

      if (data['successful'] == true) {
        emit(RegisterSuccess(message: data['message'] ?? S.current.RegisterSuccess));
      } else {
        emit(RegisterError(message: data['message'] ?? S.current.RegisterFailed));
      }
    } catch (e) {
      debugPrint('💥 Register error: $e');
      emit(RegisterError(message: S.current.RegisterFailed));
    }
  }
}