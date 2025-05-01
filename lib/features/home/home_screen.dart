import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../widgets/common/emotion_card.dart';
import '../../widgets/common/activity_card.dart';
import '../../widgets/common/activity_card_list.dart';
import '../../widgets/common/emotion_summary_chart.dart';
import '../../providers/auth_provider.dart';
import '../../providers/emotion_analytics_provider.dart';
import 'bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final analyticsProvider = Provider.of<EmotionAnalyticsProvider>(context);
    final userEmail = authProvider.user?.email ?? '';
    final displayName =
        authProvider.userModel?.displayName ?? userEmail.split('@')[0];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 헤더 (앱 로고와 사용자 인사말, 프로필 아이콘)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WhisperMind',
                          style: AppTextStyles.headingLarge.copyWith(
                            color: AppColors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '안녕하세요, $displayName님',
                          style: AppTextStyles.bodyLarge,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.lavender.withOpacity(0.2),
                        child: Icon(
                          CupertinoIcons.person_fill,
                          color: AppColors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 감정 분석 대시보드
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.purpleGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('감정 분석 인사이트', style: AppTextStyles.cardTitle),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  analyticsProvider.dominantEmotion,
                                  style: AppTextStyles.headingMedium.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                Text(
                                  '이번 주 주요 감정',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              analyticsProvider.dominantEmotionIcon,
                              color: analyticsProvider.dominantEmotionColor,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        analyticsProvider.emotionInsight,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 감정 변화 그래프
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: EmotionSummaryChart(
                  title: '감정 변화 트렌드',
                  emotions: analyticsProvider.weeklyEmotions,
                  onTap: () => context.push('/statistics'),
                ),
              ),
            ),

            // 특별한 순간들
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('특별한 순간들', style: AppTextStyles.headingSmall),
                    TextButton(
                      onPressed: () => context.push('/diary'),
                      child: Text('더보기', style: AppTextStyles.highlight),
                    ),
                  ],
                ),
              ),
            ),

            // 특별한 순간 일기 목록
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: analyticsProvider.specialMoments.length,
                  itemBuilder: (context, index) {
                    final moment = analyticsProvider.specialMoments[index];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                moment.emotionIcon,
                                color: moment.emotionColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                moment.emotion,
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            moment.content,
                            style: AppTextStyles.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Text(
                            moment.date,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.midGray,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // 맞춤 추천 활동
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('맞춤 추천 활동', style: AppTextStyles.headingSmall),
                    TextButton(
                      onPressed: () {},
                      child: Text('모두 보기', style: AppTextStyles.highlight),
                    ),
                  ],
                ),
              ),
            ),

            // 추천 활동 목록
            SliverToBoxAdapter(
              child: ActivityCardList(
                activities:
                    analyticsProvider.recommendedActivities
                        .map(
                          (activity) => ActivityCard(
                            title: activity.title,
                            description: activity.description,
                            icon: activity.icon,
                            onTap: () {},
                          ),
                        )
                        .toList(),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }
}
