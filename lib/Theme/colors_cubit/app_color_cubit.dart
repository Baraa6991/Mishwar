import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(_getInitialTheme());

  static ThemeState _getInitialTheme() {
    final isLight = CacheHelper.getData(key: "lightMode");
    if (isLight is bool) {
      return isLight ? ThemeState.light() : ThemeState.dark();
    } else {
      return ThemeState.light(); 
    }
  }

  void toggleTheme() {
    if (state.isDarkMode) {
      emit(ThemeState.light());
      CacheHelper.saveData(key: "lightMode", value: true);
    } else {
      emit(ThemeState.dark());
      CacheHelper.saveData(key: "lightMode", value: false);
    }
  }
}
