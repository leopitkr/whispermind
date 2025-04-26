import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/emotion_journal_model.dart';

class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 감정 일기 컬렉션 참조
  CollectionReference get _journalsCollection =>
      _firestore.collection('emotion_journals');

  // 현재 사용자의 모든 감정 일기 가져오기
  Stream<List<EmotionJournalModel>> getUserJournals() {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      // 사용자가 로그인하지 않은 경우 빈 리스트 반환
      return Stream.value([]);
    }

    return _journalsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => EmotionJournalModel.fromFirestore(doc))
              .toList();
        });
  }

  // 특정 기간의 감정 일기 가져오기
  Future<List<EmotionJournalModel>> getJournalsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    Timestamp startTimestamp = Timestamp.fromDate(startDate);
    Timestamp endTimestamp = Timestamp.fromDate(endDate);

    QuerySnapshot querySnapshot =
        await _journalsCollection
            .where('userId', isEqualTo: userId)
            .where('createdAt', isGreaterThanOrEqualTo: startTimestamp)
            .where('createdAt', isLessThanOrEqualTo: endTimestamp)
            .orderBy('createdAt', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => EmotionJournalModel.fromFirestore(doc))
        .toList();
  }

  // 특정 감정 일기 상세 정보 가져오기
  Future<EmotionJournalModel?> getJournalById(String journalId) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    DocumentSnapshot doc = await _journalsCollection.doc(journalId).get();

    if (doc.exists) {
      EmotionJournalModel journal = EmotionJournalModel.fromFirestore(doc);
      // 본인의 일기인지 확인
      if (journal.userId == userId) {
        return journal;
      }
    }

    return null;
  }

  // 새 감정 일기 추가
  Future<String> addJournal(EmotionJournalModel journal) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    // 일기 데이터 추가
    DocumentReference docRef = await _journalsCollection.add(journal.toMap());
    return docRef.id;
  }

  // 감정 일기 수정
  Future<void> updateJournal(
    String journalId,
    EmotionJournalModel journal,
  ) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    // 일기 소유자 확인
    DocumentSnapshot doc = await _journalsCollection.doc(journalId).get();
    if (!doc.exists) throw Exception('Journal not found');

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != userId)
      throw Exception('Not authorized to update this journal');

    // 업데이트 시간 추가
    Map<String, dynamic> updateData = journal.toMap();
    updateData['updatedAt'] = Timestamp.now();

    // 일기 업데이트
    await _journalsCollection.doc(journalId).update(updateData);
  }

  // 감정 일기 삭제
  Future<void> deleteJournal(String journalId) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    // 일기 소유자 확인
    DocumentSnapshot doc = await _journalsCollection.doc(journalId).get();
    if (!doc.exists) throw Exception('Journal not found');

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != userId)
      throw Exception('Not authorized to delete this journal');

    // 일기 삭제
    await _journalsCollection.doc(journalId).delete();
  }

  // 감정별 일기 수 통계
  Future<Map<String, int>> getEmotionStats() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return {};

    QuerySnapshot querySnapshot =
        await _journalsCollection.where('userId', isEqualTo: userId).get();

    Map<String, int> emotionCounts = {};

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String emotion = data['emotion'] ?? 'unknown';

      if (emotionCounts.containsKey(emotion)) {
        emotionCounts[emotion] = emotionCounts[emotion]! + 1;
      } else {
        emotionCounts[emotion] = 1;
      }
    }

    return emotionCounts;
  }
}
