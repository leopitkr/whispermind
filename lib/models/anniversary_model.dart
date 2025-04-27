import 'package:cloud_firestore/cloud_firestore.dart';

/// 기념일 모델 클래스
class AnniversaryModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final Timestamp date;
  final String repeatType; // 'yearly', 'monthly', 'weekly', 'once'
  final int? reminderDays;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  AnniversaryModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.date,
    required this.repeatType,
    this.reminderDays,
    required this.createdAt,
    this.updatedAt,
  });

  /// Firestore에서 데이터를 가져와 AnniversaryModel 객체로 변환
  factory AnniversaryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return AnniversaryModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      date: data['date'] ?? Timestamp.now(),
      repeatType: data['repeatType'] ?? 'yearly',
      reminderDays: data['reminderDays'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  /// AnniversaryModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'date': date,
      'repeatType': repeatType,
      'reminderDays': reminderDays,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  /// 새로운 기념일 생성 시 사용
  factory AnniversaryModel.create({
    required String userId,
    required String title,
    String? description,
    required Timestamp date,
    required String repeatType,
    int? reminderDays,
  }) {
    return AnniversaryModel(
      id: '', // Firestore에 저장 시 자동 생성될 ID
      userId: userId,
      title: title,
      description: description,
      date: date,
      repeatType: repeatType,
      reminderDays: reminderDays,
      createdAt: Timestamp.now(),
    );
  }

  /// 기념일 정보 업데이트를 위한 복사 메서드
  AnniversaryModel copyWith({
    String? title,
    String? description,
    Timestamp? date,
    String? repeatType,
    int? reminderDays,
  }) {
    return AnniversaryModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      repeatType: repeatType ?? this.repeatType,
      reminderDays: reminderDays ?? this.reminderDays,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }
}
