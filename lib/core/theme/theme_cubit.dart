import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../storage/prefs_helper.dart';
import '../utils/constants.dart';
import 'app_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.lightTheme) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDarkMode = await PrefsHelper.getBool(CacheConstants.themeKey);
    emit(isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  Future<void> toggleTheme() async {
    final isCurrentlyDark = state.brightness == Brightness.dark;

    await PrefsHelper.setBool(CacheConstants.themeKey, !isCurrentlyDark);

    emit(isCurrentlyDark ? AppTheme.lightTheme : AppTheme.darkTheme);
  }
}
