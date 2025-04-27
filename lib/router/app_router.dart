import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/bottom_navigation.dart';
import '../features/journal/journal_screen.dart';
import '../features/time_capsule/time_capsule_screen.dart';

/// 앱의 라우팅을 관리하는 클래스
class AppRouter {
  /// GoRouter 인스턴스
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      // 메인 라우트 (바텀 네비게이션)
      GoRoute(
        path: '/',
        builder: (context, state) => const BottomNavigation(),
        routes: [
          // 저널 화면
          GoRoute(
            path: 'journal',
            builder: (context, state) => const JournalScreen(),
          ),
          // 타임캡슐 화면
          GoRoute(
            path: 'time-capsule',
            builder: (context, state) => const TimeCapsuleScreen(),
          ),
        ],
      ),
    ],
    // 에러 페이지
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('오류')),
          body: Center(child: Text('페이지를 찾을 수 없습니다: ${state.uri.toString()}')),
        ),
  );
}
