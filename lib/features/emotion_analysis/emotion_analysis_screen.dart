import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/emotion_analysis_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/language_utils.dart';

class EmotionAnalysisScreen extends StatefulWidget {
  final String diaryId;

  const EmotionAnalysisScreen({Key? key, required this.diaryId})
    : super(key: key);

  @override
  State<EmotionAnalysisScreen> createState() => _EmotionAnalysisScreenState();
}

class _EmotionAnalysisScreenState extends State<EmotionAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // 화면이 빌드된 후 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                .where('journalId', isEqualTo: widget.diaryId)
                .limit(1)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('감정을 분석하고 있어요...', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
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

          // 현재 UI 언어와 감정분석 언어가 동일한지 확인
          final currentLocale = context.locale.languageCode;
          final isMatchingLanguage = emotionAnalysis.language == currentLocale;

          return FadeTransition(
            opacity: _fadeInAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 결과 헤더
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.psychology,
                          size: 48,
                          color: AppColors.deepPurple,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'diary.analysisComplete'.tr(),
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColors.deepPurple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'diary.aiInsight'.tr(),
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // 나머지 위젯들은 AnimatedBuilder로 감싸서 시차를 두고 나타나게 함
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(opacity: _controller.value, child: child);
                    },
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
                          emotion: emotionAnalysis.primaryEmotion,
                          isMatchingLanguage: isMatchingLanguage,
                        ),
                        const SizedBox(height: 24),

                        // 감정 강도
                        _buildSectionHeader(
                          'diary.emotionIntensity'.tr(),
                          AppColors.deepPurple,
                        ),
                        _buildIntensityIndicator(
                          emotionAnalysis.intensityScore,
                        ),
                        const SizedBox(height: 24),

                        // 감정 키워드
                        _buildSectionHeader(
                          'diary.emotionKeywords'.tr(),
                          AppColors.deepPurple,
                        ),
                        _buildKeywords(
                          context,
                          keywords: emotionAnalysis.emotionKeywords,
                          isMatchingLanguage: isMatchingLanguage,
                        ),
                        const SizedBox(height: 24),

                        // 감정 패턴 분석
                        _buildSectionHeader(
                          'diary.patternIdentified'.tr(),
                          AppColors.deepPurple,
                        ),
                        _buildTextBlock(
                          context,
                          text: emotionAnalysis.patternIdentified ?? '',
                          isMatchingLanguage: isMatchingLanguage,
                        ),
                        const SizedBox(height: 24),

                        // 추천사항
                        _buildSectionHeader(
                          'diary.recommendations'.tr(),
                          AppColors.deepPurple,
                        ),
                        _buildRecommendations(
                          context,
                          recommendations:
                              emotionAnalysis.recommendations ?? [],
                          isMatchingLanguage: isMatchingLanguage,
                        ),

                        // 상세 분석 (있는 경우)
                        if (emotionAnalysis.detailedAnalysis != null) ...[
                          const SizedBox(height: 24),
                          _buildSectionHeader(
                            'diary.detailedAnalysis'.tr(),
                            AppColors.deepPurple,
                          ),
                          _buildTextBlock(
                            context,
                            text: emotionAnalysis.detailedAnalysis ?? '',
                            isMatchingLanguage: isMatchingLanguage,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // 분석 언어 표시 (언어가 다른 경우 알림)
                  if (!isMatchingLanguage) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.amber),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'diary.analyzedInDifferentLanguage'.tr(
                                args: [
                                  emotionAnalysis.language == 'ko'
                                      ? '한국어'
                                      : 'English',
                                ],
                              ),
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
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
    required String emotion,
    required bool isMatchingLanguage,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.deepPurple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        emotion,
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
    required List<String> keywords,
    required bool isMatchingLanguage,
  }) {
    // 키워드별 크기와 색상 랜덤 부여 (임팩트 있는 시각화)
    final List<Color> colors = [
      AppColors.joy.withOpacity(0.7),
      AppColors.sadness.withOpacity(0.7),
      AppColors.calm.withOpacity(0.7),
      AppColors.anxiety.withOpacity(0.7),
      AppColors.anger.withOpacity(0.7),
      AppColors.deepPurple.withOpacity(0.7),
    ];

    final random = DateTime.now().millisecondsSinceEpoch;
    final randomizedKeywords =
        keywords.asMap().entries.map((entry) {
          final index = entry.key;
          final keyword = entry.value;
          // 시드 값을 통해 항상 동일한 키워드는 동일한 스타일 적용
          final colorIndex = (keyword.hashCode + random) % colors.length;
          final fontSize = 14.0 + (index % 3) * 2.0; // 14, 16, 18 px

          return MapEntry(keyword, {
            'color': colors[colorIndex],
            'fontSize': fontSize,
          });
        }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children:
            randomizedKeywords.map((entry) {
              final keyword = entry.key;
              final style = entry.value;

              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  // 순차적으로 나타나도록 애니메이션 효과
                  final delay = randomizedKeywords.indexOf(entry) * 0.1;
                  final start = 0.5 + delay;
                  final end = 0.8 + delay;

                  final opacity =
                      _controller.value < start
                          ? 0.0
                          : _controller.value > end
                          ? 1.0
                          : (_controller.value - start) / (end - start);

                  return Opacity(opacity: opacity, child: child);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: style['color'] as Color,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    keyword,
                    style: TextStyle(
                      fontSize: style['fontSize'] as double,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  // 텍스트 블록 위젯
  Widget _buildTextBlock(
    BuildContext context, {
    required String text,
    required bool isMatchingLanguage,
  }) {
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
    required List<String> recommendations,
    required bool isMatchingLanguage,
  }) {
    final icons = [
      Icons.nature_people,
      Icons.self_improvement,
      Icons.spa,
      Icons.headphones,
      Icons.auto_stories,
      Icons.favorite,
      Icons.sports_handball,
      Icons.brush,
      Icons.music_note,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            recommendations.asMap().entries.map((entry) {
              final index = entry.key;
              final recommendation = entry.value;
              final iconIndex = index % icons.length;

              // 스케일 애니메이션 효과 (나타나는 순서대로)
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final delay = index * 0.15;
                  final start = 0.5 + delay;
                  final end = 0.7 + delay;

                  final scale =
                      _controller.value < start
                          ? 0.8
                          : _controller.value > end
                          ? 1.0
                          : 0.8 +
                              0.2 * (_controller.value - start) / (end - start);

                  final opacity =
                      _controller.value < start
                          ? 0.0
                          : _controller.value > end
                          ? 1.0
                          : (_controller.value - start) / (end - start);

                  return Opacity(
                    opacity: opacity,
                    child: Transform.scale(scale: scale, child: child),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: 0,
                    color: AppColors.lavender.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // 추천 활동 클릭 시 토스트 메시지 표시
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('diary.activitySaved'.tr()),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'diary.addToCalendar'.tr(),
                              onPressed: () {
                                // 캘린더에 추가 기능 (미구현)
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: [
                                  AppColors.joy,
                                  AppColors.calm,
                                  AppColors.deepPurple,
                                ][index % 3].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                icons[iconIndex],
                                color:
                                    [
                                      AppColors.joy,
                                      AppColors.calm,
                                      AppColors.deepPurple,
                                    ][index % 3],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recommendation,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer_outlined,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '5-10 ${context.locale.languageCode == 'ko' ? '분' : 'min'}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.bookmark_border,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
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
