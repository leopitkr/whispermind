import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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
  State<DiaryWritePage> createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Emotion? _selectedEmotion;
  int _emotionIntensity = 50;
  List<String> _tags = [];
  Location? _location;
  List<MediaItem> _media = [];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveDiary() {
    if (_formKey.currentState!.validate()) {
      // TODO: 일기 저장 로직 구현
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('yyyy년 MM월 dd일').format(DateTime.now()),
          style: AppTextStyles.headingSmall,
        ),
        actions: [
          TextButton(
            onPressed: _saveDiary,
            child: Text('저장', style: AppTextStyles.highlight),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 감정 선택
              Text('오늘의 감정', style: AppTextStyles.cardTitle),
              const SizedBox(height: 8),
              EmotionSelector(
                selectedEmotion: _selectedEmotion,
                intensity: _emotionIntensity,
                onEmotionSelected: (emotion) {
                  setState(() => _selectedEmotion = emotion);
                },
                onIntensityChanged: (value) {
                  setState(() => _emotionIntensity = value);
                },
              ),
              const SizedBox(height: 24),

              // 제목 입력
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '제목을 입력하세요',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.midGray,
                  ),
                  border: InputBorder.none,
                ),
                style: AppTextStyles.headingSmall,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 본문 입력
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '오늘 하루는 어땠나요?',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.midGray,
                  ),
                  border: InputBorder.none,
                ),
                style: AppTextStyles.bodyLarge,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 태그 관리
              TagManager(
                tags: _tags,
                onTagAdd: (tag) {
                  setState(() => _tags.add(tag));
                },
                onTagRemove: (tag) {
                  setState(() => _tags.remove(tag));
                },
              ),
              const SizedBox(height: 16),

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
