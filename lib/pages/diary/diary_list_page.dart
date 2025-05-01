import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/diary.dart';
import '../../models/location.dart';
import '../../providers/auth_provider.dart';
import '../../providers/diary_provider.dart';
import 'diary_write_page.dart';
import 'diary_detail_page.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class DiaryListPage extends StatefulWidget {
  const DiaryListPage({Key? key}) : super(key: key);

  @override
  State<DiaryListPage> createState() => _DiaryListPageState();
}

class _DiaryListPageState extends State<DiaryListPage> {
  @override
  void initState() {
    super.initState();
    // 데이터 로딩을 microtask로 스케줄링
    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
      diaryProvider.loadUserDiaries(authProvider.user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Consumer를 사용하여 Provider 상태 변경 감지
    return Consumer<DiaryProvider>(
      builder: (context, diaryProvider, child) {
        final diaries = diaryProvider.diaries;

        return Scaffold(
          appBar: AppBar(
            title: Text('일기', style: AppTextStyles.headingMedium),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => GoRouter.of(context).push('/diary/write'),
              ),
            ],
          ),
          body:
              diaryProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : diaries.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_note,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '아직 작성된 일기가 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed:
                              () => GoRouter.of(context).push('/diary/write'),
                          child: const Text('첫 일기 작성하기'),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: diaries.length,
                    itemBuilder: (context, index) {
                      final diary = diaries[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap:
                              () => GoRouter.of(
                                context,
                              ).push('/diary/${diary.id}'),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        diary.title,
                                        style: AppTextStyles.bodyLarge,
                                      ),
                                    ),
                                    Text(
                                      DateFormat(
                                        'yyyy.MM.dd',
                                      ).format(diary.createdAt),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                if (diary.emotion.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: _getEmotionColor(
                                            diary.emotion,
                                          ).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          diary.emotion,
                                          style: TextStyle(
                                            color: _getEmotionColor(
                                              diary.emotion,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Text(
                                  diary.content,
                                  style: AppTextStyles.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (diary.tags.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 4,
                                    children:
                                        diary.tags.map((tag) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              tag,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        );
      },
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
