import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/emotion_analysis_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/language_utils.dart';

class EmotionAnalysisScreen extends StatelessWidget {
  final String diaryId;

  const EmotionAnalysisScreen({Key? key, required this.diaryId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'diary.emotionAnalysis'.tr(),
          style: AppTextStyles.headingMedium,
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('emotion_analyses')
                .where('journalId', isEqualTo: diaryId)
                .limit(1)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'common.error'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'diary.noAnalysisAvailable'.tr(),
                style: AppTextStyles.bodyMedium,
              ),
            );
          }

          // 감정분석 데이터 가져오기
          final emotionAnalysis = EmotionAnalysisModel.fromFirestore(
            snapshot.data!.docs.first,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 주요 감정
                _buildSectionHeader(
                  'diary.primaryEmotion'.tr(),
                  AppColors.deepPurple,
                ),
                _buildEmotionBadge(
                  context,
                  koreanText: emotionAnalysis.primaryEmotion,
                  englishText: emotionAnalysis.primaryEmotionEn ?? '',
                ),
                const SizedBox(height: 24),

                // 감정 강도
                _buildSectionHeader(
                  'diary.emotionIntensity'.tr(),
                  AppColors.deepPurple,
                ),
                _buildIntensityIndicator(emotionAnalysis.intensityScore),
                const SizedBox(height: 24),

                // 감정 키워드
                _buildSectionHeader(
                  'diary.emotionKeywords'.tr(),
                  AppColors.deepPurple,
                ),
                _buildKeywords(
                  context,
                  koreanKeywords: emotionAnalysis.emotionKeywords,
                  englishKeywords: emotionAnalysis.emotionKeywordsEn ?? [],
                ),
                const SizedBox(height: 24),

                // 감정 패턴 분석
                _buildSectionHeader(
                  'diary.patternIdentified'.tr(),
                  AppColors.deepPurple,
                ),
                _buildTextBlock(
                  context,
                  koreanText: emotionAnalysis.patternIdentified ?? '',
                  englishText: emotionAnalysis.patternIdentifiedEn ?? '',
                ),
                const SizedBox(height: 24),

                // 추천사항
                _buildSectionHeader(
                  'diary.recommendations'.tr(),
                  AppColors.deepPurple,
                ),
                _buildRecommendations(
                  context,
                  koreanRecommendations: emotionAnalysis.recommendations ?? [],
                  englishRecommendations:
                      emotionAnalysis.recommendationsEn ?? [],
                ),

                // 상세 분석 (있는 경우)
                if (emotionAnalysis.detailedAnalysis != null ||
                    emotionAnalysis.detailedAnalysisEn != null) ...[
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    'diary.detailedAnalysis'.tr(),
                    AppColors.deepPurple,
                  ),
                  _buildTextBlock(
                    context,
                    koreanText: emotionAnalysis.detailedAnalysis ?? '',
                    englishText: emotionAnalysis.detailedAnalysisEn ?? '',
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // 섹션 헤더 위젯
  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.headingSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 감정 뱃지 위젯
  Widget _buildEmotionBadge(
    BuildContext context, {
    required String koreanText,
    required String englishText,
  }) {
    final emotionText = LanguageUtils.getLocalizedEmotionField(
      context: context,
      koreanField: koreanText,
      englishField: englishText,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.deepPurple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        emotionText,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.deepPurple,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 감정 강도 표시기 위젯
  Widget _buildIntensityIndicator(double intensity) {
    // 강도를 0-10 스케일로 표시 (서버에서는 0-1.0 스케일로 저장)
    final displayedIntensity = (intensity * 10).toInt();
    final value = intensity * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$displayedIntensity/10', style: AppTextStyles.headingLarge),
            Text('${value.toInt()}%', style: AppTextStyles.bodyMedium),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: intensity,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getIntensityColor(intensity),
          ),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('낮음', style: AppTextStyles.bodySmall),
            Text('높음', style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }

  // 감정 키워드 위젯
  Widget _buildKeywords(
    BuildContext context, {
    required List<String> koreanKeywords,
    required List<String> englishKeywords,
  }) {
    final keywords = LanguageUtils.getLocalizedEmotionListField(
      context: context,
      koreanField: koreanKeywords,
      englishField: englishKeywords,
    );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: keywords.map((keyword) => _buildKeywordChip(keyword)).toList(),
    );
  }

  // 키워드 칩 위젯
  Widget _buildKeywordChip(String keyword) {
    return Chip(
      label: Text(keyword),
      backgroundColor: AppColors.lavender.withOpacity(0.2),
      labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.deepPurple),
    );
  }

  // 텍스트 블록 위젯
  Widget _buildTextBlock(
    BuildContext context, {
    required String koreanText,
    required String englishText,
  }) {
    final text = LanguageUtils.getLocalizedEmotionField(
      context: context,
      koreanField: koreanText,
      englishField: englishText,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: AppTextStyles.bodyMedium.copyWith(height: 1.5)),
    );
  }

  // 추천사항 위젯
  Widget _buildRecommendations(
    BuildContext context, {
    required List<String> koreanRecommendations,
    required List<String> englishRecommendations,
  }) {
    final recommendations = LanguageUtils.getLocalizedEmotionListField(
      context: context,
      koreanField: koreanRecommendations,
      englishField: englishRecommendations,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          recommendations.map((recommendation) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  // 감정 강도에 따른 색상 반환
  Color _getIntensityColor(double intensity) {
    if (intensity < 0.3) return AppColors.calm;
    if (intensity < 0.5) return Colors.green;
    if (intensity < 0.7) return Colors.amber;
    if (intensity < 0.9) return Colors.orange;
    return AppColors.anger;
  }
}
