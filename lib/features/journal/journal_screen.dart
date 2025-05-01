import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/journal_provider.dart';
import '../../widgets/common/emotion_card.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  bool _showCalendar = false;
  String _selectedFilter = '전체';
  final _searchController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<String> _filterOptions = [
    '전체',
    '기쁨',
    '평온',
    '슬픔',
    '분노',
    '불안',
    '그리움',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 헤더
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '감정 일기',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.deepPurple,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showCalendar = !_showCalendar;
                            });
                          },
                          icon: Icon(
                            _showCalendar
                                ? CupertinoIcons.list_bullet
                                : CupertinoIcons.calendar,
                            color: AppColors.deepPurple,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: JournalSearchDelegate(),
                            );
                          },
                          icon: Icon(
                            CupertinoIcons.search,
                            color: AppColors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 필터 옵션
            SliverToBoxAdapter(
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filterOptions.length,
                  itemBuilder: (context, index) {
                    final filter = _filterOptions[index];
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = selected ? filter : '전체';
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.lavender,
                        checkmarkColor: AppColors.deepPurple,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? AppColors.deepPurple
                                  : AppColors.midGray,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 캘린더 뷰
            if (_showCalendar)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.now(),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: AppColors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: AppColors.lavender,
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount: 1,
                    ),
                    headerStyle: HeaderStyle(
                      titleTextStyle: AppTextStyles.headingSmall,
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(
                        CupertinoIcons.chevron_left,
                        color: AppColors.deepPurple,
                      ),
                      rightChevronIcon: Icon(
                        CupertinoIcons.chevron_right,
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ),

            // 일기 목록
            Consumer<JournalProvider>(
              builder: (context, journalProvider, _) {
                final journals = journalProvider.getFilteredJournals(
                  filter: _selectedFilter,
                  selectedDate: _selectedDay,
                );

                if (journals.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.doc_text,
                            size: 48,
                            color: AppColors.midGray,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '아직 작성된 일기가 없습니다',
                            style: TextStyle(color: AppColors.midGray),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final journal = journals[index];
                      return EmotionCard(
                        emotionName: journal.emotion,
                        emotionIcon: journal.emotionIcon,
                        date: journal.formattedDate,
                        previewText: journal.content,
                        onTap: () {
                          // 일기 상세 페이지로 이동
                          context.push('/diary/${journal.id}');
                        },
                      );
                    }, childCount: journals.length),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 일기 검색 델리게이트
class JournalSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(CupertinoIcons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final journalProvider = Provider.of<JournalProvider>(context);
    final results = journalProvider.searchJournals(query);

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.search, size: 48, color: AppColors.midGray),
            const SizedBox(height: 16),
            Text('검색어를 입력해주세요', style: TextStyle(color: AppColors.midGray)),
          ],
        ),
      );
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.doc_text, size: 48, color: AppColors.midGray),
            const SizedBox(height: 16),
            Text('검색 결과가 없습니다', style: TextStyle(color: AppColors.midGray)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final journal = results[index];
        return EmotionCard(
          emotionName: journal.emotion,
          emotionIcon: journal.emotionIcon,
          date: journal.formattedDate,
          previewText: journal.content,
          onTap: () {
            close(context, '');
            context.push('/diary/${journal.id}');
          },
        );
      },
    );
  }
}
