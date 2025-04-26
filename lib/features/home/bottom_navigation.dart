import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Placeholder(), // 일기 화면
    const Placeholder(), // 타임캡슐 화면
    const Placeholder(), // 통계 화면
    const Placeholder(), // 더보기 화면
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
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
        },
        backgroundColor: AppColors.lavender,
        child: const Icon(CupertinoIcons.add, color: AppColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
