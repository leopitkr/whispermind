import 'package:cloud_firestore/cloud_firestore.dart';

class EmotionJournalModel {
  final String id;
  final String userId;
  final String emotion;
  final int emotionIntensity;
  final String content;
  final String? summary;
  final List<String>? keywords;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  EmotionJournalModel({
    required this.id,
    required this.userId,
    required this.emotion,
    required this.emotionIntensity,
    required this.content,
    this.summary,
    this.keywords,
    required this.createdAt,
    this.updatedAt,
  });

  // Firestore에서 데이터를 가져와 EmotionJournalModel 객체로 변환
  factory EmotionJournalModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return EmotionJournalModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      emotion: data['emotion'] ?? '',
      emotionIntensity: data['emotionIntensity'] ?? 5,
      content: data['content'] ?? '',
      summary: data['summary'],
      keywords: List<String>.from(data['keywords'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  // EmotionJournalModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'emotion': emotion,
      'emotionIntensity': emotionIntensity,
      'content': content,
      'summary': summary,
      'keywords': keywords ?? [],
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  // 새로운 일기 생성 시 사용
  factory EmotionJournalModel.create({
    required String userId,
    required String emotion,
    required int emotionIntensity,
    required String content,
    String? summary,
    List<String>? keywords,
  }) {
    return EmotionJournalModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      userId: userId,
      emotion: emotion,
      emotionIntensity: emotionIntensity,
      content: content,
      summary: summary,
      keywords: keywords,
      createdAt: Timestamp.now(),
    );
  }
}
