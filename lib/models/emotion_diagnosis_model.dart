import 'package:cloud_firestore/cloud_firestore.dart';

/// 감정 진단 모델 클래스
class EmotionDiagnosisModel {
  final String id;
  final String userId;
  final Timestamp diagnosisDate;
  final String emotionalState;
  final List<Map<String, dynamic>> primaryEmotions;
  final double balanceScore;
  final Map<String, dynamic>? insights;
  final Map<String, dynamic>? recommendations;
  final String? prevDiagnosisId;
  final Timestamp createdAt;

  EmotionDiagnosisModel({
    required this.id,
    required this.userId,
    required this.diagnosisDate,
    required this.emotionalState,
    required this.primaryEmotions,
    required this.balanceScore,
    this.insights,
    this.recommendations,
    this.prevDiagnosisId,
    required this.createdAt,
  });

  /// Firestore에서 데이터를 가져와 EmotionDiagnosisModel 객체로 변환
  factory EmotionDiagnosisModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return EmotionDiagnosisModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      diagnosisDate: data['diagnosisDate'] ?? Timestamp.now(),
      emotionalState: data['emotionalState'] ?? '',
      primaryEmotions: List<Map<String, dynamic>>.from(
        data['primaryEmotions']?.map((e) => Map<String, dynamic>.from(e)) ?? [],
      ),
      balanceScore: (data['balanceScore'] ?? 0).toDouble(),
      insights:
          data['insights'] != null
              ? Map<String, dynamic>.from(data['insights'])
              : null,
      recommendations:
          data['recommendations'] != null
              ? Map<String, dynamic>.from(data['recommendations'])
              : null,
      prevDiagnosisId: data['prevDiagnosisId'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  /// EmotionDiagnosisModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'diagnosisDate': diagnosisDate,
      'emotionalState': emotionalState,
      'primaryEmotions': primaryEmotions,
      'balanceScore': balanceScore,
      'insights': insights,
      'recommendations': recommendations,
      'prevDiagnosisId': prevDiagnosisId,
      'createdAt': createdAt,
    };
  }

  /// 새로운 감정 진단 생성 시 사용
  factory EmotionDiagnosisModel.create({
    required String userId,
    required String emotionalState,
    required List<Map<String, dynamic>> primaryEmotions,
    required double balanceScore,
    Map<String, dynamic>? insights,
    Map<String, dynamic>? recommendations,
    String? prevDiagnosisId,
  }) {
    return EmotionDiagnosisModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      userId: userId,
      diagnosisDate: Timestamp.now(),
      emotionalState: emotionalState,
      primaryEmotions: primaryEmotions,
      balanceScore: balanceScore,
      insights: insights,
      recommendations: recommendations,
      prevDiagnosisId: prevDiagnosisId,
      createdAt: Timestamp.now(),
    );
  }
}
