import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/study_provider.dart';
import 'quiz_view.dart';
import 'wrong_answers_page.dart';
import 'favorites_page.dart';
import 'daily_practice_page.dart';
import '../theme.dart';

class QuestionBankPage extends StatefulWidget {
  const QuestionBankPage({super.key});

  @override
  State<QuestionBankPage> createState() => _QuestionBankPageState();
}

class _QuestionBankPageState extends State<QuestionBankPage> {
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
        child: !study.isLoaded
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('题库', style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.mainText)),
                  const SizedBox(height: 4),
                  const Text('3+证书高职高考真题精选', style: TextStyle(
                    fontSize: 14, color: AppColors.subText)),
                  const SizedBox(height: 28),
                  
                  _buildSubjectCard(context, study, '语文', '字音·成语·病句·阅读',
                    Icons.auto_stories_rounded, AppColors.primary),
                  const SizedBox(height: 16),
                  _buildSubjectCard(context, study, '数学', '函数·三角·数列·概率',
                    Icons.calculate_rounded, AppColors.secondary),
                  const SizedBox(height: 16),
                  _buildSubjectCard(context, study, '英语', '语法·词汇·阅读理解',
                    Icons.translate_rounded, AppColors.warning),
                  
                  const SizedBox(height: 32),
                  const Text('专项练习', style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildActionTag('每日一练', Icons.bolt_rounded, AppColors.warning,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyPracticePage()))),
                      _buildActionTag('错题本', Icons.replay_rounded, AppColors.accent,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WrongAnswersPage()))),
                      _buildActionTag('收藏夹', Icons.bookmark_rounded, AppColors.primary,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()))),
                      _buildActionTag('语文专练', Icons.auto_stories_rounded, AppColors.primary,
                        () { study.resetQuiz(); Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizView(subject: '语文'))); }),
                      _buildActionTag('数学专练', Icons.calculate_rounded, AppColors.secondary,
                        () { study.resetQuiz(); Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizView(subject: '数学'))); }),
                      _buildActionTag('英语专练', Icons.translate_rounded, AppColors.warning,
                        () { study.resetQuiz(); Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizView(subject: '英语'))); }),
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, StudyProvider study,
      String subject, String desc, IconData icon, Color color) {
    final count = study.getSubjectCount(subject);
    return GestureDetector(
      onTap: () {
        study.resetQuiz();
        Navigator.push(context, MaterialPageRoute(builder: (_) => QuizView(subject: subject)));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject, style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$count题', style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: color)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTag(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.mainText)),
          ],
        ),
      ),
    );
  }
}
