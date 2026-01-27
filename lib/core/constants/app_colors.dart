import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1A237E);
  static const Color primaryDark = Color(0xFF000051);
  static const Color primaryLight = Color(0xFF534BAE);

  // Secondary Colors
  static const Color secondary = Color(0xFF3F51B5);
  static const Color secondaryDark = Color(0xFF002984);
  static const Color secondaryLight = Color(0xFF757DE8);

  // Accent Colors
  static const Color accent = Color(0xFF00ACC1);
  static const Color accentDark = Color(0xFF007C91);
  static const Color accentLight = Color(0xFF62EFFF);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF212121);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonSuccess = success;
  static const Color buttonDanger = error;
  static const Color buttonCancel = error;

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primary, primaryLight],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary, secondary],
  );

  // Chat Colors
  static const Color chatBubbleSent = primary;
  static const Color chatBubbleReceived = Color(0xFFFFFFFF);
  static const Color chatBackground = Color(0xFFE5E5E5);

  // Trip Colors
  static const Color tripActive = success;
  static const Color tripPending = warning;
  static const Color tripCancelled = error;

  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);
}
