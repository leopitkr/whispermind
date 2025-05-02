import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// 다국어 지원을 위한 유틸리티 클래스
class LanguageUtils {
  /// 사용자의 현재 언어 설정에 따라 적절한 콘텐츠를 반환하는 유틸리티 메서드
  /// 영어 사용자에게는 영어 콘텐츠를, 한국어 사용자에게는 한국어 콘텐츠를 제공
  static T getLocalizedContent<T>({
    required BuildContext context,
    required T koreanContent,
    required T englishContent,
  }) {
    final locale = context.locale;

    // 한국어 로케일인 경우 한국어 콘텐츠 반환
    if (locale.languageCode == 'ko') {
      return koreanContent;
    }

    // 기타 언어인 경우 영어 콘텐츠 반환 (기본값)
    return englishContent;
  }

  /// 감정분석 결과에서 현재 언어에 맞는 필드 반환
  static String getLocalizedEmotionField({
    required BuildContext context,
    required String koreanField,
    required String englishField,
    String defaultValue = '',
  }) {
    // 빈 값이거나 null인 경우 대체 값 사용
    final korean =
        (koreanField.isNotEmpty)
            ? koreanField
            : (englishField.isNotEmpty ? englishField : defaultValue);
    final english =
        (englishField.isNotEmpty)
            ? englishField
            : (koreanField.isNotEmpty ? koreanField : defaultValue);

    return getLocalizedContent(
      context: context,
      koreanContent: korean,
      englishContent: english,
    );
  }

  /// 감정분석 결과에서 현재 언어에 맞는 리스트 필드 반환
  static List<String> getLocalizedEmotionListField({
    required BuildContext context,
    required List<String>? koreanField,
    required List<String>? englishField,
  }) {
    // null 또는 빈 리스트인 경우 대체 값 사용
    final List<String> korean =
        (koreanField != null && koreanField.isNotEmpty)
            ? koreanField
            : (englishField != null && englishField.isNotEmpty
                ? List<String>.from(englishField)
                : <String>[]);
    final List<String> english =
        (englishField != null && englishField.isNotEmpty)
            ? englishField
            : (koreanField != null && koreanField.isNotEmpty
                ? List<String>.from(koreanField)
                : <String>[]);

    return getLocalizedContent(
      context: context,
      koreanContent: korean,
      englishContent: english,
    );
  }
}
