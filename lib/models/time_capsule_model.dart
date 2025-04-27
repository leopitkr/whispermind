import 'package:cloud_firestore/cloud_firestore.dart';

class TimeCapsuleModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final Timestamp scheduledDate;
  final bool isOpened;
  final String recipientType;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  TimeCapsuleModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.scheduledDate,
    this.isOpened = false,
    this.recipientType = 'self',
    required this.createdAt,
    this.updatedAt,
  });

  // Firestore에서 데이터를 가져와 TimeCapsuleModel 객체로 변환
  factory TimeCapsuleModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return TimeCapsuleModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      scheduledDate: data['scheduledDate'] ?? Timestamp.now(),
      isOpened: data['isOpened'] ?? false,
      recipientType: data['recipientType'] ?? 'self',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  // TimeCapsuleModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'scheduledDate': scheduledDate,
      'isOpened': isOpened,
      'recipientType': recipientType,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  // 새로운 타임캡슐 생성 시 사용
  factory TimeCapsuleModel.create({
    required String userId,
    required String title,
    required String message,
    required Timestamp scheduledDate,
    String recipientType = 'self',
  }) {
    return TimeCapsuleModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      userId: userId,
      title: title,
      message: message,
      scheduledDate: scheduledDate,
      isOpened: false,
      recipientType: recipientType,
      createdAt: Timestamp.now(),
    );
  }

  // 타임캡슐 열람 시 사용
  TimeCapsuleModel markAsOpened() {
    return TimeCapsuleModel(
      id: id,
      userId: userId,
      title: title,
      message: message,
      scheduledDate: scheduledDate,
      isOpened: true,
      recipientType: recipientType,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }
}
