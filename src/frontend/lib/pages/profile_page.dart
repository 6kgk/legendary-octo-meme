import 'package:flutter/material.dart';
import '../theme.dart';
import 'favorites_page.dart';
import 'wrong_answers_page.dart';
import 'study_stats_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.areaBg,
              child: Icon(Icons.person_outline, size: 40, color: AppColors.mainText),
            ),
            const SizedBox(height: 16),
            const Text(
              '粤职通用户',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.mainText),
            ),
            const SizedBox(height: 4),
            const Text(
              'ID: 1753156606',
              style: TextStyle(fontSize: 13, color: AppColors.subText),
            ),
            const SizedBox(height: 48),
            
            _buildMenuItem(context, '学习统计', Icons.bar_chart_outlined, const StudyStatsPage()),
            _buildMenuItem(context, '错题本', Icons.assignment_outlined, const WrongAnswersPage()),
            _buildMenuItem(context, '收藏夹', Icons.bookmark_border_outlined, const FavoritesPage()),
            _buildMenuItem(context, '帮助与反馈', Icons.help_outline, null),
            _buildMenuItem(context, '关于粤职通', Icons.info_outline, null),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Widget? targetPage) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: Icon(icon, color: AppColors.mainText),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, color: AppColors.mainText),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.weakText),
        onTap: () {
          if (targetPage != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
          }
        },
      ),
    );
  }
}
