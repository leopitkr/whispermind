import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/constants/app_colors.dart';
import '../models/emotion_moment.dart';
import '../models/recommended_activity.dart';
import '../models/emotion_data.dart';

class EmotionAnalyticsProvider extends ChangeNotifier {
  String get dominantEmotion => '평온함'; // TODO: AI 분석 기반으로 변경
  IconData get dominantEmotionIcon => CupertinoIcons.sun_max_fill;
  Color get dominantEmotionColor => AppColors.calm;
  String get emotionInsight =>
      '이번 주는 전반적으로 평온한 감정 상태를 유지하고 있습니다. '
      '명상과 운동을 통해 스트레스를 잘 관리하고 있으며, '
      '긍정적인 마인드를 유지하고 있습니다.';

  List<EmotionData> get weeklyEmotions => [
    EmotionData(date: '월', emotion: '슬픔', intensity: 3.5),
    EmotionData(date: '화', emotion: '슬픔', intensity: 4.0),
    EmotionData(date: '수', emotion: '불안', intensity: 5.2),
    EmotionData(date: '목', emotion: '희망', intensity: 6.8),
    EmotionData(date: '금', emotion: '희망', intensity: 7.3),
    EmotionData(date: '토', emotion: '그리움', intensity: 5.6),
    EmotionData(date: '일', emotion: '평온', intensity: 8.2),
  ];

  List<EmotionMoment> get specialMoments => [
    EmotionMoment(
      emotion: '기쁨',
      emotionIcon: CupertinoIcons.heart_fill,
      emotionColor: AppColors.joy,
      content: '오랜만에 만난 친구들과 즐거운 시간을 보냈다. 우리의 우정이 변함없이 이어져 행복하다.',
      date: '오늘',
    ),
    EmotionMoment(
      emotion: '성취',
      emotionIcon: CupertinoIcons.star_fill,
      emotionColor: AppColors.achievement,
      content: '6개월간 준비한 프로젝트가 성공적으로 마무리되었다. 노력이 결실을 맺어 뿌듯하다.',
      date: '어제',
    ),
    EmotionMoment(
      emotion: '감사',
      emotionIcon: CupertinoIcons.heart_circle_fill,
      emotionColor: AppColors.gratitude,
      content: '부모님께서 깜짝 선물을 보내주셨다. 항상 내 편이 되어주시는 것에 감사하다.',
      date: '2일 전',
    ),
  ];

  List<RecommendedActivity> get recommendedActivities => [
    RecommendedActivity(
      title: '5분 호흡 명상',
      description: '마음의 안정을 찾는 짧은 호흡 명상',
      icon: CupertinoIcons.wind,
    ),
    RecommendedActivity(
      title: '감사 일기',
      description: '오늘 감사한 순간 3가지 기록하기',
      icon: CupertinoIcons.pencil,
    ),
    RecommendedActivity(
      title: '미래에게 편지',
      description: '6개월 후의 나에게 타임캡슐 보내기',
      icon: CupertinoIcons.mail,
    ),
  ];
}
