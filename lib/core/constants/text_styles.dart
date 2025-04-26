import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// WhisperMind 앱의 텍스트 스타일 상수
class AppTextStyles {
  // 제목 스타일 (Nunito)
  static TextStyle get headingLarge => GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.darkGray,
    height: 1.3,
  );

  static TextStyle get headingMedium => GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.darkGray,
    height: 1.3,
  );

  static TextStyle get headingSmall => GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.darkGray,
    height: 1.3,
  );

  // 본문 스타일 (Inter)
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.darkGray,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w300, // Light
    color: AppColors.darkGray,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.midGray,
    height: 1.4,
  );

  // 버튼 텍스트
  static TextStyle get buttonLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle get buttonMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.white,
    height: 1.2,
  );

  // 감정 태그 텍스트
  static TextStyle get emotionTag => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.deepPurple,
    height: 1.2,
  );

  // 카드 텍스트
  static TextStyle get cardTitle => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.darkGray,
    height: 1.3,
  );

  static TextStyle get cardBody => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.darkGray,
    height: 1.5,
  );

  // 하이라이트 텍스트
  static TextStyle get highlight => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.deepPurple,
    height: 1.3,
  );

  // 스탯 숫자
  static TextStyle get statNumber => GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.deepPurple,
    height: 1.2,
  );

  // 스탯 레이블
  static TextStyle get statLabel => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.midGray,
    height: 1.2,
  );
}
