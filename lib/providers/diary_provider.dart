import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_model.dart';
import '../services/diary_service.dart';

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
  void loadUserDiaries(String userId) {
    _diaryService
        .getUserDiaries(userId)
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
}
