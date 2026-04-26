import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/storage_service.dart';
import 'favorites_page.dart';
import 'wrong_answers_page.dart';
import 'study_stats_page.dart';
import 'feedback_page.dart';
import 'about_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final StorageService _storage = StorageService();
  int _totalAnswered = 0;
  int _totalCorrect = 0;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _storage.getTotalAnswered();
    final streak = await _storage.getStudyStreak();
    if (mounted) {
      setState(() {
        _totalAnswered = stats['total'] ?? 0;
        _totalCorrect = stats['correct'] ?? 0;
        _streak = streak;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = _totalAnswered > 0
      ? '${(_totalCorrect / _totalAnswered * 100).round()}%'
      : '-';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              // 头像卡
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.person_rounded, size: 36, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    const Text('粤职通用户', style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('备战 3+证书高职高考', style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.7))),
                    const SizedBox(height: 20),
                    // 3个数据徽章
                    Row(
                      children: [
                        _buildBadge('累计答题', '$_totalAnswered 题'),
                        _buildBadgeDivider(),
                        _buildBadge('正确率', accuracy),
                        _buildBadgeDivider(),
                        _buildBadge('连续学习', '$_streak 天'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 菜单
              _buildMenuItem(context, Icons.bar_chart_rounded, '学习统计', AppColors.primary,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudyStatsPage()))
                    .then((_) => _loadStats())),
              const SizedBox(height: 12),
              _buildMenuItem(context, Icons.bookmark_rounded, '收藏夹', AppColors.warning,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()))),
              const SizedBox(height: 12),
              _buildMenuItem(context, Icons.replay_rounded, '错题本', AppColors.accent,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WrongAnswersPage()))),
              const SizedBox(height: 12),
              _buildMenuItem(context, Icons.help_outline_rounded, '帮助与反馈', AppColors.secondary,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackPage()))),
              const SizedBox(height: 12),
              _buildMenuItem(context, Icons.info_outline_rounded, '关于粤职通', AppColors.subText,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(
            fontSize: 11, color: Colors.white.withOpacity(0.75))),
        ],
      ),
    );
  }

  Widget _buildBadgeDivider() =>
    Container(width: 1, height: 28, color: Colors.white24);

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mainText))),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.weakText),
          ],
        ),
      ),
    );
  }
}
