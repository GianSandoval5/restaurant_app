import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFE85A2B);
  static const Color primaryLight = Color(0xFFFF8C5F);

  // Secondary Colors
  static const Color secondary = Color(0xFF2C3E50);
  static const Color secondaryDark = Color(0xFF1A252F);
  static const Color secondaryLight = Color(0xFF34495E);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textHint = Color(0xFFBDC3C7);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color accent = Color(0xFFF39C12);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Semantic Colors
  static const Color favoriteActive = Color(0xFFE74C3C);
  static const Color favoriteInactive = Color(0xFFBDC3C7);

  // Border & Divider Colors
  static const Color border = Color(0xFFE1E8ED);
  static const Color divider = Color(0xFFECF0F1);

  // Overlay Colors
  static const Color overlay = Color(0x40000000);
  static const Color overlayLight = Color(0x20000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFE67E22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
}
