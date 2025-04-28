import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_screen.dart';
import '../../pages/diary/diary_list_page.dart';

class BottomNavigation extends StatefulWidget {
  final Widget child;

  const BottomNavigation({super.key, required this.child});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // GoRouter를 사용하여 화면 전환
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/diary');
        break;
      case 2:
        context.go('/time-capsule');
        break;
      case 3:
        context.go('/statistics');
        break;
      case 4:
        context.go('/more');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.deepPurple,
        unselectedItemColor: AppColors.midGray,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            activeIcon: Icon(CupertinoIcons.book_fill),
            label: '일기',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.time),
            activeIcon: Icon(CupertinoIcons.time_solid),
            label: '타임캡슐',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            activeIcon: Icon(CupertinoIcons.chart_bar_fill),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.ellipsis),
            activeIcon: Icon(CupertinoIcons.ellipsis_circle_fill),
            label: '더보기',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 감정 일기 작성 화면으로 이동
          context.go('/diary/write');
        },
        backgroundColor: AppColors.lavender,
        child: const Icon(CupertinoIcons.add, color: AppColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
