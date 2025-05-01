import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/time_capsule_provider.dart';

class CreateTimeCapsuleScreen extends StatefulWidget {
  const CreateTimeCapsuleScreen({super.key});

  @override
  State<CreateTimeCapsuleScreen> createState() =>
      _CreateTimeCapsuleScreenState();
}

class _CreateTimeCapsuleScreenState extends State<CreateTimeCapsuleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(
    const Duration(days: 7),
  ); // 기본값: 1주일 후
  String _recipientType = 'self'; // 'self' 또는 'future'
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // 날짜 선택 다이얼로그
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)), // 최소한 하루 후
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)), // 최대 10년 후
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.deepPurple,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 타임캡슐 생성
  Future<void> _createTimeCapsule() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final timeCapsuleProvider = Provider.of<TimeCapsuleProvider>(
      context,
      listen: false,
    );

    try {
      if (authProvider.user != null) {
        final success = await timeCapsuleProvider.createTimeCapsule(
          userId: authProvider.user!.uid,
          title: _titleController.text.trim(),
          message: _messageController.text.trim(),
          scheduledDate: _selectedDate,
          recipientType: _recipientType,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('타임캡슐이 성공적으로 생성되었습니다')));
          // 이전 화면으로 돌아가기
          Navigator.of(context).pop();
        } else if (mounted) {
          // 오류 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                timeCapsuleProvider.error ?? '타임캡슐 생성 중 오류가 발생했습니다',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인이 필요합니다'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 날짜 포맷
    final dateFormat = DateFormat('yyyy년 MM월 dd일', 'ko_KR');

    return Scaffold(
      appBar: AppBar(
        title: Text('새 타임캡슐 만들기', style: AppTextStyles.headingMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('타임캡슐 제목', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: '제목을 입력하세요',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '제목을 입력해주세요';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      Text('메시지', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: '미래의 당신에게 어떤 메시지를 남기고 싶나요?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 8,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '메시지를 입력해주세요';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      Text('개봉 예정일', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(dateFormat.format(_selectedDate)),
                              const Icon(
                                CupertinoIcons.calendar,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text('누구에게 보낼까요?', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 8),
                      _buildRecipientSelector(),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _createTimeCapsule,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '타임캡슐 만들기',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildRecipientSelector() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text('나에게'),
            value: 'self',
            groupValue: _recipientType,
            activeColor: AppColors.deepPurple,
            onChanged: (value) {
              setState(() {
                _recipientType = value!;
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text('미래의 나에게'),
            value: 'future',
            groupValue: _recipientType,
            activeColor: AppColors.deepPurple,
            onChanged: (value) {
              setState(() {
                _recipientType = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}
