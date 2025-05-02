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

  // 원본 영어 텍스트를 저장할 필드들
  final String? primaryEmotionEn;
  final List<String>? emotionKeywordsEn;
  final String? patternIdentifiedEn;
  final List<String>? recommendationsEn;
  final String? detailedAnalysisEn;

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
    this.primaryEmotionEn,
    this.emotionKeywordsEn,
    this.patternIdentifiedEn,
    this.recommendationsEn,
    this.detailedAnalysisEn,
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
      // 원본 영어 필드 로드
      primaryEmotionEn: data['primaryEmotionEn'],
      emotionKeywordsEn:
          data['emotionKeywordsEn'] != null
              ? List<String>.from(data['emotionKeywordsEn'])
              : null,
      patternIdentifiedEn: data['patternIdentifiedEn'],
      recommendationsEn:
          data['recommendationsEn'] != null
              ? List<String>.from(data['recommendationsEn'])
              : null,
      detailedAnalysisEn: data['detailedAnalysisEn'],
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
      // 원본 영어 필드 저장
      'primaryEmotionEn': primaryEmotionEn,
      'emotionKeywordsEn': emotionKeywordsEn,
      'patternIdentifiedEn': patternIdentifiedEn,
      'recommendationsEn': recommendationsEn,
      'detailedAnalysisEn': detailedAnalysisEn,
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
    String? primaryEmotionEn,
    List<String>? emotionKeywordsEn,
    String? patternIdentifiedEn,
    List<String>? recommendationsEn,
    String? detailedAnalysisEn,
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
      // 원본 영어 필드
      primaryEmotionEn: primaryEmotionEn,
      emotionKeywordsEn: emotionKeywordsEn,
      patternIdentifiedEn: patternIdentifiedEn,
      recommendationsEn: recommendationsEn,
      detailedAnalysisEn: detailedAnalysisEn,
    );
  }
}
