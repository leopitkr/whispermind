import 'package:cloud_firestore/cloud_firestore.dart';

/// 추억 항목 모델 클래스
class MemoryItemModel {
  final String id;
  final String albumId;
  final String type; // 'photo', 'video', 'audio', 'text'
  final String url;
  final String? thumbnailUrl;
  final String? title;
  final String? description;
  final Timestamp? recordedDate;
  final List<String>? tags;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  MemoryItemModel({
    required this.id,
    required this.albumId,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.title,
    this.description,
    this.recordedDate,
    this.tags,
    required this.createdAt,
    this.updatedAt,
  });

  /// Firestore에서 데이터를 가져와 MemoryItemModel 객체로 변환
  factory MemoryItemModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return MemoryItemModel(
      id: doc.id,
      albumId: data['albumId'] ?? '',
      type: data['type'] ?? 'photo',
      url: data['url'] ?? '',
      thumbnailUrl: data['thumbnailUrl'],
      title: data['title'],
      description: data['description'],
      recordedDate: data['recordedDate'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  /// MemoryItemModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'albumId': albumId,
      'type': type,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'description': description,
      'recordedDate': recordedDate,
      'tags': tags,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  /// 새로운 추억 항목 생성 시 사용
  factory MemoryItemModel.create({
    required String albumId,
    required String type,
    required String url,
    String? thumbnailUrl,
    String? title,
    String? description,
    Timestamp? recordedDate,
    List<String>? tags,
  }) {
    return MemoryItemModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      albumId: albumId,
      type: type,
      url: url,
      thumbnailUrl: thumbnailUrl,
      title: title,
      description: description,
      recordedDate: recordedDate ?? Timestamp.now(),
      tags: tags,
      createdAt: Timestamp.now(),
    );
  }

  /// 항목 정보 업데이트를 위한 복사 메서드
  MemoryItemModel copyWith({
    String? type,
    String? url,
    String? thumbnailUrl,
    String? title,
    String? description,
    Timestamp? recordedDate,
    List<String>? tags,
  }) {
    return MemoryItemModel(
      id: id,
      albumId: albumId,
      type: type ?? this.type,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      recordedDate: recordedDate ?? this.recordedDate,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }
}
