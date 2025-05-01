import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _rememberMeKey = 'remember_me';
  static const String _userEmailKey = 'user_email';
  static const String _userPasswordKey = 'user_password';

  // 현재 로그인된 사용자 정보
  User? get currentUser => _auth.currentUser;

  // 로그인 상태 변경 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

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
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // 이메일 중복 확인
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: '이미 사용 중인 이메일입니다.',
        );
      }

      // 회원가입 진행
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore에 사용자 정보 저장
      await _saveUserToFirestore(
        userCredential.user!,
        displayName ?? email.split('@')[0], // 디스플레이 네임이 없으면 이메일 아이디 사용
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw '비밀번호가 너무 약합니다 (최소 6자 이상)';
        case 'email-already-in-use':
          throw '이미 사용 중인 이메일입니다';
        case 'invalid-email':
          throw '올바르지 않은 이메일 형식입니다';
        default:
          throw '회원가입 중 오류가 발생했습니다: ${e.message}';
      }
    }
  }

  // 이메일/비밀번호로 로그인
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw '등록되지 않은 이메일입니다';
        case 'wrong-password':
          throw '비밀번호가 올바르지 않습니다';
        case 'invalid-email':
          throw '올바르지 않은 이메일 형식입니다';
        case 'user-disabled':
          throw '비활성화된 계정입니다';
        case 'too-many-requests':
          throw '너무 많은 로그인 시도가 있었습니다. 잠시 후 다시 시도해주세요';
        default:
          throw '로그인 중 오류가 발생했습니다: ${e.message}';
      }
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw '로그아웃 중 오류가 발생했습니다: ${e.message}';
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
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: displayName,
        createdAt: Timestamp.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
    } catch (e) {
      print('Error saving user to Firestore: $e');
      // Firestore 저장 실패는 치명적이지 않으므로 예외를 던지지 않음
    }
  }

  // 사용자 정보 업데이트
  Future<void> updateUserInfo(String displayName) async {
    try {
      if (currentUser == null) return;

      await _firestore.collection('users').doc(currentUser!.uid).update({
        'displayName': displayName,
      });
    } catch (e) {
      print('Error updating user info: $e');
      rethrow;
    }
  }

  // 로그인 상태 유지 설정
  Future<void> setPersistence(bool rememberMe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, rememberMe);

      // 로그인 상태 유지가 false인 경우 저장된 정보 삭제
      if (!rememberMe) {
        await prefs.remove(_userEmailKey);
        await prefs.remove(_userPasswordKey);
      }
    } catch (e) {
      print('Error setting persistence: $e');
      rethrow;
    }
  }

  // 자동 로그인 상태 확인
  Future<bool> checkAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_rememberMeKey) ?? false;

      if (!rememberMe) return false;

      final user = _auth.currentUser;
      if (user != null) {
        // 토큰 유효성 검증
        await user.getIdToken(true);
        return true;
      }
      return false;
    } catch (e) {
      print('Error checking auto login: $e');
      return false;
    }
  }

  // 로그인 정보 저장
  Future<void> saveLoginInfo(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_rememberMeKey) ?? false;

      if (rememberMe) {
        await prefs.setString(_userEmailKey, email);
        await prefs.setString(_userPasswordKey, password);
      }
    } catch (e) {
      print('Error saving login info: $e');
    }
  }

  // 저장된 로그인 정보 가져오기
  Future<Map<String, String?>> getSavedLoginInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_rememberMeKey) ?? false;

      if (!rememberMe) {
        return {'email': null, 'password': null};
      }

      return {
        'email': prefs.getString(_userEmailKey),
        'password': prefs.getString(_userPasswordKey),
      };
    } catch (e) {
      print('Error getting saved login info: $e');
      return {'email': null, 'password': null};
    }
  }

  // 저장된 로그인 정보 삭제
  Future<void> clearSavedLoginInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userPasswordKey);
      await prefs.remove(_rememberMeKey);
    } catch (e) {
      print('Error clearing saved login info: $e');
    }
  }
}
