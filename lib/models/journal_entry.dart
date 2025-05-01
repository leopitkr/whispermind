import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class JournalEntry {
  final String id;
  final String emotion;
  final IconData emotionIcon;
  final String content;
  final DateTime date;

  JournalEntry({
    required this.id,
    required this.emotion,
    required this.emotionIcon,
    required this.content,
    required this.date,
  });

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final journalDate = DateTime(date.year, date.month, date.day);

    if (journalDate == today) {
      return '오늘 ${DateFormat('HH:mm').format(date)}';
    } else if (journalDate == yesterday) {
      return '어제 ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('M월 d일 HH:mm').format(date);
    }
  }
}
