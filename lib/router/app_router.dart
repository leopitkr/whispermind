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
import '../models/diary_model.dart';
import '../models/location.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as app_auth;
import '../providers/diary_provider.dart';

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
            final authProvider = Provider.of<app_auth.AuthProvider>(
              context,
              listen: false,
            );
            final diaryProvider = Provider.of<DiaryProvider>(
              context,
              listen: false,
            );

            // 일기 데이터 가져오기
            final diary = diaryProvider.diaries.firstWhere(
              (d) => d.id == diaryId,
              orElse:
                  () => DiaryModel(
                    id: diaryId,
                    userId: authProvider.user!.uid,
                    title: '일기를 불러오는 중...',
                    content: '',
                    emotion: '',
                    emotionIntensity: 0,
                    tags: [],
                    mediaUrls: [],
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
            );

            return DiaryDetailPage(diary: diary);
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
