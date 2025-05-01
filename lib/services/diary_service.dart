import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/diary_model.dart';
import '../services/ai_service.dart';

class DiaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'diaries';

  // 일기 작성
  Future<DiaryModel> createDiary({
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
    try {
      final now = DateTime.now();
      final docRef = _firestore.collection(_collection).doc();

      final diary = DiaryModel(
        id: docRef.id,
        userId: userId,
        title: title,
        content: content,
        emotion: emotion,
        emotionIntensity: emotionIntensity,
        tags: tags,
        mediaUrls: mediaUrls,
        location: location,
        locationAddress: locationAddress,
        createdAt: now,
        updatedAt: now,
      );

      await docRef.set(diary.toMap());
      return diary;
    } catch (e) {
      print('Error creating diary: $e');
      rethrow;
    }
  }

  // 일기 수정
  Future<void> updateDiary(DiaryModel diary) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(diary.id)
          .update(diary.toMap());
    } catch (e) {
      print('Error updating diary: $e');
      rethrow;
    }
  }

  // 일기 삭제
  Future<void> deleteDiary(String diaryId) async {
    try {
      await _firestore.collection(_collection).doc(diaryId).delete();
    } catch (e) {
      print('Error deleting diary: $e');
      rethrow;
    }
  }

  // 특정 일기 조회
  Future<DiaryModel?> getDiary(String diaryId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(diaryId).get();
      if (!doc.exists) return null;
      return DiaryModel.fromFirestore(doc);
    } catch (e) {
      print('Error getting diary: $e');
      rethrow;
    }
  }

  // 사용자의 모든 일기 조회
  Future<QuerySnapshot> getUserDiaries(String userId) async {
    try {
      return await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();
    } catch (e) {
      print('Error getting user diaries: $e');
      rethrow;
    }
  }

  // 특정 기간 동안의 일기 조회
  Stream<List<DiaryModel>> getDiariesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    try {
      return _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          )
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs
                    .map((doc) => DiaryModel.fromFirestore(doc))
                    .toList(),
          );
    } catch (e) {
      print('Error getting diaries by date range: $e');
      rethrow;
    }
  }

  // 특정 감정의 일기 조회
  Stream<List<DiaryModel>> getDiariesByEmotion(String userId, String emotion) {
    try {
      return _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('emotion', isEqualTo: emotion)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs
                    .map((doc) => DiaryModel.fromFirestore(doc))
                    .toList(),
          );
    } catch (e) {
      print('Error getting diaries by emotion: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> fetchLatestDiary(String userId) async {
    final snapshot =
        await _firestore
            .collection('diaries')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      // Firestore 문서 ID도 함께 반환
      return {'id': doc.id, ...doc.data()};
    }
    return null;
  }

  /// 감정분석 결과를 emotion_analyses 컬렉션에 저장
  Future<void> saveEmotionAnalysis(
    String journalId,
    Map<String, dynamic> analysis,
  ) async {
    try {
      debugPrint('감정분석 결과 저장 시작 (journalId: $journalId)');
      final docRef = _firestore.collection('emotion_analyses').doc();
      final data = {
        'journalId': journalId,
        'primaryEmotion':
            analysis['primaryEmotion'] ?? analysis['emotion'] ?? '',
        'emotionKeywords': List<String>.from(
          analysis['emotionKeywords'] ?? analysis['keywords'] ?? [],
        ),
        'intensityScore':
            (analysis['intensityScore'] ?? analysis['intensity'] ?? 0)
                .toDouble(),
        'patternIdentified':
            analysis['patternIdentified'] ?? analysis['insight'] ?? '',
        'recommendations': List<String>.from(
          analysis['recommendations'] ?? analysis['recommend'] ?? [],
        ),
        'createdAt': Timestamp.now(),
      };

      debugPrint('감정분석 데이터: $data');
      await docRef.set(data);
      debugPrint('✅ 감정분석 결과 저장 완료: ${docRef.id}');
    } catch (e) {
      debugPrint('❌ 감정분석 결과 저장 실패: $e');
      rethrow;
    }
  }

  /// Firestore에서 최근 일기를 불러와 GPT로 감정분석 후 결과를 저장
  Future<void> analyzeLatestDiaryAndSave({
    required String userId,
    required String openAIApiKey,
  }) async {
    final latestDiary = await fetchLatestDiary(userId);
    if (latestDiary == null) return;

    final diaryId = latestDiary['id'];
    final diaryText = latestDiary['content'];

    // AIService를 통해 감정분석 요청
    final aiService = AIService(apiKey: openAIApiKey);
    final analysis = await aiService.analyzeEmotion(diaryText);
    if (analysis != null) {
      await saveEmotionAnalysis(diaryId, analysis);
    }
  }

  /// 일기 작성 후 바로 감정분석을 실행하고 결과를 저장
  Future<DiaryModel> createDiaryAndAnalyze({
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
    try {
      debugPrint('✨ 감정분석이 포함된 일기 저장 시작');

      // 1. 일기 저장
      debugPrint('1. 일기 저장');
      final diary = await createDiary(
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
      debugPrint('일기 저장 완료: ${diary.id}');

      // 2. 감정분석 요청
      debugPrint('2. OpenAI를 통한 감정분석 요청');
      final aiService = AIService(apiKey: openAIApiKey);
      final analysis = await aiService.analyzeEmotion(content);

      // 3. 감정분석 결과 저장
      if (analysis != null) {
        debugPrint('3. 감정분석 결과 저장');
        await saveEmotionAnalysis(diary.id, analysis);
        debugPrint('✅ 전체 과정 완료: 일기 저장 + 감정분석 + 결과 저장');
      } else {
        debugPrint('⚠️ 감정분석 결과가 null이어서 저장하지 않음');
      }

      return diary;
    } catch (e) {
      debugPrint('❌ 감정분석이 포함된 일기 저장 실패: $e');
      rethrow;
    }
  }

  /// 테스트용: emotion_analyses 컬렉션에 샘플 데이터 직접 저장
  Future<void> saveSampleEmotionAnalysis() async {
    try {
      debugPrint('테스트용 샘플 감정분석 데이터 저장 시작');
      final docRef = _firestore.collection('emotion_analyses').doc();
      final data = {
        'journalId': 'test_diary_id',
        'primaryEmotion': '기쁨',
        'emotionKeywords': ['행복', '감사', '여유'],
        'intensityScore': 0.9,
        'patternIdentified': '긍정적 변화가 감지됨',
        'recommendations': ['산책하기', '명상 10분'],
        'createdAt': Timestamp.now(),
      };

      await docRef.set(data);
      debugPrint('✅ 테스트용 샘플 감정분석 저장 완료: ${docRef.id}');
    } catch (e) {
      debugPrint('❌ 테스트용 샘플 감정분석 저장 실패: $e');
      rethrow;
    }
  }
}
