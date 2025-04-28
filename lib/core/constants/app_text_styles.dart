import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // 제목 스타일
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGray,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGray,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGray,
  );

  // 부제목 스타일
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGray,
  );

  // 본문 스타일
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGray,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGray,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.midGray,
  );

  // 강조 스타일
  static const TextStyle highlight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // 카드 제목 스타일
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGray,
  );

  // 버튼 스타일
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // 입력 필드 힌트 스타일
  static const TextStyle inputHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.midGray,
  );

  // 에러 메시지 스타일
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.red,
  );
}
