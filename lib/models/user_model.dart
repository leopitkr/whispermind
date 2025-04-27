import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final Timestamp createdAt;
  final Map<String, dynamic>? preferences;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL = '',
    required this.createdAt,
    this.preferences,
  });

  // Firestore에서 데이터를 가져와 UserModel 객체로 변환
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      preferences: data['preferences'],
    );
  }

  // UserModel 객체를 Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt,
      'preferences': preferences ?? {},
    };
  }

  // 사용자 정보 업데이트를 위한 복사 메서드
  UserModel copyWith({
    String? displayName,
    String? photoURL,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt,
      preferences: preferences ?? this.preferences,
    );
  }
}
