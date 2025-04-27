import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/text_styles.dart';
import '../../providers/time_capsule_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/time_capsule_model.dart';
import '../../features/time_capsule/create_time_capsule_screen.dart';
import '../../features/time_capsule/time_capsule_detail_screen.dart';

class TimeCapsuleScreen extends StatefulWidget {
  const TimeCapsuleScreen({super.key});

  @override
  State<TimeCapsuleScreen> createState() => _TimeCapsuleScreenState();
}

class _TimeCapsuleScreenState extends State<TimeCapsuleScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 화면이 처음 로드될 때 타임캡슐 데이터 로드
    _loadTimeCapsules();
  }

  Future<void> _loadTimeCapsules() async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final timeCapsuleProvider = Provider.of<TimeCapsuleProvider>(
      context,
      listen: false,
    );

    if (authProvider.user != null) {
      await timeCapsuleProvider.loadTimeCapsules(authProvider.user!.uid);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('타임캡슐', style: AppTextStyles.headingMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTimeCapsules,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 새 타임캡슐 만들기 화면으로 이동
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateTimeCapsuleScreen(),
            ),
          );
        },
        backgroundColor: AppColors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildTimeCapsuleList(),
    );
  }

  Widget _buildTimeCapsuleList() {
    final timeCapsuleProvider = Provider.of<TimeCapsuleProvider>(context);

    return RefreshIndicator(
      onRefresh: _loadTimeCapsules,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (timeCapsuleProvider.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildErrorWidget(timeCapsuleProvider.error!),
            ),

          // 활성화된 타임캡슐
          _buildCategorySection(
            '활성화된 타임캡슐',
            timeCapsuleProvider.activeTimeCapsules.isEmpty
                ? [_buildEmptyState('아직 활성화된 타임캡슐이 없습니다.')]
                : timeCapsuleProvider.activeTimeCapsules
                    .map(
                      (capsule) => _buildTimeCapsuleItem(
                        timeCapsule: capsule,
                        isActive: true,
                      ),
                    )
                    .toList(),
          ),

          const SizedBox(height: 20),

          // 개봉된 타임캡슐
          _buildCategorySection(
            '개봉된 타임캡슐',
            timeCapsuleProvider.openedTimeCapsules.isEmpty
                ? [_buildEmptyState('아직 개봉된 타임캡슐이 없습니다.')]
                : timeCapsuleProvider.openedTimeCapsules
                    .map(
                      (capsule) => _buildTimeCapsuleItem(
                        timeCapsule: capsule,
                        isActive: false,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              Provider.of<TimeCapsuleProvider>(
                context,
                listen: false,
              ).clearError();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 150,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.gift, size: 48, color: AppColors.midGray),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: AppColors.midGray)),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(title, style: AppTextStyles.headingSmall),
        ),
        ...items,
      ],
    );
  }

  Widget _buildTimeCapsuleItem({
    required TimeCapsuleModel timeCapsule,
    required bool isActive,
  }) {
    final provider = Provider.of<TimeCapsuleProvider>(context, listen: false);
    final openDate = provider.formatDate(timeCapsule.scheduledDate);
    final daysLeft = provider.calculateDaysLeft(timeCapsule.scheduledDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lightGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 대신 Container 사용 (실제로는 이미지 추가)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: AppColors.lavender.withOpacity(0.2),
                child: Icon(
                  CupertinoIcons.gift,
                  color: AppColors.deepPurple,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeCapsule.title,
                    style: AppTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 14,
                        color: AppColors.midGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '개봉일: $openDate',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.midGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lavender.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '개봉까지 $daysLeft일 남음',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepPurple,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.hope.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '개봉됨',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.hope,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isActive ? Icons.lock : Icons.visibility,
                color: isActive ? AppColors.deepPurple : AppColors.midGray,
              ),
              onPressed: () {
                // 타임캡슐 상세 보기 또는 열기
                if (isActive) {
                  _showOpenCapsuleDialog(timeCapsule);
                } else {
                  // 상세 보기로 이동
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              TimeCapsuleDetailScreen(timeCapsule: timeCapsule),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 타임캡슐 열기 확인 다이얼로그
  Future<void> _showOpenCapsuleDialog(TimeCapsuleModel timeCapsule) async {
    final now = DateTime.now();
    final openDate = timeCapsule.scheduledDate.toDate();

    // 예정된 날짜 이전이면 열 수 없음
    if (now.isBefore(openDate)) {
      _showCannotOpenDialog(timeCapsule);
      return;
    }

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('타임캡슐 열기'),
            content: const Text('이 타임캡슐을 지금 열어보시겠습니까? 한 번 열면 다시 닫을 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  final timeCapsuleProvider = Provider.of<TimeCapsuleProvider>(
                    context,
                    listen: false,
                  );

                  if (authProvider.user != null) {
                    final success = await timeCapsuleProvider.openTimeCapsule(
                      timeCapsule.id,
                      authProvider.user!.uid,
                    );

                    if (success && mounted) {
                      // 성공적으로 열었을 때 상세 화면으로 이동
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder:
                              (context) => TimeCapsuleDetailScreen(
                                timeCapsule: timeCapsule,
                              ),
                        ),
                      );
                    }
                  }
                },
                child: const Text('열기'),
              ),
            ],
          ),
    );
  }

  // 열기 전 타임캡슐 열람 시도 시 다이얼로그
  Future<void> _showCannotOpenDialog(TimeCapsuleModel timeCapsule) async {
    final provider = Provider.of<TimeCapsuleProvider>(context, listen: false);
    final openDate = provider.formatDate(timeCapsule.scheduledDate);
    final daysLeft = provider.calculateDaysLeft(timeCapsule.scheduledDate);

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('아직 열 수 없어요'),
            content: Text('이 타임캡슐은 $openDate에 열 수 있습니다. 아직 $daysLeft일 남았어요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }
}
