import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mishwar/Helper/cach_helper.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(Locale(CacheHelper.getData(key: "lang") ?? 'ar'));

  void switchToEnglish() => emit(const Locale('en'));
  void switchToArabic() => emit(const Locale('ar'));

  void toggleLocale() {
    if (state.languageCode == 'en') {
      CacheHelper.saveData(key: "lang", value: 'ar');
      emit(const Locale('ar'));
    } else {
      CacheHelper.saveData(key: "lang", value: 'en');

      emit(const Locale('en'));
    }
  }
}
