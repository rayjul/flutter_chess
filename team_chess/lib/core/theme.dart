import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFF6D4C41); // walnut brown

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
    useMaterial3: true,
  );

  static final dark = ThemeData(
    colorScheme:
        ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
    useMaterial3: true,
  );
}

abstract final class BoardColors {
  static const light = Color(0xFFF0D9B5);
  static const dark = Color(0xFFB58863);
  static const selected = Color(0x8800C853);
  static const target = Color(0x6600C853);
}
