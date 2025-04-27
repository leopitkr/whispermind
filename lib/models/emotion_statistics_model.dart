import 'package:cloud_firestore/cloud_firestore.dart';

/// 감정 통계 모델 클래스
class EmotionStatisticsModel {
  final String id;
  final String userId;
  final Timestamp date;
  final String periodType; // 'daily', 'weekly', 'monthly', 'yearly'
  final Map<String, dynamic> emotionDistribution;
  final String primaryEmotion;
  final double averageIntensity;
  final int journalCount;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  EmotionStatisticsModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.periodType,
    required this.emotionDistribution,
    required this.primaryEmotion,
    required this.averageIntensity,
    required this.journalCount,
    required this.createdAt,
    this.updatedAt,
  });

  /// Firestore에서 데이터를 가져와 EmotionStatisticsModel 객체로 변환
  factory EmotionStatisticsModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return EmotionStatisticsModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      date: data['date'] ?? Timestamp.now(),
      periodType: data['periodType'] ?? 'daily',
      emotionDistribution: Map<String, dynamic>.from(
        data['emotionDistribution'] ?? {},
      ),
      primaryEmotion: data['primaryEmotion'] ?? '',
      averageIntensity: (data['averageIntensity'] ?? 0).toDouble(),
      journalCount: data['journalCount'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  /// EmotionStatisticsModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date,
      'periodType': periodType,
      'emotionDistribution': emotionDistribution,
      'primaryEmotion': primaryEmotion,
      'averageIntensity': averageIntensity,
      'journalCount': journalCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  /// 새로운 감정 통계 생성 시 사용
  factory EmotionStatisticsModel.create({
    required String userId,
    required Timestamp date,
    required String periodType,
    required Map<String, dynamic> emotionDistribution,
    required String primaryEmotion,
    required double averageIntensity,
    required int journalCount,
  }) {
    return EmotionStatisticsModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      userId: userId,
      date: date,
      periodType: periodType,
      emotionDistribution: emotionDistribution,
      primaryEmotion: primaryEmotion,
      averageIntensity: averageIntensity,
      journalCount: journalCount,
      createdAt: Timestamp.now(),
    );
  }
}
