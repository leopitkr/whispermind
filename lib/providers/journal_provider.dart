import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/journal_entry.dart';

class JournalProvider extends ChangeNotifier {
  final List<JournalEntry> _journals = [
    JournalEntry(
      id: '1',
      emotion: '기쁨',
      emotionIcon: CupertinoIcons.heart_fill,
      content: '오랜만에 만난 친구들과 즐거운 시간을 보냈다. 우리의 우정이 변함없이 이어져 행복하다.',
      date: DateTime.now(),
    ),
    JournalEntry(
      id: '2',
      emotion: '평온',
      emotionIcon: CupertinoIcons.sun_max_fill,
      content: '아침 일찍 일어나 명상을 했다. 창문 밖으로 보이는 새벽 풍경이 마음을 차분하게 해주었다.',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    JournalEntry(
      id: '3',
      emotion: '그리움',
      emotionIcon: CupertinoIcons.moon_fill,
      content: '오랫동안 보지 못한 가족들이 생각났다. 다음 주에는 꼭 시간을 내서 찾아뵈어야겠다.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<JournalEntry> getFilteredJournals({
    String filter = '전체',
    DateTime? selectedDate,
  }) {
    return _journals.where((journal) {
        // 날짜 필터링
        if (selectedDate != null) {
          final journalDate = DateTime(
            journal.date.year,
            journal.date.month,
            journal.date.day,
          );
          final selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
          );
          if (journalDate != selectedDateTime) {
            return false;
          }
        }

        // 감정 필터링
        if (filter != '전체' && journal.emotion != filter) {
          return false;
        }

        return true;
      }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<JournalEntry> searchJournals(String query) {
    if (query.isEmpty) {
      return [];
    }

    return _journals
        .where(
          (journal) =>
              journal.content.toLowerCase().contains(query.toLowerCase()) ||
              journal.emotion.toLowerCase().contains(query.toLowerCase()),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void addJournal(JournalEntry journal) {
    _journals.add(journal);
    notifyListeners();
  }

  void updateJournal(JournalEntry journal) {
    final index = _journals.indexWhere((j) => j.id == journal.id);
    if (index != -1) {
      _journals[index] = journal;
      notifyListeners();
    }
  }

  void deleteJournal(String id) {
    _journals.removeWhere((journal) => journal.id == id);
    notifyListeners();
  }
}
