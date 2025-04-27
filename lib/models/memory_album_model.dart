import 'package:cloud_firestore/cloud_firestore.dart';

/// 추억 앨범 모델 클래스
class MemoryAlbumModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String? coverImage;
  final String? relatedPerson;
  final List<String>? tags;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  MemoryAlbumModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.coverImage,
    this.relatedPerson,
    this.tags,
    required this.createdAt,
    this.updatedAt,
  });

  /// Firestore에서 데이터를 가져와 MemoryAlbumModel 객체로 변환
  factory MemoryAlbumModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return MemoryAlbumModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      coverImage: data['coverImage'],
      relatedPerson: data['relatedPerson'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  /// MemoryAlbumModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'relatedPerson': relatedPerson,
      'tags': tags,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  /// 새로운 추억 앨범 생성 시 사용
  factory MemoryAlbumModel.create({
    required String userId,
    required String title,
    String? description,
    String? coverImage,
    String? relatedPerson,
    List<String>? tags,
  }) {
    return MemoryAlbumModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      userId: userId,
      title: title,
      description: description,
      coverImage: coverImage,
      relatedPerson: relatedPerson,
      tags: tags,
      createdAt: Timestamp.now(),
    );
  }

  /// 앨범 정보 업데이트를 위한 복사 메서드
  MemoryAlbumModel copyWith({
    String? title,
    String? description,
    String? coverImage,
    String? relatedPerson,
    List<String>? tags,
  }) {
    return MemoryAlbumModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      relatedPerson: relatedPerson ?? this.relatedPerson,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }
}
