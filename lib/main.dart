import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/time_capsule_provider.dart';
import 'router/app_router.dart';
import 'services/firebase_service.dart';
import 'services/emotion_tag_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase 초기화 성공');

    // Firestore 연결 테스트
    await FirebaseService().testFirestoreConnection();
    // 테스트 문서 정리
    await FirebaseService().deleteTestDocument();

    // 감정 태그 서비스 테스트
    await testEmotionTagService();

    // 아래 테스트 코드는 Firebase 콘솔 설정이 필요해서 일단 주석 처리
    // // Firebase Auth 익명 로그인 테스트
    // await FirebaseService().testAnonymousAuth();
    // // 로그아웃 테스트
    // await FirebaseService().testSignOut();

    // // Firebase Storage 테스트
    // await FirebaseService().testStorage();
  } catch (e) {
    print('Firebase 초기화 또는 테스트 중 오류 발생: $e');
  }

  // 시스템 UI 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

/// 감정 태그 서비스 테스트
Future<void> testEmotionTagService() async {
  try {
    // 감정 태그 기본 데이터 초기화 및 생성
    await EmotionTagService().initializeDefaultTags();

    // 감정 태그 데이터 스트림 수신 (1초간 리스닝)
    EmotionTagService()
        .getTags()
        .listen((tags) {
          print('감정 태그 목록 (${tags.length}개):');
          for (var tag in tags) {
            print(
              ' - ${tag.name}: ${tag.description} (${tag.category}, ${tag.colorCode})',
            );
          }
        })
        .onDone(() {
          print('감정 태그 스트림 수신 완료');
        });

    // 스트림이 비동기적으로 동작하므로 1초 대기
    await Future.delayed(const Duration(seconds: 1));
  } catch (e) {
    print('감정 태그 서비스 테스트 중 오류 발생: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        ChangeNotifierProvider(create: (_) => TimeCapsuleProvider()),
      ],
      child: MaterialApp.router(
        title: 'WhisperMind',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // 시스템 설정에 따라 테마 적용
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
