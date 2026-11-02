import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class AppTheme {
  static ThemeData get current {
    final scheme = ColorScheme.light(
      primary: AppColors.blue,
      onPrimary: AppColors.onAccent,
      secondary: AppColors.green,
      onSecondary: AppColors.ink,
      error: AppColors.danger,
      onError: AppColors.onAccent,
      surface: AppColors.background,
      onSurface: AppColors.ink,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 42,
          height: 1.02,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -1.1,
        ),
        titleLarge: TextStyle(fontSize: 22, height: 1.2, fontWeight: FontWeight.w700, color: AppColors.ink),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
          letterSpacing: -0.3,
        ),
        bodyMedium: TextStyle(fontSize: 15, height: 1.35, fontWeight: FontWeight.w500, color: AppColors.muted),
        bodySmall: TextStyle(fontSize: 13, height: 1.3, fontWeight: FontWeight.w500, color: AppColors.faint),
        labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onAccent),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.onAccent,
          minimumSize: const Size(64, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: TextStyle(color: AppColors.onAccent, fontWeight: FontWeight.w600),
      ),
      iconTheme: const IconThemeData(color: AppColors.ink),
    );
  }
}
