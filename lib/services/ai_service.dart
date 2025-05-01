import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey;

  AIService({required this.apiKey});

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

      // 개선된 프롬프트 - 영어로 응답 요청 (인코딩 문제 방지)
      final prompt = '''
아래 일기 내용을 감정분석해서, 다음 JSON 형식으로 반환해주세요.
응답은 반드시 영어로 작성해주세요(To avoid encoding issues, please respond in English):

{
  "primaryEmotion": "anger", // One main emotion (joy, sadness, anger, anxiety, hope)
  "intensityScore": 0.7, // Emotion intensity between 0.0 and 1.0
  "emotionKeywords": ["keyword1", "keyword2", "keyword3"], // Exactly 3 emotional keywords
  "patternIdentified": "A one-line insight about the emotional pattern",
  "recommendations": ["recommendation1", "recommendation2"] // 1-2 activity or quote recommendations
}

Please follow this JSON format exactly. Respond with ONLY the JSON, no other text.

[Diary content in Korean]: "$diaryText"
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
                  "You are an emotion analysis expert. Always respond in English with the exact JSON format requested.",
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
            'primaryEmotion': parsedResult['primaryEmotion'] ?? 'neutral',
            'emotionKeywords':
                parsedResult['emotionKeywords'] ??
                ['neutral', 'calm', 'balanced'],
            'intensityScore':
                (parsedResult['intensityScore'] ?? 0.5).toDouble(),
            'patternIdentified':
                parsedResult['patternIdentified'] ??
                'No specific pattern identified.',
            'recommendations':
                parsedResult['recommendations'] ??
                ['Take a deep breath and relax.'],
          };

          // 영어 감정을 한글로 변환 (필요시)
          result['primaryEmotion'] = _translateEmotionToKorean(
            result['primaryEmotion'].toString().toLowerCase(),
          );

          debugPrint('✅ 감정분석 최종 결과: $result');
          return result;
        } catch (e) {
          debugPrint('❌ JSON 파싱 오류: $e');
          debugPrint('원본 응답: $content');

          // 파싱 실패 시 기본값 반환
          return {
            'primaryEmotion': '기쁨',
            'emotionKeywords': ['긍정', '행복', '만족'],
            'intensityScore': 0.5,
            'patternIdentified': '감정분석에 어려움이 있었지만, 일상적인 감정으로 보입니다.',
            'recommendations': ['명상하기', '산책하기'],
          };
        }
      } else {
        debugPrint('❌ GPT API 오류 (${response.statusCode}): ${response.body}');
        // 기본값 반환
        return {
          'primaryEmotion': '중립',
          'emotionKeywords': ['평온', '일상', '보통'],
          'intensityScore': 0.3,
          'patternIdentified': 'API 오류로 정확한 분석이 어렵습니다. 일상적인 감정으로 간주합니다.',
          'recommendations': ['심호흡하기', '휴식취하기'],
        };
      }
    } catch (e) {
      debugPrint('❌ 감정분석 과정에서 예외 발생: $e');
      // 기본값 반환
      return {
        'primaryEmotion': '중립',
        'emotionKeywords': ['평온', '일상', '보통'],
        'intensityScore': 0.3,
        'patternIdentified': '분석 과정에서 오류가 발생했습니다. 기본값을 보여드립니다.',
        'recommendations': ['심호흡하기', '음악 듣기'],
      };
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
}
