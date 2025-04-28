import 'package:flutter/material.dart';
import '../../models/diary.dart';

class DiaryDetailPage extends StatelessWidget {
  final Diary diary;

  const DiaryDetailPage({Key? key, required this.diary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일기 상세')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              diary.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '작성일: ${diary.createdAt.toString()}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (diary.emotion != null) ...[
              Row(
                children: [
                  Text(
                    diary.emotion!.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    diary.emotion!.name,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Text(
              diary.content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            if (diary.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children:
                    diary.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Colors.grey[200],
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
