import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:typed_data';

/// Firebase 서비스 클래스
class FirebaseService {
  /// Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Firebase Auth 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Firebase Storage 인스턴스
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 싱글톤 패턴 구현
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  /// Firestore 연결 테스트
  Future<bool> testFirestoreConnection() async {
    try {
      // test_collection에 간단한 문서 생성
      await _firestore.collection('test_collection').doc('test_doc').set({
        'test_field': 'test_value',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 생성한 문서 읽기
      DocumentSnapshot doc =
          await _firestore.collection('test_collection').doc('test_doc').get();
      print('Firestore 연결 테스트 성공: ${doc.data()}');

      return true;
    } catch (e) {
      print('Firestore 연결 테스트 실패: $e');
      return false;
    }
  }

  /// 테스트 문서 삭제
  Future<void> deleteTestDocument() async {
    try {
      await _firestore.collection('test_collection').doc('test_doc').delete();
      print('테스트 문서 삭제 완료');
    } catch (e) {
      print('테스트 문서 삭제 실패: $e');
    }
  }

  /// Firebase Auth 익명 로그인 테스트
  Future<bool> testAnonymousAuth() async {
    try {
      // 현재 사용자가 로그인되어 있다면 로그아웃
      if (_auth.currentUser != null) {
        await _auth.signOut();
        print('기존 사용자 로그아웃 완료');
      }

      // 익명 로그인
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      print('익명 로그인 성공: uid=${user?.uid}');

      // 사용자 정보 출력
      print(
        '익명 사용자 정보: isAnonymous=${user?.isAnonymous}, email=${user?.email}',
      );

      return true;
    } catch (e) {
      print('익명 로그인 실패: $e');
      return false;
    }
  }

  /// 로그아웃 테스트
  Future<void> testSignOut() async {
    try {
      await _auth.signOut();
      print('로그아웃 완료, 현재 사용자: ${_auth.currentUser}');
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }

  /// Firebase Storage 테스트
  Future<bool> testStorage() async {
    try {
      // 테스트 파일 데이터 생성
      final String testData =
          'Hello Firebase Storage! 안녕하세요! ${DateTime.now()}';
      final Uint8List testBytes = Uint8List.fromList(utf8.encode(testData));

      // 파일 업로드
      final Reference ref = _storage.ref().child('test').child('test_file.txt');
      final UploadTask uploadTask = ref.putData(
        testBytes,
        SettableMetadata(contentType: 'text/plain'),
      );

      // 업로드 완료 대기
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      print('Storage 파일 업로드 성공: $downloadUrl');

      // 파일 다운로드 URL로 접근 가능 확인
      print('다운로드 URL: $downloadUrl');

      // 테스트 파일 삭제
      await ref.delete();
      print('Storage 테스트 파일 삭제 완료');

      return true;
    } catch (e) {
      print('Storage 테스트 실패: $e');
      return false;
    }
  }
}
