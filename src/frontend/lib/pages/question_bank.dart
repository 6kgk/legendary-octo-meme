import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/study_provider.dart';
import 'quiz_view.dart';
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
    Future.microtask(() {
      Provider.of<StudyProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final study = Provider.of<StudyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('备考')),
      body: !study.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('3+证书 真题库',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.mainText)),
                  const SizedBox(height: 32),
                  _buildSubjectTile(context, study, '语文', '2024年真题已更新'),
                  _buildSubjectTile(context, study, '数学', '考点精炼与公式汇总'),
                  _buildSubjectTile(context, study, '英语', '语法与阅读专项突破'),
                  const SizedBox(height: 48),
                  const Text('专项练习',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.mainText)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildSmallTag('基础考点'),
                      _buildSmallTag('重难点突破'),
                      _buildSmallTag('模拟考场'),
                      _buildSmallTag('错题本'),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSubjectTile(BuildContext context, StudyProvider study, String subject, String subtitle) {
    final count = study.getSubjectCount(subject);
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        title: Row(
          children: [
            Text(subject,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mainText)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.areaBg, borderRadius: BorderRadius.circular(4)),
              child: Text('$count题', style: const TextStyle(fontSize: 10, color: AppColors.subText)),
            ),
          ],
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
        trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.weakText),
        onTap: () {
          study.resetQuiz();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => QuizView(subject: subject)));
        },
      ),
    );
  }

  Widget _buildSmallTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.mainText)),
    );
  }
}
