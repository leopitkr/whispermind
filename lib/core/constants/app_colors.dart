import 'package:flutter/material.dart';

/// WhisperMind 앱의 색상 상수
class AppColors {
  // 기본 색상
  static const Color primary = Color(0xFF6750A4);
  static const Color secondary = Color(0xFF625B71);
  static const Color tertiary = Color(0xFF7D5260);
  static const Color background = Color(0xFFFFFBFE);
  static const Color surface = Color(0xFFFFFBFE);
  static const Color error = Color(0xFFB3261E);

  // 감정 색상
  static const Color calm = Color(0xFF4CAF50); // 평온
  static const Color joy = Color(0xFFFFEB3B); // 기쁨
  static const Color sadness = Color(0xFF2196F3); // 슬픔
  static const Color anger = Color(0xFFF44336); // 분노
  static const Color anxiety = Color(0xFF9C27B0); // 불안
  static const Color love = Color(0xFFE91E63); // 사랑
  static const Color hope = Color(0xFF8BC34A); // 희망
  static const Color fear = Color(0xFF795548); // 두려움
  static const Color longing = Color(0xFF9C27B0); // 그리움

  // 그레이 스케일
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color midGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF757575);
  static const Color black = Color(0xFF212121);

  // 브랜드 색상
  static const Color deepPurple = Color(0xFF6750A4);
  static const Color lavender = Color(0xFFE8DEF8);
  static const Color mint = Color(0xFFCEF5E6);

  // 그라데이션
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8DEF8), Color(0xFFD0BCFF)],
  );

  // 그림자
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];
}
