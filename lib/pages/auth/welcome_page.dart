import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 앱 로고
              Image.asset(
                'assets/images/app_logo.png',
                width: 120,
                height: 120,
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
              const Spacer(),

              // 시작하기 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/auth/signup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepPurple,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('시작하기', style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 16),

              // 로그인 링크
              TextButton(
                onPressed: () => context.push('/auth/login'),
                child: Text(
                  '이미 계정이 있으신가요? 로그인',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
