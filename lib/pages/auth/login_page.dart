import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      if (context.mounted) {
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('구글 로그인 중 오류가 발생했습니다: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // 앱 로고
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.deepPurple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.book,
                    size: 60,
                    color: AppColors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24),

                // 앱 이름
                Text(
                  'WhisperMind',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),

                // 앱 설명
                Text(
                  '당신의 마음을 담는 가장 따뜻한 공간',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.midGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // 이메일 입력 필드
                TextField(
                  decoration: InputDecoration(
                    labelText: '이메일',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 비밀번호 입력 필드
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 비밀번호 찾기 링크
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: 비밀번호 찾기 기능 구현
                    },
                    child: Text(
                      '비밀번호를 잊으셨나요?',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 로그인 기능 구현
                      context.go('/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepPurple,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('로그인', style: AppTextStyles.button),
                  ),
                ),
                const SizedBox(height: 16),

                // 구분선
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.lightGray)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '또는',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.midGray,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.lightGray)),
                  ],
                ),
                const SizedBox(height: 16),

                // 구글 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _handleGoogleSignIn(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: AppColors.deepPurple),
                    ),
                    icon: Icon(
                      Icons.g_mobiledata,
                      size: 24,
                      color: AppColors.deepPurple,
                    ),
                    label: Text(
                      '구글로 계속하기',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 회원가입 링크
                TextButton(
                  onPressed: () => context.push('/auth/signup'),
                  child: Text(
                    '계정이 없으신가요? 회원가입',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
