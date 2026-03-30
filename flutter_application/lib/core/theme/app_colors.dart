import 'package:flutter/material.dart';

class AppColors {
  // ─── PRIMARY BRAND COLORS (Elite Fit Red/White/Black) ──────────────────────
  static const Color red          = Color(0xFFE8191B);   // Elite Fit signature red
  static const Color redDark      = Color(0xFFC01215);   // darker red for gradients
  static const Color redLight     = Color(0xFFFF3335);   // lighter red for hover/glow
  static const Color redGlow      = Color(0x33E8191B);   // red at 20% — glow effects

  // ─── BACKGROUNDS ────────────────────────────────────────────────────────────
  static const Color scaffoldBg   = Color(0xFFF5F5F5);   // light gray white scaffold
  static const Color white        = Color(0xFFFFFFFF);   // pure white — cards
  static const Color cardBg       = Color(0xFFFFFFFF);   // white cards on light bg
  static const Color cardBgDark   = Color(0xFF1A1A1A);   // dark cards (for contrast sections)
  static const Color inputBg      = Color(0xFFF0F0F0);   // light gray inputs
  static const Color divider      = Color(0xFFE0E0E0);   // light divider

  // ─── BLACK TONES ────────────────────────────────────────────────────────────
  static const Color black        = Color(0xFF0D0D0D);   // near-black
  static const Color darkGray     = Color(0xFF1A1A1A);   // section backgrounds
  static const Color medGray      = Color(0xFF4A4A4A);   // body text
  static const Color lightGray    = Color(0xFF9A9A9A);   // captions

  // ─── TEXT ────────────────────────────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFF0D0D0D);   // near black — main text
  static const Color textSecond   = Color(0xFF4A4A4A);   // dark gray — subtitles
  static const Color textMuted    = Color(0xFF9A9A9A);   // light gray — captions
  static const Color textOnRed    = Color(0xFFFFFFFF);   // white text on red bg
  static const Color textOnDark   = Color(0xFFFFFFFF);   // white text on dark bg

  // ─── MACRO COLORS ────────────────────────────────────────────────────────────
  static const Color protein      = Color(0xFF2979FF);   // blue
  static const Color carbs        = Color(0xFFE8191B);   // red (matches brand)
  static const Color fat          = Color(0xFF00C853);   // green

  // ─── STATUS ──────────────────────────────────────────────────────────────────
  static const Color success      = Color(0xFF00C853);
  static const Color warning      = Color(0xFFFFB300);
  static const Color danger       = Color(0xFFE8191B);   // same as brand red

  // ─── GRADIENTS ───────────────────────────────────────────────────────────────
  // Primary CTA gradient — red to dark red
  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFE8191B), Color(0xFFC01215)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Dark section gradient — for hero areas
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0D0D0D), Color(0xFF2A2A2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Image overlay — dark fade on gym photos
  static const LinearGradient imageOverlayDark = LinearGradient(
    colors: [Color(0xDD000000), Color(0x44000000)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  
  // Image overlay — red-tinted for brand cards
  static const LinearGradient imageOverlayRed = LinearGradient(
    colors: [Color(0xDDE8191B), Color(0x55C01215)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // White card shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4)),
  ];
  
  // Red glow shadow — for active elements
  static List<BoxShadow> redShadow = [
    BoxShadow(color: Color(0x44E8191B), blurRadius: 20, spreadRadius: 2),
  ];
}
