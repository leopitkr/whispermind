import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String emotion;
  final int emotionIntensity;
  final List<String> tags;
  final List<String> mediaUrls;
  final GeoPoint? location;
  final String? locationAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiaryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.emotion,
    required this.emotionIntensity,
    required this.tags,
    required this.mediaUrls,
    this.location,
    this.locationAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  // Firestore에서 데이터를 가져올 때 사용하는 팩토리 생성자
  factory DiaryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DiaryModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      emotion: data['emotion'] ?? '',
      emotionIntensity: data['emotionIntensity'] ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      mediaUrls: List<String>.from(data['mediaUrls'] ?? []),
      location: data['location'],
      locationAddress: data['locationAddress'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Firestore에 데이터를 저장할 때 사용하는 Map 변환 메서드
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'emotion': emotion,
      'emotionIntensity': emotionIntensity,
      'tags': tags,
      'mediaUrls': mediaUrls,
      'location': location,
      'locationAddress': locationAddress,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // 일기 수정을 위한 복사 메서드
  DiaryModel copyWith({
    String? title,
    String? content,
    String? emotion,
    int? emotionIntensity,
    List<String>? tags,
    List<String>? mediaUrls,
    GeoPoint? location,
    String? locationAddress,
  }) {
    return DiaryModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      content: content ?? this.content,
      emotion: emotion ?? this.emotion,
      emotionIntensity: emotionIntensity ?? this.emotionIntensity,
      tags: tags ?? this.tags,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      location: location ?? this.location,
      locationAddress: locationAddress ?? this.locationAddress,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
