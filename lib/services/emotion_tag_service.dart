import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emotion_tag_model.dart';

/// 감정 태그 관리 서비스
class EmotionTagService {
  /// Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 감정 태그 컬렉션 참조
  CollectionReference get _tagsCollection =>
      _firestore.collection('emotion_tags');

  /// 싱글톤 패턴 구현
  static final EmotionTagService _instance = EmotionTagService._internal();

  factory EmotionTagService() {
    return _instance;
  }

  EmotionTagService._internal();

  /// 모든 감정 태그 가져오기
  Stream<List<EmotionTagModel>> getTags() {
    return _tagsCollection
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => EmotionTagModel.fromFirestore(doc))
                  .toList(),
        );
  }

  /// 기본 감정 태그 가져오기
  Stream<List<EmotionTagModel>> getDefaultTags() {
    return _tagsCollection
        .where('isDefault', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => EmotionTagModel.fromFirestore(doc))
                  .toList(),
        );
  }

  /// 특정 카테고리의 감정 태그 가져오기
  Stream<List<EmotionTagModel>> getTagsByCategory(String category) {
    return _tagsCollection
        .where('category', isEqualTo: category)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => EmotionTagModel.fromFirestore(doc))
                  .toList(),
        );
  }

  /// 감정 태그 추가
  Future<String> addTag(EmotionTagModel tag) async {
    try {
      DocumentReference docRef = await _tagsCollection.add(tag.toMap());
      print('감정 태그 추가 성공: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('감정 태그 추가 실패: $e');
      rethrow;
    }
  }

  /// 감정 태그 업데이트
  Future<void> updateTag(EmotionTagModel tag) async {
    try {
      await _tagsCollection.doc(tag.id).update(tag.toMap());
      print('감정 태그 업데이트 성공: ${tag.id}');
    } catch (e) {
      print('감정 태그 업데이트 실패: $e');
      rethrow;
    }
  }

  /// 감정 태그 삭제
  Future<void> deleteTag(String tagId) async {
    try {
      await _tagsCollection.doc(tagId).delete();
      print('감정 태그 삭제 성공: $tagId');
    } catch (e) {
      print('감정 태그 삭제 실패: $e');
      rethrow;
    }
  }

  /// 감정 태그 초기화 (기본 태그 생성)
  Future<void> initializeDefaultTags() async {
    try {
      // 기본 태그가 이미 존재하는지 확인
      QuerySnapshot existingTags =
          await _tagsCollection.where('isDefault', isEqualTo: true).get();

      if (existingTags.docs.isNotEmpty) {
        print('기본 감정 태그가 이미 존재합니다. 초기화를 건너뜁니다.');
        return;
      }

      // 기본 감정 태그 정의
      final List<Map<String, dynamic>> defaultTags = [
        {
          'name': '기쁨',
          'description': '만족과 행복을 느끼는 상태',
          'colorCode': '#FFD700', // 금색
          'category': '긍정적',
          'isDefault': true,
        },
        {
          'name': '평온',
          'description': '마음이 고요하고 안정된 상태',
          'colorCode': '#87CEEB', // 하늘색
          'category': '긍정적',
          'isDefault': true,
        },
        {
          'name': '슬픔',
          'description': '상실과 실망감을 느끼는 상태',
          'colorCode': '#6495ED', // 파란색
          'category': '부정적',
          'isDefault': true,
        },
        {
          'name': '분노',
          'description': '불만과 적대감을 느끼는 상태',
          'colorCode': '#FF4500', // 빨간색
          'category': '부정적',
          'isDefault': true,
        },
        {
          'name': '불안',
          'description': '걱정과 초조함을 느끼는 상태',
          'colorCode': '#9370DB', // 보라색
          'category': '부정적',
          'isDefault': true,
        },
        {
          'name': '그리움',
          'description': '과거나 누군가를 향한 애틋한 감정',
          'colorCode': '#DDA0DD', // 연보라색
          'category': '중립적',
          'isDefault': true,
        },
      ];

      // 일괄 처리를 위한 배치 작업
      WriteBatch batch = _firestore.batch();

      // 각 태그 추가
      for (var tagData in defaultTags) {
        DocumentReference docRef = _tagsCollection.doc();
        batch.set(docRef, {
          ...tagData,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 배치 실행
      await batch.commit();
      print('기본 감정 태그 초기화 완료');
    } catch (e) {
      print('기본 감정 태그 초기화 실패: $e');
      rethrow;
    }
  }
}
