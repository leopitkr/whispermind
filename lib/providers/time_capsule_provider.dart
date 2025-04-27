import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/time_capsule_model.dart';
import '../models/capsule_attachment_model.dart';
import '../services/time_capsule_service.dart';

class TimeCapsuleProvider extends ChangeNotifier {
  final TimeCapsuleService _timeCapsuleService = TimeCapsuleService();

  // 서비스 객체 노출
  TimeCapsuleService get timeCapsuleService => _timeCapsuleService;

  // 타임캡슐 목록
  List<TimeCapsuleModel> _activeTimeCapsules = [];
  List<TimeCapsuleModel> _openedTimeCapsules = [];

  // 로딩 상태
  bool _isLoading = false;
  String? _error;

  // 게터
  List<TimeCapsuleModel> get activeTimeCapsules => _activeTimeCapsules;
  List<TimeCapsuleModel> get openedTimeCapsules => _openedTimeCapsules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 타임캡슐 데이터 불러오기
  Future<void> loadTimeCapsules(String userId) async {
    _setLoading(true);
    try {
      final activeTimeCapsules = await _timeCapsuleService
          .getActiveTimeCapsules(userId);
      final openedTimeCapsules = await _timeCapsuleService
          .getOpenedTimeCapsules(userId);

      _activeTimeCapsules = activeTimeCapsules;
      _openedTimeCapsules = openedTimeCapsules;
      _error = null;
    } catch (e) {
      _error = '타임캡슐을 불러오는 중 오류가 발생했습니다.';
      print('타임캡슐 불러오기 오류: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 새 타임캡슐 생성
  Future<bool> createTimeCapsule({
    required String userId,
    required String title,
    required String message,
    required DateTime scheduledDate,
    String recipientType = 'self',
  }) async {
    _setLoading(true);
    try {
      final capsule = TimeCapsuleModel(
        id: '',
        userId: userId,
        title: title,
        message: message,
        scheduledDate: Timestamp.fromDate(scheduledDate),
        isOpened: false,
        recipientType: recipientType,
        createdAt: Timestamp.now(),
      );

      final capsuleId = await _timeCapsuleService.createTimeCapsule(capsule);

      if (capsuleId != null) {
        await loadTimeCapsules(userId); // 목록 새로고침
        return true;
      }
      return false;
    } catch (e) {
      _error = '타임캡슐을 생성하는 중 오류가 발생했습니다.';
      print('타임캡슐 생성 오류: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 타임캡슐 열기
  Future<bool> openTimeCapsule(String capsuleId, String userId) async {
    _setLoading(true);
    try {
      final result = await _timeCapsuleService.openTimeCapsule(capsuleId);

      if (result) {
        await loadTimeCapsules(userId); // 목록 새로고침
        return true;
      }
      return false;
    } catch (e) {
      _error = '타임캡슐을 여는 중 오류가 발생했습니다.';
      print('타임캡슐 열기 오류: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 타임캡슐 삭제
  Future<bool> deleteTimeCapsule(String capsuleId, String userId) async {
    _setLoading(true);
    try {
      final result = await _timeCapsuleService.deleteTimeCapsule(capsuleId);

      if (result) {
        await loadTimeCapsules(userId); // 목록 새로고침
        return true;
      }
      return false;
    } catch (e) {
      _error = '타임캡슐을 삭제하는 중 오류가 발생했습니다.';
      print('타임캡슐 삭제 오류: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 타임캡슐 첨부파일 추가
  Future<bool> addAttachment({
    required String capsuleId,
    required String type,
    required String url,
    String? description,
  }) async {
    _setLoading(true);
    try {
      final attachment = CapsuleAttachmentModel.create(
        capsuleId: capsuleId,
        type: type,
        url: url,
        description: description,
      );

      final attachmentId = await _timeCapsuleService.addCapsuleAttachment(
        attachment,
      );

      return attachmentId != null;
    } catch (e) {
      _error = '첨부파일을 추가하는 중 오류가 발생했습니다.';
      print('첨부파일 추가 오류: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 남은 일수 계산
  int calculateDaysLeft(Timestamp scheduledDate) {
    final now = DateTime.now();
    final openDate = scheduledDate.toDate();
    final difference = openDate.difference(now);

    return difference.inDays < 0 ? 0 : difference.inDays;
  }

  // 날짜 포맷팅 (YYYY년 MM월 DD일)
  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formatter = DateFormat('yyyy년 MM월 dd일', 'ko_KR');
    return formatter.format(date);
  }

  // 로딩 상태 설정
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 오류 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
