import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final Timestamp createdAt;
  final String? actionUrl;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.createdAt,
    this.actionUrl,
  });

  // Firestore에서 데이터를 가져와 NotificationModel 객체로 변환
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      isRead: data['isRead'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      actionUrl: data['actionUrl'],
    );
  }

  // NotificationModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt,
      'actionUrl': actionUrl,
    };
  }

  // 새로운 알림 생성 시 사용
  factory NotificationModel.create({
    required String userId,
    required String type,
    required String title,
    required String message,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      userId: userId,
      type: type,
      title: title,
      message: message,
      isRead: false,
      createdAt: Timestamp.now(),
      actionUrl: actionUrl,
    );
  }

  // 알림 읽음 처리 시 사용
  NotificationModel markAsRead() {
    return NotificationModel(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      isRead: true,
      createdAt: createdAt,
      actionUrl: actionUrl,
    );
  }
}
