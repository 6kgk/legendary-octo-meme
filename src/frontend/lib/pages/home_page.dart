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
    Future.microtask(() {
      Provider.of<StudyProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final study = Provider.of<StudyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('粤职通')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('你好，', style: TextStyle(fontSize: 15, color: AppColors.subText)),
            const SizedBox(height: 8),
            const Text('准备好今天的挑战了吗？',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.mainText)),
            const SizedBox(height: 48),
            _buildNavTile(context, '每日一练', '基于 3+证书 最新考纲', Icons.auto_awesome_outlined,
                const DailyPracticePage()),
            _buildNavTile(context, '错题回顾', '温故而知新，可以为师矣', Icons.history_edu_outlined,
                const WrongAnswersPage()),
            _buildNavTile(context, 'AI 助教', '基于推理逻辑的考点解析', Icons.psychology_outlined,
                const AITutorPage()),
            const SizedBox(height: 48),
            const Text('备考数据',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.mainText)),
            const SizedBox(height: 16),
            if (study.isLoaded)
              Row(
                children: [
                  _buildStatCard('语文', '${study.getSubjectCount("语文")}题'),
                  const SizedBox(width: 12),
                  _buildStatCard('数学', '${study.getSubjectCount("数学")}题'),
                  const SizedBox(width: 12),
                  _buildStatCard('英语', '${study.getSubjectCount("英语")}题'),
                ],
              ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.areaBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.notifications_active_outlined, size: 20, color: AppColors.mainText),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('2026年高职高考报名入口已开启',
                        style: TextStyle(fontSize: 14, color: AppColors.mainText)),
                  ),
                  Icon(Icons.chevron_right, size: 20, color: AppColors.weakText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.areaBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.mainText)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile(BuildContext context, String title, String subtitle, IconData icon,
      [Widget? targetPage]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: Icon(icon, size: 28, color: AppColors.mainText),
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mainText)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.weakText),
        onTap: () {
          if (targetPage != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
          }
        },
      ),
    );
  }
}
