import 'package:flutter/material.dart';
import 'presentation/pages/learning_home_page.dart';
import 'presentation/pages/exam_hall_page.dart';
import 'presentation/pages/learning_report_page.dart';
import 'presentation/pages/profile_page.dart';

/**
 * 【职教通】V2.0.0 - 商业化架构升级版 (Task #104)
 * 核心变更：
 * 1. 采用 Repository 模式：解耦 UI 与数据存储。
 * 2. 单例状态管理：全局 AppStateNotifier 驱动，支持异步加载与秒级响应。
 * 3. 页面模块化：代码已按 Data/Domain/Presentation 模式进行物理隔离。
 */

void main() {
  runApp(VocationalBridgeApp());
}

class VocationalBridgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '职教通',
      theme: ThemeData(
        primaryColor: Color(0xFF1D4E89),
        scaffoldBackgroundColor: Color(0xFFF8FAFC),
        fontFamily: 'PingFang SC',
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1D4E89)),
      ),
      home: MainNavigationFrame(),
    );
  }
}

class MainNavigationFrame extends StatefulWidget {
  @override
  _MainNavigationFrameState createState() => _MainNavigationFrameState();
}

class _MainNavigationFrameState extends State<MainNavigationFrame> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    LearningHomePage(),
    ExamHallPage(),
    LearningReportPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex, 
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF1D4E89),
        unselectedItemColor: Colors.grey[400],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'AI辅导'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: '考场'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: '报告'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
