import 'package:flutter/material.dart';
import 'location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String emotion;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Emotion? emotionObj;
  final int? emotionIntensity;
  final Location? location;
  final List<MediaItem> media;

  Diary({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.emotion,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.emotionObj,
    this.emotionIntensity,
    this.location,
    this.media = const [],
  });

  factory Diary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Diary(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      emotion: data['emotion'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      emotionObj:
          data['emotionObj'] != null
              ? Emotion.fromMap(data['emotionObj'])
              : null,
      emotionIntensity: data['emotionIntensity'] as int?,
      location:
          data['location'] != null ? Location.fromMap(data['location']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'emotion': emotion,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (emotionObj != null) 'emotionObj': emotionObj!.toMap(),
      if (emotionIntensity != null) 'emotionIntensity': emotionIntensity,
      if (location != null) 'location': location!.toMap(),
    };
  }
}

class Emotion {
  final String id;
  final String name;
  final String emoji;
  final Color color;

  Emotion({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });

  factory Emotion.fromMap(Map<String, dynamic> map) {
    return Emotion(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      emoji: map['emoji'] ?? '',
      color: Color(int.parse(map['color'] ?? '0xFF000000')),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'color': color.value.toRadixString(16).padLeft(8, '0'),
    };
  }
}

class MediaItem {
  final String id;
  final String type;
  final String url;
  final String? thumbnail;
  final DateTime createdAt;

  MediaItem({
    required this.id,
    required this.type,
    required this.url,
    this.thumbnail,
    required this.createdAt,
  });
}
