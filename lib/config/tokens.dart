import 'package:flutter/material.dart';

/// Grayscale UI, plus the shared hue ring for hearts, hints, and buttons.
abstract final class AppColors {
  static const Color background = Color(0xFFF3F3F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF2A2A2A);
  static const Color muted = Color(0xFF7A7A7A);
  static const Color faint = Color(0xFFB0B0B0);
  static const Color line = Color(0xFFD5D5D5);
  static const Color dot = Color(0xFFD0D0D0);

  static const Color blue = Color(0xFF54A0EB);
  static const Color green = Color(0xFF54EBAC);
  static const Color danger = Color(0xFFEB545E);
  static const Color onAccent = Color(0xFFEBEBEB);

  static const Color scrim = Color(0xCCF3F3F3);
  static const Color transparent = Color(0x00000000);
}

abstract final class AppDimens {
  static const double page = 24;
  static const double gap = 12;
  static const double gapL = 20;
  static const double radius = 18;
  static const double maxContent = 520;
  static const double wide = 800;
  static const double buttonHeight = 56;
  static const double hintSize = 64;
}

abstract final class AppMotion {
  static const Duration bump = Duration(milliseconds: 320);
  static const Duration startup = Duration(seconds: 8);
}
