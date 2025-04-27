import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/time_capsule_model.dart';
import '../models/capsule_attachment_model.dart';

class TimeCapsuleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 컬렉션 레퍼런스
  CollectionReference get _capsules => _firestore.collection('time_capsules');
  CollectionReference get _attachments =>
      _firestore.collection('capsule_attachments');

  // 사용자별 타임캡슐 목록 가져오기
  Future<List<TimeCapsuleModel>> getTimeCapsulesByUser(String userId) async {
    try {
      final querySnapshot =
          await _capsules
              .where('userId', isEqualTo: userId)
              .orderBy('scheduledDate', descending: false)
              .get();

      return querySnapshot.docs
          .map((doc) => TimeCapsuleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('타임캡슐 가져오기 오류: $e');
      return [];
    }
  }

  // 활성화된(미개봉) 타임캡슐 목록 가져오기
  Future<List<TimeCapsuleModel>> getActiveTimeCapsules(String userId) async {
    try {
      final querySnapshot =
          await _capsules
              .where('userId', isEqualTo: userId)
              .where('isOpened', isEqualTo: false)
              .orderBy('scheduledDate', descending: false)
              .get();

      return querySnapshot.docs
          .map((doc) => TimeCapsuleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('활성화된 타임캡슐 가져오기 오류: $e');
      return [];
    }
  }

  // 개봉된 타임캡슐 목록 가져오기
  Future<List<TimeCapsuleModel>> getOpenedTimeCapsules(String userId) async {
    try {
      final querySnapshot =
          await _capsules
              .where('userId', isEqualTo: userId)
              .where('isOpened', isEqualTo: true)
              .orderBy('scheduledDate', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => TimeCapsuleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('개봉된 타임캡슐 가져오기 오류: $e');
      return [];
    }
  }

  // 타임캡슐 생성
  Future<String?> createTimeCapsule(TimeCapsuleModel capsule) async {
    try {
      final docRef = await _capsules.add(capsule.toMap());
      return docRef.id;
    } catch (e) {
      print('타임캡슐 생성 오류: $e');
      return null;
    }
  }

  // 타임캡슐 업데이트
  Future<bool> updateTimeCapsule(TimeCapsuleModel capsule) async {
    try {
      await _capsules.doc(capsule.id).update(capsule.toMap());
      return true;
    } catch (e) {
      print('타임캡슐 업데이트 오류: $e');
      return false;
    }
  }

  // 타임캡슐 열기
  Future<bool> openTimeCapsule(String capsuleId) async {
    try {
      // 타임캡슐 가져오기
      final doc = await _capsules.doc(capsuleId).get();
      final capsule = TimeCapsuleModel.fromFirestore(doc);

      // 열람 상태로 변경
      final updatedCapsule = capsule.markAsOpened();

      // 업데이트
      await _capsules.doc(capsuleId).update(updatedCapsule.toMap());
      return true;
    } catch (e) {
      print('타임캡슐 열기 오류: $e');
      return false;
    }
  }

  // 타임캡슐 삭제
  Future<bool> deleteTimeCapsule(String capsuleId) async {
    try {
      // 첨부파일 먼저 삭제
      await _deleteAttachments(capsuleId);

      // 타임캡슐 삭제
      await _capsules.doc(capsuleId).delete();
      return true;
    } catch (e) {
      print('타임캡슐 삭제 오류: $e');
      return false;
    }
  }

  // 타임캡슐 첨부파일 가져오기
  Future<List<CapsuleAttachmentModel>> getCapsuleAttachments(
    String capsuleId,
  ) async {
    try {
      final querySnapshot =
          await _attachments
              .where('capsuleId', isEqualTo: capsuleId)
              .orderBy('createdAt', descending: false)
              .get();

      return querySnapshot.docs
          .map((doc) => CapsuleAttachmentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('타임캡슐 첨부파일 가져오기 오류: $e');
      return [];
    }
  }

  // 타임캡슐 첨부파일 추가
  Future<String?> addCapsuleAttachment(
    CapsuleAttachmentModel attachment,
  ) async {
    try {
      final docRef = await _attachments.add(attachment.toMap());
      return docRef.id;
    } catch (e) {
      print('타임캡슐 첨부파일 추가 오류: $e');
      return null;
    }
  }

  // 타임캡슐 첨부파일 삭제
  Future<bool> deleteAttachment(String attachmentId) async {
    try {
      await _attachments.doc(attachmentId).delete();
      return true;
    } catch (e) {
      print('타임캡슐 첨부파일 삭제 오류: $e');
      return false;
    }
  }

  // 타임캡슐과 관련된 모든 첨부파일 삭제 (내부용)
  Future<void> _deleteAttachments(String capsuleId) async {
    try {
      final querySnapshot =
          await _attachments.where('capsuleId', isEqualTo: capsuleId).get();

      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('타임캡슐 첨부파일 일괄 삭제 오류: $e');
    }
  }
}
