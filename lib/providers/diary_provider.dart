import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_model.dart';
import '../services/diary_service.dart';
import 'package:flutter/foundation.dart';

class DiaryProvider extends ChangeNotifier {
  final DiaryService _diaryService;
  List<DiaryModel> _diaries = [];
  bool _isLoading = false;
  String? _errorMessage;

  DiaryProvider(this._diaryService);

  List<DiaryModel> get diaries => _diaries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 일기 작성
  Future<bool> createDiary({
    required String userId,
    required String title,
    required String content,
    required String emotion,
    required int emotionIntensity,
    List<String> tags = const [],
    List<String> mediaUrls = const [],
    GeoPoint? location,
    String? locationAddress,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _diaryService.createDiary(
        userId: userId,
        title: title,
        content: content,
        emotion: emotion,
        emotionIntensity: emotionIntensity,
        tags: tags,
        mediaUrls: mediaUrls,
        location: location,
        locationAddress: locationAddress,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 일기 작성 (감정분석 포함)
  Future<bool> createDiaryWithAnalysis({
    required String userId,
    required String title,
    required String content,
    required String emotion,
    required int emotionIntensity,
    List<String> tags = const [],
    List<String> mediaUrls = const [],
    GeoPoint? location,
    String? locationAddress,
    required String openAIApiKey,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _diaryService.createDiaryAndAnalyze(
        userId: userId,
        title: title,
        content: content,
        emotion: emotion,
        emotionIntensity: emotionIntensity,
        tags: tags,
        mediaUrls: mediaUrls,
        location: location,
        locationAddress: locationAddress,
        openAIApiKey: openAIApiKey,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint('Error creating diary with analysis: $e');
      return false;
    }
  }

  // 일기 수정
  Future<bool> updateDiary(DiaryModel diary) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _diaryService.updateDiary(diary);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 일기 삭제
  Future<bool> deleteDiary(String diaryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _diaryService.deleteDiary(diaryId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 사용자의 일기 목록 불러오기
  Future<void> loadUserDiaries(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final querySnapshot = await _diaryService.getUserDiaries(userId);
      _diaries =
          querySnapshot.docs
              .map((doc) => DiaryModel.fromFirestore(doc))
              .toList();

      // 최신순으로 정렬
      _diaries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Error loading diaries: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 특정 기간의 일기 목록 불러오기
  void loadDiariesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    _diaryService
        .getDiariesByDateRange(userId, startDate, endDate)
        .listen(
          (diaries) {
            _diaries = diaries;
            notifyListeners();
          },
          onError: (e) {
            _errorMessage = e.toString();
            notifyListeners();
          },
        );
  }

  // 특정 감정의 일기 목록 불러오기
  void loadDiariesByEmotion(String userId, String emotion) {
    _diaryService
        .getDiariesByEmotion(userId, emotion)
        .listen(
          (diaries) {
            _diaries = diaries;
            notifyListeners();
          },
          onError: (e) {
            _errorMessage = e.toString();
            notifyListeners();
          },
        );
  }

  // 에러 메시지 초기화
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 테스트용 샘플 감정분석 저장
  Future<void> saveSampleEmotionAnalysis() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _diaryService.saveSampleEmotionAnalysis();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
