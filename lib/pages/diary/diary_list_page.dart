import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/diary.dart';
import '../../models/location.dart';
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
  List<Diary> _diaries = [];

  @override
  void initState() {
    super.initState();
    _loadDiaries();
  }

  void _loadDiaries() {
    // TODO: API에서 일기 목록을 가져오는 로직 구현
    setState(() {
      _diaries = [
        Diary(
          id: '1',
          title: '오늘의 일기',
          content:
              '오늘은 정말 좋은 하루였습니다. 아침에 일찍 일어나서 공원에서 산책을 했고, 점심에는 맛있는 음식을 먹었습니다. 오후에는 친구들과 만나서 즐거운 시간을 보냈습니다.',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          emotion: Emotion(
            id: 'happy',
            name: '행복',
            emoji: '😊',
            color: const Color(0xFFFFD700),
          ),
          emotionIntensity: 80,
          tags: ['행복', '여행'],
          location: Location(
            latitude: 37.5665,
            longitude: 126.9780,
            address: '서울특별시 중구 세종대로 110',
          ),
          media: [],
        ),
        Diary(
          id: '2',
          title: '기분 좋은 하루',
          content:
              '오늘은 새로운 도전을 시작했습니다. 처음에는 조금 두려웠지만, 막상 시작해보니 생각보다 잘 할 수 있었습니다. 앞으로도 계속 도전해보려고 합니다.',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          emotion: Emotion(
            id: 'excited',
            name: '설렘',
            emoji: '🤩',
            color: const Color(0xFFFF69B4),
          ),
          emotionIntensity: 70,
          tags: ['도전', '성장'],
          location: null,
          media: [],
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _diaries.length,
        itemBuilder: (context, index) {
          final diary = _diaries[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => GoRouter.of(context).push('/diary/${diary.id}'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            diary.title,
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                        Text(
                          DateFormat('yyyy.MM.dd').format(diary.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    if (diary.emotion != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            diary.emotion!.emoji,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            diary.emotion!.name,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      diary.content,
                      style: AppTextStyles.body,
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
                                  borderRadius: BorderRadius.circular(12),
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
  }
}
