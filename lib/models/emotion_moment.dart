import 'package:flutter/widgets.dart';

class EmotionMoment {
  final String emotion;
  final IconData emotionIcon;
  final Color emotionColor;
  final String content;
  final String date;

  EmotionMoment({
    required this.emotion,
    required this.emotionIcon,
    required this.emotionColor,
    required this.content,
    required this.date,
  });
}
