import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  // 기본 로케일
  Locale _locale = const Locale('ko', 'KR');
  final String _localeKey = 'app_locale';

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  // 저장된 로케일 불러오기
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);

    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
      } else if (parts.length == 1) {
        _locale = Locale(parts[0]);
      }
      notifyListeners();
    }
  }

  // 로케일 변경
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    // 변경된 로케일 저장
    final prefs = await SharedPreferences.getInstance();
    String localeString;
    if (locale.countryCode != null) {
      localeString = '${locale.languageCode}_${locale.countryCode}';
    } else {
      localeString = locale.languageCode;
    }
    await prefs.setString(_localeKey, localeString);
  }

  // 영어 설정
  Future<void> setEnglish() async {
    await setLocale(const Locale('en', 'US'));
  }

  // 한국어 설정
  Future<void> setKorean() async {
    await setLocale(const Locale('ko', 'KR'));
  }

  // 지원되는 로케일 목록
  List<Locale> get supportedLocales => [
    const Locale('en', 'US'),
    const Locale('ko', 'KR'),
  ];
}
