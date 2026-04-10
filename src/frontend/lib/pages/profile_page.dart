import 'package:flutter/material.dart';
import '../theme.dart';

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
            
            _buildMenuItem('学习统计', Icons.bar_chart_outlined),
            _buildMenuItem('收藏夹', Icons.bookmark_border_outlined),
            _buildMenuItem('帮助与反馈', Icons.help_outline),
            _buildMenuItem('关于粤职通', Icons.info_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
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
        onTap: () {},
      ),
    );
  }
}
