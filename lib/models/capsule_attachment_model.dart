import 'package:cloud_firestore/cloud_firestore.dart';

/// 타임캡슐 첨부 모델 클래스
class CapsuleAttachmentModel {
  final String id;
  final String capsuleId;
  final String type; // 'image', 'audio', 'video', etc.
  final String url;
  final String? description;
  final Timestamp createdAt;

  CapsuleAttachmentModel({
    required this.id,
    required this.capsuleId,
    required this.type,
    required this.url,
    this.description,
    required this.createdAt,
  });

  /// Firestore에서 데이터를 가져와 CapsuleAttachmentModel 객체로 변환
  factory CapsuleAttachmentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CapsuleAttachmentModel(
      id: doc.id,
      capsuleId: data['capsuleId'] ?? '',
      type: data['type'] ?? 'image',
      url: data['url'] ?? '',
      description: data['description'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  /// CapsuleAttachmentModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'capsuleId': capsuleId,
      'type': type,
      'url': url,
      'description': description,
      'createdAt': createdAt,
    };
  }

  /// 새로운 타임캡슐 첨부 생성 시 사용
  factory CapsuleAttachmentModel.create({
    required String capsuleId,
    required String type,
    required String url,
    String? description,
  }) {
    return CapsuleAttachmentModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      capsuleId: capsuleId,
      type: type,
      url: url,
      description: description,
      createdAt: Timestamp.now(),
    );
  }
}
