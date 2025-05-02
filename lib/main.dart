import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/time_capsule_provider.dart';
import 'providers/locale_provider.dart';
import 'router/app_router.dart';
import 'services/firebase_service.dart';
import 'services/emotion_tag_service.dart';
import 'pages/diary/diary_list_page.dart';
import 'services/auth_service.dart';
import 'pages/auth/login_screen.dart';
import 'package:go_router/go_router.dart';
import 'services/diary_service.dart';
import 'providers/diary_provider.dart';
import 'providers/emotion_analytics_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로드
  await dotenv.load(fileName: '.env');

  // 다국어 지원 초기화
  await EasyLocalization.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase 초기화 성공');
  } catch (e) {
    print('Firebase 초기화 오류: $e');
  }

  // 시스템 UI 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ko', 'KR'),
      child: const MyApp(),
    ),
  );
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DiaryService>(create: (_) => DiaryService()),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<JournalProvider>(
          create: (_) => JournalProvider(),
        ),
        ChangeNotifierProvider<EmotionAnalyticsProvider>(
          create: (_) => EmotionAnalyticsProvider(),
        ),
        ChangeNotifierProvider<TimeCapsuleProvider>(
          create: (_) => TimeCapsuleProvider(),
        ),
        ChangeNotifierProvider<DiaryProvider>(
          create: (context) => DiaryProvider(context.read<DiaryService>()),
        ),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.getRouter(context);

          // 언어 프로바이더의 설정을 EasyLocalization에 연결
          final localeProvider = context.watch<LocaleProvider>();

          if (context.locale != localeProvider.locale) {
            // EasyLocalization의 로케일이 Provider와 다른 경우, Provider의 로케일로 설정
            Future.microtask(() {
              context.setLocale(localeProvider.locale);
            });
          }

          return MaterialApp.router(
            title: 'WhisperMind'.tr(),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            // 다국어 지원 설정
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }
}
