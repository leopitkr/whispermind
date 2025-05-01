import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_model.dart';

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
  Stream<List<DiaryModel>> getUserDiaries(String userId) {
    try {
      return _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs
                    .map((doc) => DiaryModel.fromFirestore(doc))
                    .toList(),
          );
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
}
