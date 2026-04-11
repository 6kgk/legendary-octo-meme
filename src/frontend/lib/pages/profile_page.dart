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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              // Header
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
                    Text('ID: 1753156606', style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.7))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu items
              _buildMenuItem(context, Icons.bar_chart_rounded, '学习统计', AppColors.primary,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudyStatsPage()))),
              const SizedBox(height: 12),
              _buildMenuItem(context, Icons.bookmark_rounded, '收藏夹', AppColors.warning,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()))),
              const SizedBox(height: 12),
              _buildMenuItem(context, Icons.replay_rounded, '错题本', AppColors.accent,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WrongAnswersPage()))),
              const SizedBox(height: 12),
              _buildMenuItem(context, Icons.help_outline_rounded, '帮助与反馈', AppColors.secondary, () {}),
              const SizedBox(height: 12),
              _buildMenuItem(context, Icons.info_outline_rounded, '关于粤职通', AppColors.subText, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
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
            Expanded(
              child: Text(title, style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mainText)),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.weakText),
          ],
        ),
      ),
    );
  }
}
