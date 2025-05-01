import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/bottom_navigation.dart';
import '../features/home/home_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/time_capsule/time_capsule_screen.dart';
import '../pages/auth/login_screen.dart';
import '../pages/auth/register_screen.dart';
import '../pages/auth/profile_screen.dart';
import '../pages/diary/diary_list_page.dart';
import '../pages/diary/diary_write_page.dart';
import '../pages/diary/diary_detail_page.dart';
import '../models/diary.dart';
import '../models/location.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as app_auth;

/// 앱의 라우팅을 관리하는 클래스
class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final authProvider = Provider.of<app_auth.AuthProvider>(
          context,
          listen: false,
        );
        final isLoggedIn = authProvider.isAuthenticated;
        final isAuthRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        // 로그인되어 있는데 인증 페이지로 가려고 하면 메인 페이지로
        if (isLoggedIn && isAuthRoute) {
          return '/';
        }

        // 로그인되어 있지 않은데 보호된 페이지로 가려고 하면 로그인 페이지로
        if (!isLoggedIn && !isAuthRoute) {
          return '/login';
        }

        return null;
      },
      routes: [
        // 로그인 화면
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        // 회원가입 화면
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        // 프로필 화면
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        // 메인 라우트 (바텀 네비게이션)
        ShellRoute(
          builder: (context, state, child) => BottomNavigation(child: child),
          routes: [
            // 홈 화면
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
            // 일기 화면
            GoRoute(
              path: '/diary',
              builder: (context, state) => const DiaryListPage(),
            ),
            // 타임캡슐 화면
            GoRoute(
              path: '/time-capsule',
              builder: (context, state) => const TimeCapsuleScreen(),
            ),
            // 통계 화면
            GoRoute(
              path: '/statistics',
              builder:
                  (context, state) => Scaffold(
                    appBar: AppBar(title: const Text('통계')),
                    body: const Center(child: Text('통계 화면 준비 중')),
                  ),
            ),
            // 더보기 화면
            GoRoute(
              path: '/more',
              builder:
                  (context, state) => Scaffold(
                    appBar: AppBar(title: const Text('더보기')),
                    body: const Center(child: Text('더보기 화면 준비 중')),
                  ),
            ),
          ],
        ),
        // 일기 작성 화면
        GoRoute(
          path: '/diary/write',
          builder: (context, state) => const DiaryWritePage(),
        ),
        // 일기 상세 화면
        GoRoute(
          path: '/diary/:id',
          builder: (context, state) {
            final diaryId = state.pathParameters['id']!;
            // TODO: diaryId를 사용하여 일기 데이터를 가져오는 로직 구현
            final mockDiary = Diary(
              id: diaryId,
              title: '오늘의 일기',
              content:
                  '오늘은 정말 좋은 하루였습니다. 아침에 일찍 일어나서 공원에서 산책을 했고, 점심에는 맛있는 음식을 먹었습니다. 오후에는 친구들과 만나서 즐거운 시간을 보냈습니다.',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              emotion: Emotion(
                id: 'happy',
                name: '행복',
                emoji: '😊',
                color: const Color(0xFFFFD700),
              ),
              emotionIntensity: 80,
              tags: ['행복', '여행'],
              location: Location(
                latitude: 37.5665,
                longitude: 126.9780,
                address: '서울특별시 중구 세종대로 110',
              ),
              media: [],
            );
            return DiaryDetailPage(diary: mockDiary);
          },
        ),
      ],
      errorBuilder:
          (context, state) => Scaffold(
            appBar: AppBar(title: const Text('오류')),
            body: Center(child: Text('페이지를 찾을 수 없습니다: ${state.error}')),
          ),
    );
  }
}
