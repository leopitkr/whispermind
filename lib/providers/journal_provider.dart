import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../services/journal_service.dart';
import '../models/emotion_journal_model.dart';

class JournalProvider extends ChangeNotifier {
  final JournalService _journalService = JournalService();

  List<EmotionJournalModel> _journals = [];
  EmotionJournalModel? _selectedJournal;
  bool _isLoading = false;
  String? _error;
  Map<String, int> _emotionStats = {};

  // 상태 getter
  List<EmotionJournalModel> get journals => _journals;
  EmotionJournalModel? get selectedJournal => _selectedJournal;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, int> get emotionStats => _emotionStats;

  // Stream 구독 처리를 위한 컨트롤러
  StreamSubscription<List<EmotionJournalModel>>? _journalsSubscription;

  // Provider 초기화 시 감정 일기 로드
  void init() {
    loadJournals();
    loadEmotionStats();
  }

  @override
  void dispose() {
    _journalsSubscription?.cancel();
    super.dispose();
  }

  // 모든 감정 일기 로드
  void loadJournals() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _journalsSubscription?.cancel();
    _journalsSubscription = _journalService.getUserJournals().listen(
      (journals) {
        _journals = journals;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _error = '감정 일기를 불러오는 데 실패했습니다: $e';
        notifyListeners();
      },
    );
  }

  // 특정 기간의 감정 일기 로드
  Future<void> loadJournalsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _journals = await _journalService.getJournalsByDateRange(
        startDate,
        endDate,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '감정 일기를 불러오는 데 실패했습니다: $e';
      notifyListeners();
    }
  }

  // 특정 감정 일기 상세 정보 로드
  Future<void> loadJournalById(String journalId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedJournal = await _journalService.getJournalById(journalId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '감정 일기를 불러오는 데 실패했습니다: $e';
      notifyListeners();
    }
  }

  // 새 감정 일기 추가
  Future<bool> addJournal({
    required String userId,
    required String emotion,
    required int emotionIntensity,
    required String content,
    String? summary,
    List<String>? keywords,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 새 일기 모델 생성
      EmotionJournalModel newJournal = EmotionJournalModel.create(
        userId: userId,
        emotion: emotion,
        emotionIntensity: emotionIntensity,
        content: content,
        summary: summary,
        keywords: keywords,
      );

      // Firestore에 저장
      await _journalService.addJournal(newJournal);

      // 감정 통계 다시 로드
      loadEmotionStats();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = '감정 일기 저장에 실패했습니다: $e';
      notifyListeners();
      return false;
    }
  }

  // 감정 일기 수정
  Future<bool> updateJournal(
    String journalId, {
    required String emotion,
    required int emotionIntensity,
    required String content,
    String? summary,
    List<String>? keywords,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 기존 일기 로드
      EmotionJournalModel? existingJournal =
          await _journalService.getJournalById(journalId);
      if (existingJournal == null) {
        throw Exception('일기를 찾을 수 없습니다');
      }

      // 업데이트할 일기 모델 생성
      EmotionJournalModel updatedJournal = EmotionJournalModel(
        id: journalId,
        userId: existingJournal.userId,
        emotion: emotion,
        emotionIntensity: emotionIntensity,
        content: content,
        summary: summary,
        keywords: keywords,
        createdAt: existingJournal.createdAt,
        updatedAt: Timestamp.now(),
      );

      // Firestore에 업데이트
      await _journalService.updateJournal(journalId, updatedJournal);

      // 선택된 일기가 있고, 그 ID가 업데이트된 일기의 ID와 같으면 선택된 일기도 업데이트
      if (_selectedJournal != null && _selectedJournal!.id == journalId) {
        _selectedJournal = updatedJournal;
      }

      // 감정 통계 다시 로드
      loadEmotionStats();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = '감정 일기 수정에 실패했습니다: $e';
      notifyListeners();
      return false;
    }
  }

  // 감정 일기 삭제
  Future<bool> deleteJournal(String journalId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _journalService.deleteJournal(journalId);

      // 선택된 일기가 있고, 그 ID가 삭제된 일기의 ID와 같으면 선택된 일기 초기화
      if (_selectedJournal != null && _selectedJournal!.id == journalId) {
        _selectedJournal = null;
      }

      // 감정 통계 다시 로드
      loadEmotionStats();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = '감정 일기 삭제에 실패했습니다: $e';
      notifyListeners();
      return false;
    }
  }

  // 감정별 통계 로드
  Future<void> loadEmotionStats() async {
    try {
      _emotionStats = await _journalService.getEmotionStats();
      notifyListeners();
    } catch (e) {
      _error = '감정 통계를 불러오는 데 실패했습니다: $e';
      notifyListeners();
    }
  }
}
