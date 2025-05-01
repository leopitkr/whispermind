import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 헤더
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '감정 일기',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.deepPurple,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.search,
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 필터 옵션
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('전체'),
                      selected: true,
                      onSelected: (bool selected) {},
                      backgroundColor: AppColors.lavender.withOpacity(0.2),
                      selectedColor: AppColors.primary,
                      labelStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('이번 주'),
                      selected: false,
                      onSelected: (bool selected) {},
                      backgroundColor: AppColors.lavender.withOpacity(0.2),
                      selectedColor: AppColors.primary,
                      labelStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('이번 달'),
                      selected: false,
                      onSelected: (bool selected) {},
                      backgroundColor: AppColors.lavender.withOpacity(0.2),
                      selectedColor: AppColors.primary,
                      labelStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 일기 목록
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.lavender.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      CupertinoIcons.heart_fill,
                                      color: AppColors.joy,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '행복한 하루',
                                          style: AppTextStyles.headingSmall,
                                        ),
                                        Text(
                                          '2024년 4월 19일',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColors.darkGray,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      CupertinoIcons.ellipsis_vertical,
                                      color: AppColors.darkGray,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '오늘은 정말 좋은 하루였다. 아침에 일찍 일어나서 공원을 산책했는데, 날씨가 너무 좋았다. 새소리를 들으며 걷다 보니 마음이 평온해졌다.',
                                style: AppTextStyles.body,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children: [
                                  Chip(
                                    label: const Text('행복'),
                                    backgroundColor: AppColors.lavender
                                        .withOpacity(0.2),
                                    labelStyle: AppTextStyles.bodySmall
                                        .copyWith(color: AppColors.deepPurple),
                                  ),
                                  Chip(
                                    label: const Text('산책'),
                                    backgroundColor: AppColors.lavender
                                        .withOpacity(0.2),
                                    labelStyle: AppTextStyles.bodySmall
                                        .copyWith(color: AppColors.deepPurple),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }, childCount: 10),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(CupertinoIcons.pen),
      ),
    );
  }
}
