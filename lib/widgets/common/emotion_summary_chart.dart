import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/emotion_data.dart';

class EmotionSummaryChart extends StatelessWidget {
  final List<EmotionData> emotions;
  final String title;
  final VoidCallback onTap;

  const EmotionSummaryChart({
    super.key,
    required this.emotions,
    required this.title,
    required this.onTap,
  });

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.cardTitle),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.midGray,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= emotions.length ||
                              value.toInt() < 0) {
                            return const SizedBox.shrink();
                          }

                          // 요일 약어만 표시
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              emotions[value.toInt()].date,
                              style: AppTextStyles.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots:
                          emotions.asMap().entries.map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              entry.value.intensity,
                            );
                          }).toList(),
                      isCurved: true,
                      barWidth: 3,
                      color: AppColors.deepPurple,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: _getEmotionColor(emotions[index].emotion),
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.deepPurple.withOpacity(0.1),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: emotions.length - 1.0,
                  minY: 0,
                  maxY: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
