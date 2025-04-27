import 'package:cloud_firestore/cloud_firestore.dart';

/// 미디어 첨부 모델 클래스
class MediaAttachmentModel {
  final String id;
  final String journalId;
  final String type; // 'image', 'audio', 'video'
  final String url;
  final String? thumbnailUrl;
  final String? description;
  final Timestamp createdAt;

  MediaAttachmentModel({
    required this.id,
    required this.journalId,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.description,
    required this.createdAt,
  });

  /// Firestore에서 데이터를 가져와 MediaAttachmentModel 객체로 변환
  factory MediaAttachmentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return MediaAttachmentModel(
      id: doc.id,
      journalId: data['journalId'] ?? '',
      type: data['type'] ?? 'image',
      url: data['url'] ?? '',
      thumbnailUrl: data['thumbnailUrl'],
      description: data['description'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  /// MediaAttachmentModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'journalId': journalId,
      'type': type,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'createdAt': createdAt,
    };
  }

  /// 새로운 미디어 첨부 생성 시 사용
  factory MediaAttachmentModel.create({
    required String journalId,
    required String type,
    required String url,
    String? thumbnailUrl,
    String? description,
  }) {
    return MediaAttachmentModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      journalId: journalId,
      type: type,
      url: url,
      thumbnailUrl: thumbnailUrl,
      description: description,
      createdAt: Timestamp.now(),
    );
  }
}
