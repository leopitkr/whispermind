import 'package:cloud_firestore/cloud_firestore.dart';

/// 일기-태그 연결 모델 클래스
class JournalTagModel {
  final String id;
  final String journalId;
  final String tagId;

  JournalTagModel({
    required this.id,
    required this.journalId,
    required this.tagId,
  });

  /// Firestore에서 데이터를 가져와 JournalTagModel 객체로 변환
  factory JournalTagModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return JournalTagModel(
      id: doc.id,
      journalId: data['journalId'] ?? '',
      tagId: data['tagId'] ?? '',
    );
  }

  /// JournalTagModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {'journalId': journalId, 'tagId': tagId};
  }

  /// 새로운 연결 생성 시 사용
  factory JournalTagModel.create({
    required String journalId,
    required String tagId,
  }) {
    return JournalTagModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      journalId: journalId,
      tagId: tagId,
    );
  }
}
