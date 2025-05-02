import 'package:cloud_firestore/cloud_firestore.dart';

/// 감정 분석 모델 클래스
class EmotionAnalysisModel {
  final String id;
  final String journalId;
  final String primaryEmotion;
  final List<String> emotionKeywords;
  final double intensityScore;
  final String? patternIdentified;
  final List<String>? recommendations;
  final String? detailedAnalysis;
  final Timestamp createdAt;
  final String language; // 감정분석이 수행된 언어 코드 (en, ko)

  EmotionAnalysisModel({
    required this.id,
    required this.journalId,
    required this.primaryEmotion,
    required this.emotionKeywords,
    required this.intensityScore,
    this.patternIdentified,
    this.recommendations,
    this.detailedAnalysis,
    required this.createdAt,
    required this.language,
  });

  /// Firestore에서 데이터를 가져와 EmotionAnalysisModel 객체로 변환
  factory EmotionAnalysisModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return EmotionAnalysisModel(
      id: doc.id,
      journalId: data['journalId'] ?? '',
      primaryEmotion: data['primaryEmotion'] ?? '',
      emotionKeywords: List<String>.from(data['emotionKeywords'] ?? []),
      intensityScore: (data['intensityScore'] ?? 0).toDouble(),
      patternIdentified: data['patternIdentified'],
      recommendations:
          data['recommendations'] != null
              ? List<String>.from(data['recommendations'])
              : null,
      detailedAnalysis: data['detailedAnalysis'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      language: data['language'] ?? 'en',
    );
  }

  /// EmotionAnalysisModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'journalId': journalId,
      'primaryEmotion': primaryEmotion,
      'emotionKeywords': emotionKeywords,
      'intensityScore': intensityScore,
      'patternIdentified': patternIdentified,
      'recommendations': recommendations,
      'detailedAnalysis': detailedAnalysis,
      'createdAt': createdAt,
      'language': language,
    };
  }

  /// 새로운 감정 분석 생성 시 사용
  factory EmotionAnalysisModel.create({
    required String journalId,
    required String primaryEmotion,
    required List<String> emotionKeywords,
    required double intensityScore,
    String? patternIdentified,
    List<String>? recommendations,
    String? detailedAnalysis,
    required String language,
  }) {
    return EmotionAnalysisModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      journalId: journalId,
      primaryEmotion: primaryEmotion,
      emotionKeywords: emotionKeywords,
      intensityScore: intensityScore,
      patternIdentified: patternIdentified,
      recommendations: recommendations,
      detailedAnalysis: detailedAnalysis,
      createdAt: Timestamp.now(),
      language: language,
    );
  }
}
