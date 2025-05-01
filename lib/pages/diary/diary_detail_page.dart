import 'package:flutter/material.dart';
import '../../models/diary_model.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class DiaryDetailPage extends StatelessWidget {
  final DiaryModel diary;

  const DiaryDetailPage({Key? key, required this.diary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('일기 상세', style: AppTextStyles.headingMedium)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(diary.title, style: AppTextStyles.headingLarge),
            const SizedBox(height: 8),
            Text(
              DateFormat('yyyy년 MM월 dd일').format(diary.createdAt),
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (diary.emotion.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getEmotionColor(diary.emotion).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  diary.emotion,
                  style: TextStyle(
                    color: _getEmotionColor(diary.emotion),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              diary.content,
              style: AppTextStyles.body.copyWith(height: 1.5),
            ),
            if (diary.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    diary.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '#$tag',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case '평온':
        return AppColors.calm;
      case '기쁨':
        return AppColors.joy;
      case '슬픔':
        return AppColors.sadness;
      case '분노':
        return AppColors.anger;
      case '불안':
        return AppColors.anxiety;
      default:
        return Colors.grey;
    }
  }
}
