import 'package:flutter/material.dart';

/// Warm clay studio. Pieces use [clay]; blue, green, and danger stay for motion.
abstract final class AppColors {
  static const Color background = Color(0xFFF4EBDD);
  static const Color board = Color(0xFFF8F1E6);
  static const Color surface = Color(0xFFFFF8F0);
  static const Color ink = Color(0xFF4A453F);
  static const Color muted = Color(0xFF8A7D72);
  static const Color faint = Color(0xFFB7A89A);
  static const Color line = Color(0xFFE4D5C4);
  static const Color dot = Color(0xFFE7DCCE);

  static const Color blue = Color(0xFF54A0EB);
  static const Color green = Color(0xFF54EBAC);
  static const Color danger = Color(0xFFEB545E);
  static const Color accent = Color(0xFFE36A58);
  static const Color onAccent = Color(0xFFFFF8F0);

  static const Color arrow = Color(0xFFFFF8F0);
  static const Color heart = Color(0xFFE86B5C);
  static const Color heartEmpty = Color(0xFFD5C4B3);

  static const List<Color> clay = [
    Color(0xFFE8C14A),
    Color(0xFFE36A58),
    Color(0xFF8B62C7),
    Color(0xFF57C07A),
    Color(0xFF4B9FDB),
  ];

  /// Stable per piece so a tile never changes color between frames.
  static Color clayFor(int id) {
    final mixed = (id * 37 + 11) & 0x7fffffff;
    return clay[mixed % clay.length];
  }

  static const Color scrim = Color(0xD9F4EBDD);
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
  static const double hintSize = 48;
}

abstract final class AppMotion {
  static const Duration bump = Duration(milliseconds: 320);
  static const Duration startup = Duration(seconds: 8);
}
