import 'package:flutter/material.dart';
import 'theme.dart';
import 'pages/dashboard_page.dart';
import 'pages/questions_manage_page.dart';
import 'pages/schools_manage_page.dart';
import 'pages/posts_manage_page.dart';

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '粤职通管理后台',
      theme: AdminTheme.theme,
      home: const AdminShell(),
    );
  }
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  final _pages = const [
    DashboardPage(),
    QuestionsManagePage(),
    SchoolsManagePage(),
    PostsManagePage(),
  ];

  final _navItems = const [
    {'icon': Icons.dashboard_rounded, 'label': '仪表盘'},
    {'icon': Icons.quiz_rounded, 'label': '题库管理'},
    {'icon': Icons.school_rounded, 'label': '院校管理'},
    {'icon': Icons.forum_rounded, 'label': '内容审核'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            color: AdminColors.cardBg,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AdminColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.school_rounded, color: Colors.white, size: 24),
                      SizedBox(width: 10),
                      Text('粤职通', style: TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('管理后台', style: TextStyle(
                    fontSize: 12, color: AdminColors.subText)),
                ),
                const SizedBox(height: 32),
                ...List.generate(_navItems.length, (i) => _buildSideItem(i)),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('v1.0.0', style: TextStyle(
                    fontSize: 11, color: AdminColors.weakText)),
                ),
              ],
            ),
          ),
          Container(width: 1, color: AdminColors.divider),
          // Content
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
    );
  }

  Widget _buildSideItem(int index) {
    final isSelected = _currentIndex == index;
    final item = _navItems[index];
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AdminColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(item['icon'] as IconData, size: 20,
              color: isSelected ? AdminColors.primary : AdminColors.subText),
            const SizedBox(width: 12),
            Text(item['label'] as String, style: TextStyle(
              fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AdminColors.primary : AdminColors.subText)),
          ],
        ),
      ),
    );
  }
}
