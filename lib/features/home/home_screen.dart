import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/text_styles.dart';
import '../../widgets/common/emotion_card.dart';
import '../../widgets/common/activity_card.dart';
import '../../widgets/common/activity_card_list.dart';
import '../../widgets/common/emotion_summary_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        Text('안녕하세요, 홍길동님', style: AppTextStyles.bodyLarge),
                      ],
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.lavender.withOpacity(0.2),
                      child: Icon(
                        CupertinoIcons.person_fill,
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 오늘의 감정
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
                      Text('오늘의 감정', style: AppTextStyles.cardTitle),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  CupertinoIcons.sun_max_fill,
                                  color: AppColors.calm,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '평온함',
                                    style: AppTextStyles.headingSmall.copyWith(
                                      color: AppColors.calm,
                                    ),
                                  ),
                                  Text(
                                    '오늘 09:15에 기록됨',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.deepPurple,
                              minimumSize: const Size(48, 38),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('기록하기'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 최근 감정 일기
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('최근 감정 일기', style: AppTextStyles.headingSmall),
                    TextButton(
                      onPressed: () {},
                      child: Text('더보기', style: AppTextStyles.highlight),
                    ),
                  ],
                ),
              ),
            ),

            // 최근 감정 일기 목록
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    EmotionCard(
                      emotionName: '평온',
                      emotionIcon: CupertinoIcons.sun_max_fill,
                      date: '오늘 09:15',
                      previewText:
                          '오늘은 일찍 일어나 명상으로 하루를 시작했다. 창문 밖으로 보이는 새벽 풍경이 마음을 차분하게 해주었다.',
                      onTap: () {},
                    ),
                    EmotionCard(
                      emotionName: '희망',
                      emotionIcon: CupertinoIcons.heart_fill,
                      date: '어제 17:30',
                      previewText:
                          '새로운 프로젝트를 시작하게 되었다. 비록 도전적인 과제이지만 잘 해낼 수 있을 것 같은 긍정적인 마음이 든다.',
                      onTap: () {},
                    ),
                    EmotionCard(
                      emotionName: '슬픔',
                      emotionIcon: CupertinoIcons.cloud_rain_fill,
                      date: '2일 전 20:45',
                      previewText:
                          '오랜 친구와 연락이 끊겼다는 소식을 들었다. 함께했던 추억들이 떠올라 마음이 무거웠다.',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // 추천 활동
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('추천 활동', style: AppTextStyles.headingSmall),
                    TextButton(
                      onPressed: () {},
                      child: Text('모두 보기', style: AppTextStyles.highlight),
                    ),
                  ],
                ),
              ),
            ),

            // 추천 활동 카드 목록
            SliverToBoxAdapter(
              child: ActivityCardList(
                activities: [
                  ActivityCard(
                    title: '5분 호흡 명상',
                    description: '마음의 안정을 찾는 짧은 호흡 명상',
                    icon: CupertinoIcons.wind,
                    onTap: () {},
                  ),
                  ActivityCard(
                    title: '감사 일기',
                    description: '오늘 감사한 순간 3가지 기록하기',
                    icon: CupertinoIcons.pencil,
                    onTap: () {},
                  ),
                  ActivityCard(
                    title: '미래에게 편지',
                    description: '6개월 후의 나에게 타임캡슐 보내기',
                    icon: CupertinoIcons.mail,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // 감정 요약 차트
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: EmotionSummaryChart(
                  title: '주간 감정 흐름',
                  emotions: [
                    EmotionData(date: '월', emotion: '슬픔', intensity: 3.5),
                    EmotionData(date: '화', emotion: '슬픔', intensity: 4.0),
                    EmotionData(date: '수', emotion: '불안', intensity: 5.2),
                    EmotionData(date: '목', emotion: '희망', intensity: 6.8),
                    EmotionData(date: '금', emotion: '희망', intensity: 7.3),
                    EmotionData(date: '토', emotion: '그리움', intensity: 5.6),
                    EmotionData(date: '일', emotion: '평온', intensity: 8.2),
                  ],
                  onTap: () {},
                ),
              ),
            ),

            // 다가오는 기념일
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                        children: [
                          Icon(
                            CupertinoIcons.calendar,
                            color: AppColors.deepPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('다가오는 기념일', style: AppTextStyles.cardTitle),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.longing.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '25',
                                style: AppTextStyles.headingSmall.copyWith(
                                  color: AppColors.longing,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('할머니 생신', style: AppTextStyles.cardTitle),
                              Text(
                                '5월 25일 토요일',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'D-7',
                            style: AppTextStyles.headingSmall.copyWith(
                              color: AppColors.longing,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
