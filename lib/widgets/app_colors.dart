import 'package:flutter/material.dart';

class AppColors {
  static const primary    = Color(0xFF41678E);
  static const primary2   = Color(0xFF2A4F70);
  static const gold       = Color(0xFFF0C040);
  static const green      = Color(0xFF2A9D8F);
  static const bg         = Color(0xFFEEF2F7);
  static const card       = Color(0xFFFFFFFF);
  static const txt        = Color(0xFF1A2A3A);
  static const muted      = Color(0xFF607080);

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primary2],
  );
}
