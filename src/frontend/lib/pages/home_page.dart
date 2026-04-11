import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ai_tutor_page.dart';
import 'daily_practice_page.dart';
import 'wrong_answers_page.dart';
import '../services/study_provider.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<StudyProvider>(context, listen: false).loadData());
  }

  @override
  Widget build(BuildContext context) {
    final study = Provider.of<StudyProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('粤职通', style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.mainText)),
                        SizedBox(height: 4),
                        Text('广东3+证书备考助手', style: TextStyle(
                          fontSize: 14, color: AppColors.subText)),
                      ],
                    ),
                  ),
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Banner card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('今日目标', style: TextStyle(
                      fontSize: 13, color: Colors.white70)),
                    const SizedBox(height: 8),
                    const Text('完成 3 科各 5 道练习题', style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const DailyPracticePage())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('开始每日一练', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Stats row
              if (study.isLoaded) ...[
                const Text('备考进度', style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard('语文', study.getSubjectCount('语文'), AppColors.primary),
                    const SizedBox(width: 12),
                    _buildStatCard('数学', study.getSubjectCount('数学'), AppColors.secondary),
                    const SizedBox(width: 12),
                    _buildStatCard('英语', study.getSubjectCount('英语'), AppColors.warning),
                  ],
                ),
                const SizedBox(height: 28),
              ],

              // Quick actions
              const Text('快捷入口', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
              const SizedBox(height: 16),
              _buildActionCard(
                icon: Icons.auto_awesome_rounded,
                color: AppColors.primary,
                title: '每日一练',
                subtitle: '随机 3 题快速练习',
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DailyPracticePage())),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                icon: Icons.psychology_rounded,
                color: AppColors.secondary,
                title: 'AI 助教',
                subtitle: 'DeepSeek 驱动的智能解题',
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AITutorPage())),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                icon: Icons.replay_rounded,
                color: AppColors.accent,
                title: '错题回顾',
                subtitle: '温故而知新',
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const WrongAnswersPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Column(
          children: [
            Text('$count', style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
            const SizedBox(height: 8),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.6,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon, required Color color,
    required String title, required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mainText)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.weakText),
          ],
        ),
      ),
    );
  }
}
