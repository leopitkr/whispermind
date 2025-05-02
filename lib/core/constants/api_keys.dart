import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  // .env 파일에서 API 키를 가져옵니다.
  // 개발 또는 테스트 환경에서는 기본값을 제공합니다.
  static String get openAI =>
      dotenv.env['OPENAI_API_KEY'] ?? 'YOUR_OPENAI_API_KEY';
}
