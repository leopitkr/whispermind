import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../providers/diary_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/diary.dart';
import '../../models/location.dart';
import '../../widgets/common/emotion_selector.dart';
import '../../widgets/common/tag_manager.dart';
import '../../widgets/common/location_picker.dart';
import '../../widgets/common/media_uploader.dart';

class DiaryWritePage extends StatefulWidget {
  const DiaryWritePage({Key? key}) : super(key: key);

  @override
  _DiaryWritePageState createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedEmotion = '평온';
  int _emotionIntensity = 5;
  final List<String> _tags = [];
  bool _isLoading = false;
  Location? _location;
  List<MediaItem> _media = [];

  final List<Map<String, dynamic>> _emotions = [
    {
      'name': '평온',
      'icon': CupertinoIcons.sun_max_fill,
      'color': AppColors.calm,
    },
    {'name': '기쁨', 'icon': CupertinoIcons.heart_fill, 'color': AppColors.joy},
    {
      'name': '슬픔',
      'icon': CupertinoIcons.cloud_rain_fill,
      'color': AppColors.sadness,
    },
    {'name': '분노', 'icon': CupertinoIcons.flame_fill, 'color': AppColors.anger},
    {
      'name': '불안',
      'icon': CupertinoIcons.exclamationmark_circle_fill,
      'color': AppColors.anxiety,
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveDiary() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);

      final success = await diaryProvider.createDiary(
        userId: authProvider.user!.uid,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        emotion: _selectedEmotion,
        emotionIntensity: _emotionIntensity,
        tags: _tags,
      );

      if (success && mounted) {
        context.go('/diary'); // 일기 리스트 페이지로 이동
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(diaryProvider.errorMessage ?? '일기 저장 중 오류가 발생했습니다'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTagInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('태그', style: AppTextStyles.headingSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._tags.map(
              (tag) => Chip(
                label: Text(tag),
                onDeleted: () {
                  setState(() {
                    _tags.remove(tag);
                  });
                },
              ),
            ),
            ActionChip(
              label: const Text('+ 태그 추가'),
              onPressed: () async {
                final controller = TextEditingController();
                final result = await showDialog<String>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('태그 추가'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: '태그를 입력하세요',
                          ),
                          onSubmitted: (value) {
                            Navigator.of(context).pop(value);
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(controller.text);
                            },
                            child: const Text('추가'),
                          ),
                        ],
                      ),
                );

                if (result != null && result.isNotEmpty) {
                  setState(() {
                    _tags.add(result.trim());
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 작성'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveDiary,
            child:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 입력
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 감정 선택
              Text('오늘의 감정', style: AppTextStyles.headingSmall),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      _emotions.map((emotion) {
                        final isSelected = emotion['name'] == _selectedEmotion;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Row(
                              children: [
                                Icon(
                                  emotion['icon'],
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : emotion['color'],
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  emotion['name'],
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            selected: isSelected,
                            selectedColor: emotion['color'],
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedEmotion = emotion['name'];
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // 감정 강도 선택
              Text('감정 강도', style: AppTextStyles.headingSmall),
              const SizedBox(height: 8),
              Slider(
                value: _emotionIntensity.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _emotionIntensity.toString(),
                onChanged: (value) {
                  setState(() {
                    _emotionIntensity = value.round();
                  });
                },
              ),
              const SizedBox(height: 16),

              // 내용 입력
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: '내용',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 태그 입력
              _buildTagInput(),

              // 위치 정보
              LocationPicker(
                location: _location,
                onLocationSelect: (location) {
                  setState(() => _location = location);
                },
              ),
              const SizedBox(height: 16),

              // 미디어 업로드
              MediaUploader(
                media: _media,
                onMediaAdd: (media) {
                  setState(() => _media.add(media));
                },
                onMediaRemove: (media) {
                  setState(() => _media.remove(media));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
