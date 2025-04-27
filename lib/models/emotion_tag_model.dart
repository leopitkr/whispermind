import 'package:cloud_firestore/cloud_firestore.dart';

/// 감정 태그 모델 클래스
class EmotionTagModel {
  final String id;
  final String name;
  final String description;
  final String colorCode;
  final String category;
  final bool isDefault;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  EmotionTagModel({
    required this.id,
    required this.name,
    required this.description,
    required this.colorCode,
    required this.category,
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  /// Firestore에서 데이터를 가져와 EmotionTagModel 객체로 변환
  factory EmotionTagModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return EmotionTagModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      colorCode: data['colorCode'] ?? '#000000',
      category: data['category'] ?? '',
      isDefault: data['isDefault'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  /// EmotionTagModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'colorCode': colorCode,
      'category': category,
      'isDefault': isDefault,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  /// 새로운 감정 태그 생성 시 사용
  factory EmotionTagModel.create({
    required String name,
    required String description,
    required String colorCode,
    required String category,
    bool isDefault = false,
  }) {
    return EmotionTagModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      name: name,
      description: description,
      colorCode: colorCode,
      category: category,
      isDefault: isDefault,
      createdAt: Timestamp.now(),
    );
  }
}
