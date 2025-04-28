import 'package:flutter/material.dart';

/// WhisperMind 앱의 색상 상수
class AppColors {
  // 주요 컬러
  static const Color deepPurple = Color(0xFF6B4E98); // 딥 퍼플 - 앱의 정체성
  static const Color lavender = Color(0xFFA284CF); // 라벤더 - 버튼, 강조 요소
  static const Color nightBlue = Color(0xFF304E7D); // 밤하늘 블루 - 이차 요소

  // 감정 컬러 시스템
  static const Color sadness = Color(0xFF5E8BBA); // 슬픔
  static const Color longing = Color(0xFF8884C4); // 그리움
  static const Color anger = Color(0xFFD16D6F); // 분노
  static const Color anxiety = Color(0xFFD9A76A); // 불안
  static const Color hope = Color(0xFF78B38A); // 희망
  static const Color calm = Color(0xFF7AD0DE); // 평온

  // 중립 컬러
  static const Color white = Color(0xFFFFFFFF); // 화이트 - 배경, 카드
  static const Color offWhite = Color(0xFFF8F5FF); // 오프 화이트 - 세컨더리 배경
  static const Color lightGray = Color(0xFFF5F5F5); // 라이트 그레이 - 구분선
  static const Color midGray = Color(0xFF9E9E9E); // 미드 그레이 - 보조 텍스트
  static const Color darkGray = Color(0xFF424242); // 다크 그레이 - 주요 텍스트
  static const Color night = Color(0xFF232038); // 나이트 - 다크 모드 배경

  // 그라데이션
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [offWhite, Color(0xFFF0E6FF)],
  );

  // 감정별 그라데이션
  static LinearGradient getEmotionGradient(String emotion) {
    switch (emotion) {
      case 'sadness':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [sadness.withOpacity(0.7), sadness],
        );
      case 'longing':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [longing.withOpacity(0.7), longing],
        );
      case 'anger':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [anger.withOpacity(0.7), anger],
        );
      case 'anxiety':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [anxiety.withOpacity(0.7), anxiety],
        );
      case 'hope':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [hope.withOpacity(0.7), hope],
        );
      case 'calm':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [calm.withOpacity(0.7), calm],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [lavender.withOpacity(0.7), lavender],
        );
    }
  }

  // 카드 그림자
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: deepPurple.withOpacity(0.08),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static const Color primary = Color(0xFF6C63FF);
  static const Color black = Color(0xFF000000);
}
