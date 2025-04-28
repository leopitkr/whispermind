import 'package:flutter/material.dart';
import 'location.dart';

class Diary {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Emotion? emotion;
  final int? emotionIntensity;
  final List<String> tags;
  final Location? location;
  final List<MediaItem> media;

  Diary({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.emotion,
    this.emotionIntensity,
    this.tags = const [],
    this.location,
    this.media = const [],
  });
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
