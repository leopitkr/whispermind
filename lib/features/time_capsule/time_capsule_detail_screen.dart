import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/time_capsule_model.dart';
import '../../providers/time_capsule_provider.dart';

class TimeCapsuleDetailScreen extends StatefulWidget {
  final TimeCapsuleModel timeCapsule;

  const TimeCapsuleDetailScreen({required this.timeCapsule, super.key});

  @override
  State<TimeCapsuleDetailScreen> createState() =>
      _TimeCapsuleDetailScreenState();
}

class _TimeCapsuleDetailScreenState extends State<TimeCapsuleDetailScreen> {
  bool _isLoading = false;
  List<dynamic> _attachments = [];

  @override
  void initState() {
    super.initState();
    _loadAttachments();
  }

  Future<void> _loadAttachments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final timeCapsuleProvider = Provider.of<TimeCapsuleProvider>(
        context,
        listen: false,
      );
      final attachments = await timeCapsuleProvider.timeCapsuleService
          .getCapsuleAttachments(widget.timeCapsule.id);
      setState(() {
        _attachments = attachments;
      });
    } catch (e) {
      print('첨부파일 로드 중 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeCapsuleProvider = Provider.of<TimeCapsuleProvider>(
      context,
      listen: false,
    );
    final dateFormat = DateFormat('yyyy년 MM월 dd일', 'ko_KR');
    final openDate = dateFormat.format(
      widget.timeCapsule.scheduledDate.toDate(),
    );
    final createdDate = dateFormat.format(
      widget.timeCapsule.createdAt.toDate(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('타임캡슐', style: AppTextStyles.headingMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 타임캡슐 헤더
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lavender.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.lavender.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.timeCapsule.title,
                            style: AppTextStyles.headingMedium,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            icon: CupertinoIcons.calendar,
                            label: '생성일',
                            value: createdDate,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: CupertinoIcons.time,
                            label: '개봉일',
                            value: openDate,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: CupertinoIcons.person,
                            label: '수신인',
                            value:
                                widget.timeCapsule.recipientType == 'self'
                                    ? '나에게'
                                    : '미래의 나에게',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 메시지 섹션
                    Text('메시지', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.lightGray),
                      ),
                      child: Text(
                        widget.timeCapsule.message,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),

                    // 첨부파일 섹션 (추후 확장)
                    if (_attachments.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('첨부파일', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 8),
                      // 첨부파일 목록 위젯
                      ..._buildAttachments(),
                    ],

                    // 하단 버튼
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '돌아가기',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.midGray),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.midGray,
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  List<Widget> _buildAttachments() {
    // 확장성을 위해 함수로 분리
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: const Center(child: Text('첨부파일 기능은 추후 업데이트 예정입니다')),
      ),
    ];
  }
}
