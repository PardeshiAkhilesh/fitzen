import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Display — calorie numbers, hero stats (bold, black or white)
  static TextStyle display = GoogleFonts.poppins(
      fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.black);
  
  static TextStyle displayWhite = GoogleFonts.poppins(
      fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.white);

  // H1 — screen titles
  static TextStyle h1 = GoogleFonts.poppins(
      fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.black);
  
  static TextStyle h1White = GoogleFonts.poppins(
      fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.white);

  // H2 — section headers
  static TextStyle h2 = GoogleFonts.poppins(
      fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.black);
  
  static TextStyle h2White = GoogleFonts.poppins(
      fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.white);

  // H3 — card titles
  static TextStyle h3 = GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.black);
  
  static TextStyle h3White = GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.white);

  // Body
  static TextStyle body = GoogleFonts.poppins(
      fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.medGray);
  
  static TextStyle bodyWhite = GoogleFonts.poppins(
      fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.white);
      
  static TextStyle bodyWhiteBold = GoogleFonts.poppins(
      fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white);

  // Caption
  static TextStyle caption = GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.lightGray);
  
  static TextStyle captionWhite = GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.white);
      
  static TextStyle captionWhite70 = GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.white.withOpacity(0.7));

  // Label Red — active elements, badges
  static TextStyle labelRed = GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.red);
  
  static TextStyle labelWhite = GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.white);
}
