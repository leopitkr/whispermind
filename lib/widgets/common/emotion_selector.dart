import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/diary.dart';

class EmotionSelector extends StatelessWidget {
  final Emotion? selectedEmotion;
  final int intensity;
  final Function(Emotion) onEmotionSelected;
  final Function(int) onIntensityChanged;

  EmotionSelector({
    Key? key,
    required this.selectedEmotion,
    required this.intensity,
    required this.onEmotionSelected,
    required this.onIntensityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 감정 이모지 그리드
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: _emotions.length,
          itemBuilder: (context, index) {
            final emotion = _emotions[index];
            final isSelected = selectedEmotion?.id == emotion.id;

            return GestureDetector(
              onTap: () => onEmotionSelected(emotion),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? emotion.color.withOpacity(0.2)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? emotion.color : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    emotion.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // 감정 강도 슬라이더
        if (selectedEmotion != null) ...[
          Text('감정 강도', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: selectedEmotion!.color,
              inactiveTrackColor: selectedEmotion!.color.withOpacity(0.2),
              thumbColor: selectedEmotion!.color,
              overlayColor: selectedEmotion!.color.withOpacity(0.1),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: intensity.toDouble(),
              min: 0,
              max: 100,
              divisions: 10,
              label: '$intensity%',
              onChanged: (value) => onIntensityChanged(value.toInt()),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '약함',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.midGray,
                ),
              ),
              Text(
                '강함',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.midGray,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // 기본 감정 목록
  static final List<Emotion> _emotions = [
    Emotion(
      id: 'happy',
      name: '행복',
      emoji: '😊',
      color: const Color(0xFFFFD700),
    ),
    Emotion(id: 'sad', name: '슬픔', emoji: '😢', color: const Color(0xFF5E8BBA)),
    Emotion(
      id: 'angry',
      name: '분노',
      emoji: '😠',
      color: const Color(0xFFD16D6F),
    ),
    Emotion(
      id: 'anxious',
      name: '불안',
      emoji: '😰',
      color: const Color(0xFFD9A76A),
    ),
    Emotion(
      id: 'calm',
      name: '평온',
      emoji: '😌',
      color: const Color(0xFF7AD0DE),
    ),
    Emotion(
      id: 'excited',
      name: '설렘',
      emoji: '🤩',
      color: const Color(0xFFFF69B4),
    ),
    Emotion(
      id: 'grateful',
      name: '감사',
      emoji: '🙏',
      color: const Color(0xFF78B38A),
    ),
    Emotion(
      id: 'lonely',
      name: '외로움',
      emoji: '😔',
      color: const Color(0xFF8884C4),
    ),
    Emotion(
      id: 'tired',
      name: '피곤',
      emoji: '😴',
      color: const Color(0xFFA284CF),
    ),
    Emotion(
      id: 'hopeful',
      name: '희망',
      emoji: '✨',
      color: const Color(0xFF78B38A),
    ),
  ];
}
