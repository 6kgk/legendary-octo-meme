import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/question_bank.dart';
import 'pages/school_search.dart';
import 'pages/forum_page.dart';
import 'pages/profile_page.dart';
import 'theme.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const QuestionBankPage(),
    const SchoolSearchPage(),
    const ForumPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.background,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.mainText,
          unselectedItemColor: AppColors.weakText,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.edit_note_outlined), activeIcon: Icon(Icons.edit_note), label: '刷题'),
            BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: '查校'),
            BottomNavigationBarItem(icon: Icon(Icons.forum_outlined), activeIcon: Icon(Icons.forum), label: '树洞'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '我的'),
          ],
        ),
      ),
    );
  }
}
