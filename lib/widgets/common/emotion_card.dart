import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/text_styles.dart';

class EmotionCard extends StatelessWidget {
  final String emotionName;
  final IconData emotionIcon;
  final String date;
  final String previewText;
  final VoidCallback onTap;

  const EmotionCard({
    super.key,
    required this.emotionName,
    required this.emotionIcon,
    required this.date,
    required this.previewText,
    required this.onTap,
  });

  Color _getEmotionColor() {
    switch (emotionName.toLowerCase()) {
      case 'sadness':
      case '슬픔':
        return AppColors.sadness;
      case 'longing':
      case '그리움':
        return AppColors.longing;
      case 'anger':
      case '분노':
        return AppColors.anger;
      case 'anxiety':
      case '불안':
        return AppColors.anxiety;
      case 'hope':
      case '희망':
        return AppColors.hope;
      case 'calm':
      case '평온':
        return AppColors.calm;
      default:
        return AppColors.lavender;
    }
  }

  @override
  Widget build(BuildContext context) {
    final emotionColor = _getEmotionColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.cardShadow,
          border: Border(left: BorderSide(color: emotionColor, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(emotionIcon, color: emotionColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    emotionName,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: emotionColor,
                    ),
                  ),
                  const Spacer(),
                  Text(date, style: AppTextStyles.bodySmall),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                previewText,
                style: AppTextStyles.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
