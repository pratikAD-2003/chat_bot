import 'package:flutter/material.dart';

class MyTheme {
  static const Color screenBg = Color(0xFFF5F6FA);

  static const Color primary = Color(0xFF83E546);

  static const Color textPrimary = Color(0xFF111827);

  static const Color textSecondary = Color(0xFF6B7280);

  static BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );
}