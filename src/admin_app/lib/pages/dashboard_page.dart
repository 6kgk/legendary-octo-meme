import 'package:flutter/material.dart';
import '../theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('仪表盘')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatCard('总题目数', '150', Icons.quiz_rounded, AdminColors.primary),
                const SizedBox(width: 16),
                _buildStatCard('院校数量', '30', Icons.school_rounded, AdminColors.success),
                const SizedBox(width: 16),
                _buildStatCard('社区帖子', '128', Icons.forum_rounded, AdminColors.warning),
                const SizedBox(width: 16),
                _buildStatCard('今日活跃', '56', Icons.people_rounded, AdminColors.danger),
              ],
            ),
            const SizedBox(height: 32),
            const Text('最近活动', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AdminColors.cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildActivityItem('新增 15 道数学真题', '数据更新', '2 分钟前', AdminColors.primary),
                  const Divider(height: 1, color: AdminColors.divider),
                  _buildActivityItem('深圳职业技术大学信息更新', '院校管理', '10 分钟前', AdminColors.success),
                  const Divider(height: 1, color: AdminColors.divider),
                  _buildActivityItem('审核通过 3 条社区帖子', '内容审核', '30 分钟前', AdminColors.warning),
                  const Divider(height: 1, color: AdminColors.divider),
                  _buildActivityItem('APK v1.3 构建成功', '系统通知', '1 小时前', AdminColors.subText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AdminColors.cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 16),
            Text(value, style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 13, color: AdminColors.subText)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String category, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AdminColors.mainText)),
                const SizedBox(height: 2),
                Text(category, style: const TextStyle(fontSize: 12, color: AdminColors.subText)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 12, color: AdminColors.weakText)),
        ],
      ),
    );
  }
}
