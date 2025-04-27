import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/text_styles.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('감정 일기', style: AppTextStyles.headingMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {
              // 검색 기능
            },
            color: AppColors.darkGray,
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.calendar),
            onPressed: () {
              // 달력 보기
            },
            color: AppColors.darkGray,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 감정별 필터 칩
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip('전체', true),
                  _buildFilterChip('행복', false),
                  _buildFilterChip('평온', false),
                  _buildFilterChip('슬픔', false),
                  _buildFilterChip('그리움', false),
                  _buildFilterChip('불안', false),
                  _buildFilterChip('분노', false),
                ],
              ),
            ),
          ),

          // 감정 일기 목록 (샘플 데이터)
          _buildJournalItem(
            emotion: '행복',
            date: '2023년 8월 15일',
            content: '오늘은 가족들과 함께 해변에서 즐거운 시간을 보냈다. 파도 소리와 함께한 피크닉이 정말 행복했다.',
          ),
          _buildJournalItem(
            emotion: '평온',
            date: '2023년 8월 14일',
            content:
                '아침 요가와 명상으로 하루를 시작했다. 마음이 평온해지는 느낌이 들었고 하루 종일 차분한 상태를 유지할 수 있었다.',
          ),
          _buildJournalItem(
            emotion: '슬픔',
            date: '2023년 8월 12일',
            content: '오랜 친구와 연락이 끊겼다는 소식을 들었다. 함께했던 추억들이 떠올라 마음이 무거웠다.',
          ),
          _buildJournalItem(
            emotion: '그리움',
            date: '2023년 8월 10일',
            content: '고향에 계신 부모님이 생각났다. 다음 주말에는 꼭 방문하기로 마음 먹었다.',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // 필터 선택 처리
        },
        backgroundColor: AppColors.offWhite,
        selectedColor: AppColors.lavender.withOpacity(0.2),
        checkmarkColor: AppColors.deepPurple,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.deepPurple : AppColors.darkGray,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _buildJournalItem({
    required String emotion,
    required String date,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lightGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lavender.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    emotion,
                    style: TextStyle(
                      color: AppColors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(color: AppColors.midGray, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 14,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // 상세 보기
                },
                child: Text(
                  '더보기',
                  style: TextStyle(
                    color: AppColors.deepPurple,
                    fontWeight: FontWeight.bold,
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
