import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color scaffoldBg    = Color(0xFF0A0A0A);
  static const Color cardBg        = Color(0xFF1A1A1A);
  static const Color cardBg2       = Color(0xFF1E1E1E);
  static const Color inputBg       = Color(0xFF141414);
  static const Color divider       = Color(0xFF2A2A2A);

  // Orange brand
  static const Color orange        = Color(0xFFE8691A);
  static const Color orangeDark    = Color(0xFFC4501A);
  static const Color orangeLight   = Color(0xFFF07020);
  static const Color orangeGlow    = Color(0x33E8691A);

  // Text
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9A9A9A);
  static const Color textMuted     = Color(0xFF5A5A5A);

  // Macros
  static const Color protein       = Color(0xFF4A9EFF);
  static const Color carbs         = Color(0xFFE8691A);
  static const Color fat           = Color(0xFF4CAF50);

  // Status
  static const Color danger        = Color(0xFFFF4444);
  static const Color success       = Color(0xFF4CAF50);
  static const Color warning       = Color(0xFFFFB800);

  // Gradients
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFE8691A), Color(0xFFC4501A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Dark image overlay gradient — applied on top of ALL hero images
  static const LinearGradient imageOverlay = LinearGradient(
    colors: [Color(0xCC000000), Color(0x44000000)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  
  // Orange-tinted image overlay — for banner/challenge cards
  static const LinearGradient orangeImageOverlay = LinearGradient(
    colors: [Color(0xDDE8691A), Color(0x66C4501A)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
