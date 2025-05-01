import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;

  AuthProvider(this._authService) {
    _init();
  }

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  // 초기화 함수
  Future<void> _init() async {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  // 인증 상태 변경 리스너
  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;

    if (user != null) {
      _userModel = await _authService.getUserModel();
    } else {
      _userModel = null;
    }

    notifyListeners();
  }

  // 회원가입
  Future<bool> register(
    String email,
    String password,
    String displayName,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 로그인
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.setPersistence(_rememberMe);
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      _userModel = await _authService.getUserModel();

      // 로그인 정보 저장
      if (_rememberMe) {
        await _authService.saveLoginInfo(email, password);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 로그아웃
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signOut();
      // 로그아웃 시 저장된 로그인 정보 삭제
      await _authService.clearSavedLoginInfo();
      _rememberMe = false;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 비밀번호 재설정
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 자동 로그인 시도
  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isAutoLoginPossible = await _authService.checkAutoLogin();
      if (isAutoLoginPossible) {
        _user = _authService.currentUser;
        _userModel = await _authService.getUserModel();
      } else {
        // 저장된 로그인 정보로 자동 로그인 시도
        final loginInfo = await _authService.getSavedLoginInfo();
        final email = loginInfo['email'];
        final password = loginInfo['password'];

        if (email != null && password != null) {
          await login(email, password);
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 로그인 상태 유지 설정
  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    await _authService.setPersistence(value);
    notifyListeners();
  }

  // 오류 메시지 처리
  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return '해당 이메일로 등록된 사용자를 찾을 수 없습니다.';
        case 'wrong-password':
          return '잘못된 비밀번호입니다.';
        case 'email-already-in-use':
          return '이미 사용 중인 이메일입니다.';
        case 'weak-password':
          return '비밀번호가 너무 약합니다.';
        case 'invalid-email':
          return '잘못된 이메일 형식입니다.';
        default:
          return '인증 오류: ${e.message}';
      }
    }
    return '오류가 발생했습니다: $e';
  }

  // 사용자 정보 업데이트
  Future<bool> updateUserInfo(String displayName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.updateUserInfo(displayName);
      _userModel = await _authService.getUserModel();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
