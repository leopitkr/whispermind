import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AIService {
  final String apiKey;
  final BuildContext? context;

  AIService({required this.apiKey, this.context});

  Future<Map<String, dynamic>?> analyzeEmotion(String diaryText) async {
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    try {
      debugPrint(
        '감정분석 요청 시작: ${diaryText.substring(0, diaryText.length > 20 ? 20 : diaryText.length)}...',
      );

      if (apiKey == 'YOUR_OPENAI_API_KEY' || apiKey.isEmpty) {
        debugPrint('❌ OpenAI API 키가 설정되지 않았습니다. api_keys.dart 파일을 확인하세요.');
        return null;
      }

      // 현재 언어 설정 확인
      final isKorean = context != null && context!.locale.languageCode == 'ko';

      // 현재 언어 설정에 따라 프롬프트 언어 결정
      final promptLanguage = isKorean ? 'Korean' : 'English';
      final responseLanguage = isKorean ? 'Korean' : 'English';

      // 프롬프트 구성
      final prompt = '''
아래 일기 내용을 감정분석해서, 다음 JSON 형식으로 반환해주세요.
응답은 반드시 $responseLanguage로 작성해주세요(Please respond in $responseLanguage):

{
  "primaryEmotion": "anger", // One main emotion (joy, sadness, anger, anxiety, hope)
  "intensityScore": 0.7, // Emotion intensity between 0.0 and 1.0
  "emotionKeywords": ["keyword1", "keyword2", "keyword3"], // Exactly 3 emotional keywords
  "patternIdentified": "A one-line insight about the emotional pattern",
  "recommendations": ["recommendation1", "recommendation2"], // 1-2 activity or quote recommendations
  "detailedAnalysis": "Provide a 4-5 line detailed analysis of emotions and patterns observed in the diary."
}

Please follow this JSON format exactly. Respond with ONLY the JSON, no other text.

[Diary content in $promptLanguage]: "$diaryText"
''';

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are an emotion analysis expert. Always respond in $responseLanguage with the exact JSON format requested.",
            },
            {"role": "user", "content": prompt},
          ],
          "max_tokens": 500,
          "temperature": 0.7,
        }),
      );

      debugPrint('📡 GPT API 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        debugPrint('✅ 감정분석 원본 응답: $content');

        try {
          // JSON 문자열에서 불필요한 앞뒤 텍스트 제거 시도
          String jsonStr = content.trim();

          // ```json 와 ``` 형식으로 감싸진 경우 처리
          final jsonStartIndex = jsonStr.indexOf('{');
          final jsonEndIndex = jsonStr.lastIndexOf('}') + 1;

          if (jsonStartIndex >= 0 && jsonEndIndex > jsonStartIndex) {
            jsonStr = jsonStr.substring(jsonStartIndex, jsonEndIndex);
          }

          debugPrint('정제된 JSON 문자열: $jsonStr');

          // JSON 파싱
          final Map<String, dynamic> parsedResult = jsonDecode(jsonStr);

          // 필드 존재 확인 및 기본값 설정
          final result = {
            'primaryEmotion':
                parsedResult['primaryEmotion'] ?? (isKorean ? '중립' : 'neutral'),
            'emotionKeywords': List<String>.from(
              parsedResult['emotionKeywords'] ??
                  (isKorean
                      ? ['평온', '일상', '보통']
                      : ['neutral', 'calm', 'balanced']),
            ),
            'intensityScore':
                (parsedResult['intensityScore'] ?? 0.5).toDouble(),
            'patternIdentified':
                parsedResult['patternIdentified'] ??
                (isKorean
                    ? '감정 패턴을 식별할 수 없습니다.'
                    : 'No specific pattern identified.'),
            'recommendations': List<String>.from(
              parsedResult['recommendations'] ??
                  (isKorean ? ['심호흡하기'] : ['Take a deep breath']),
            ),
            'detailedAnalysis':
                parsedResult['detailedAnalysis'] ??
                (isKorean
                    ? '상세 분석을 제공할 수 없습니다.'
                    : 'No detailed analysis available.'),
          };

          debugPrint('✅ 감정분석 최종 결과: $result');
          return result;
        } catch (e) {
          debugPrint('❌ JSON 파싱 오류: $e');
          debugPrint('원본 응답: $content');

          // 파싱 실패 시 기본값 반환
          if (isKorean) {
            return {
              'primaryEmotion': '기쁨',
              'emotionKeywords': ['긍정', '행복', '만족'],
              'intensityScore': 0.5,
              'patternIdentified': '감정분석에 어려움이 있었지만, 일상적인 감정으로 보입니다.',
              'recommendations': ['명상하기', '산책하기'],
              'detailedAnalysis':
                  '감정분석 처리 과정에서 오류가 발생했습니다. 더 자세한 분석을 위해 다시 시도해주세요.',
            };
          } else {
            return {
              'primaryEmotion': 'joy',
              'emotionKeywords': ['positive', 'happy', 'satisfied'],
              'intensityScore': 0.5,
              'patternIdentified':
                  'Analysis was difficult, but it seems to be an everyday emotion.',
              'recommendations': ['Meditate', 'Take a walk'],
              'detailedAnalysis':
                  'An error occurred during emotion analysis processing. Please try again for a more detailed analysis.',
            };
          }
        }
      } else {
        debugPrint('❌ GPT API 오류 (${response.statusCode}): ${response.body}');
        // 기본값 반환
        if (isKorean) {
          return {
            'primaryEmotion': '중립',
            'emotionKeywords': ['평온', '일상', '보통'],
            'intensityScore': 0.3,
            'patternIdentified': 'API 오류로 정확한 분석이 어렵습니다. 일상적인 감정으로 간주합니다.',
            'recommendations': ['심호흡하기', '휴식취하기'],
            'detailedAnalysis': 'API 연결 문제로 감정분석이 완료되지 않았습니다. 나중에 다시 시도해주세요.',
          };
        } else {
          return {
            'primaryEmotion': 'neutral',
            'emotionKeywords': ['calm', 'everyday', 'normal'],
            'intensityScore': 0.3,
            'patternIdentified':
                'API error makes accurate analysis difficult. Considered as everyday emotion.',
            'recommendations': ['Take deep breaths', 'Rest'],
            'detailedAnalysis':
                'Emotion analysis was not completed due to API connection issues. Please try again later.',
          };
        }
      }
    } catch (e) {
      debugPrint('❌ 감정분석 과정에서 예외 발생: $e');
      // 기본값 반환
      if (context != null && context!.locale.languageCode == 'ko') {
        return {
          'primaryEmotion': '중립',
          'emotionKeywords': ['평온', '일상', '보통'],
          'intensityScore': 0.3,
          'patternIdentified': '분석 과정에서 오류가 발생했습니다. 기본값을 보여드립니다.',
          'recommendations': ['심호흡하기', '음악 듣기'],
          'detailedAnalysis':
              '감정분석 서비스 연결에 문제가 발생했습니다. 인터넷 연결을 확인하고 다시 시도해주세요.',
        };
      } else {
        return {
          'primaryEmotion': 'neutral',
          'emotionKeywords': ['calm', 'everyday', 'normal'],
          'intensityScore': 0.3,
          'patternIdentified':
              'An error occurred during analysis. Default values are shown.',
          'recommendations': ['Take deep breaths', 'Listen to music'],
          'detailedAnalysis':
              'There was a problem connecting to the emotion analysis service. Check your internet connection and try again.',
        };
      }
    }
  }

  // 영어 감정을 한글로 변환
  String _translateEmotionToKorean(String englishEmotion) {
    final Map<String, String> emotionMap = {
      'joy': '기쁨',
      'happiness': '행복',
      'sadness': '슬픔',
      'anger': '분노',
      'anxiety': '불안',
      'fear': '두려움',
      'hope': '희망',
      'love': '사랑',
      'gratitude': '감사',
      'neutral': '중립',
      'calm': '평온',
      'excitement': '흥분',
      'frustration': '좌절',
      'disappointment': '실망',
      'guilt': '죄책감',
      'shame': '수치심',
      'pride': '자부심',
      'surprise': '놀람',
      'disgust': '혐오',
      'confusion': '혼란',
      'loneliness': '외로움',
      'satisfaction': '만족',
      'relief': '안도',
    };

    return emotionMap[englishEmotion] ?? '기타';
  }

  // 영어 감정 키워드를 한글로 변환
  String _translateKeywordToKorean(String englishKeyword) {
    final Map<String, String> keywordMap = {
      'joy': '기쁨',
      'happiness': '행복',
      'sadness': '슬픔',
      'anger': '분노',
      'anxiety': '불안',
      'fear': '두려움',
      'hope': '희망',
      'love': '사랑',
      'gratitude': '감사',
      'neutral': '중립',
      'calm': '평온',
      'peaceful': '평화로움',
      'excitement': '흥분',
      'frustration': '좌절',
      'disappointment': '실망',
      'guilt': '죄책감',
      'shame': '수치심',
      'pride': '자부심',
      'surprise': '놀람',
      'disgust': '혐오',
      'confusion': '혼란',
      'loneliness': '외로움',
      'satisfaction': '만족감',
      'relief': '안도감',
      'worry': '걱정',
      'annoyance': '짜증',
      'contentment': '만족',
      'pleasure': '즐거움',
      'positive': '긍정적',
      'negative': '부정적',
      'sensitive': '민감함',
      'stressed': '스트레스',
      'happy': '행복한',
      'sad': '슬픈',
      'angry': '화난',
      'anxious': '불안한',
      'hopeful': '희망찬',
      'nervous': '긴장된',
      'balanced': '균형잡힌',
      'overwhelmed': '압도된',
      'relaxed': '편안한',
      'cheerful': '쾌활한',
      'gloomy': '우울한',
      'irritated': '짜증난',
      'tranquil': '고요한',
      'excited': '신나는',
      'melancholic': '우울한',
      'serene': '평온한',
      'nostalgic': '향수에 젖은',
      'confident': '자신감 있는',
      'confused': '혼란스러운',
      'exhausted': '지친',
    };

    return keywordMap[englishKeyword] ?? englishKeyword;
  }
}
