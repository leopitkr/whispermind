import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 현재 로그인한 유저 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 현재 로그인한 유저 가져오기
  User? get currentUser => _auth.currentUser;

  // 유저 모델 가져오기
  Future<UserModel?> getUserModel() async {
    try {
      if (currentUser == null) return null;

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user model: $e');
      return null;
    }
  }

  // 이메일/비밀번호로 회원가입
  Future<UserCredential?> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      // Firebase Auth에 계정 생성
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 사용자 프로필 업데이트
      await result.user?.updateDisplayName(displayName);

      // Firestore에 사용자 정보 저장
      await _saveUserToFirestore(result.user!, displayName);

      return result;
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  // 이메일/비밀번호로 로그인
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // 비밀번호 재설정 이메일 보내기
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
      rethrow;
    }
  }

  // Firestore에 사용자 정보 저장
  Future<void> _saveUserToFirestore(User user, String displayName) async {
    try {
      // 사용자 모델 생성
      UserModel userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: displayName,
        createdAt: Timestamp.now(),
      );

      // Firestore에 저장
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
    } catch (e) {
      print('Error saving user to Firestore: $e');
      rethrow;
    }
  }
}
