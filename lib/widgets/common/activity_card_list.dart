import 'package:flutter/material.dart';
import 'activity_card.dart';

class ActivityCardList extends StatelessWidget {
  final List<ActivityCard> activities;

  const ActivityCardList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165, // 카드 높이에 맞게 조정
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: activities,
      ),
    );
  }
}
