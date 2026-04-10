import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/study_provider.dart';
import '../models/app_models.dart';
import '../theme.dart';

class QuizView extends StatefulWidget {
  final String subject;
  const QuizView({super.key, required this.subject});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int? _selectedIndex;
  bool _isAnswered = false;

  @override
  Widget build(BuildContext context) {
    final studyProvider = Provider.of<StudyProvider>(context);
    final questions = studyProvider.getQuestionsBySubject(widget.subject);

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.subject)),
        body: const Center(child: Text('暂无题目')),
      );
    }

    if (studyProvider.currentQuestionIndex >= questions.length) {
      return _buildResultScreen(studyProvider, questions.length);
    }

    final question = questions[studyProvider.currentQuestionIndex];
    final progress = (studyProvider.currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text('${studyProvider.currentQuestionIndex + 1}/${questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 2,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation(AppColors.mainText),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (question.year.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.areaBg, borderRadius: BorderRadius.circular(4)),
                      child: Text(question.year,
                          style: const TextStyle(fontSize: 11, color: AppColors.subText)),
                    ),
                  Text(question.content,
                      style: const TextStyle(fontSize: 17, height: 1.6, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 32),
                  ...List.generate(question.options.length,
                      (index) => _buildOptionTile(index, question.options[index], question.answerIndex)),
                  if (_isAnswered) ...[
                    const SizedBox(height: 24),
                    _buildExplanationCard(question.explanation),
                  ],
                ],
              ),
            ),
          ),
          _buildFooter(studyProvider, questions.length, question.answerIndex),
        ],
      ),
    );
  }

  Widget _buildResultScreen(StudyProvider provider, int total) {
    final correct = provider.correctCount;
    final percentage = (correct / total * 100).round();
    return Scaffold(
      appBar: AppBar(title: Text('${widget.subject} 练习报告')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$percentage%',
                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w700, color: AppColors.mainText)),
              const SizedBox(height: 8),
              Text('答对 $correct / $total 题',
                  style: const TextStyle(fontSize: 16, color: AppColors.subText)),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  provider.resetQuiz();
                  Navigator.pop(context);
                },
                child: const Text('返回题库'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(int index, String text, int correctIndex) {
    Color borderColor = AppColors.divider;
    Color bgColor = AppColors.background;

    if (_isAnswered) {
      if (index == correctIndex) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.05);
      } else if (index == _selectedIndex) {
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.05);
      }
    } else if (_selectedIndex == index) {
      borderColor = AppColors.mainText;
      bgColor = AppColors.areaBg;
    }

    return GestureDetector(
      onTap: _isAnswered ? null : () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedIndex == index ? AppColors.mainText : AppColors.areaBg,
              ),
              child: Center(
                child: Text(String.fromCharCode(65 + index),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: _selectedIndex == index ? AppColors.background : AppColors.mainText)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.4))),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.areaBg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: AppColors.mainText),
              SizedBox(width: 6),
              Text('解析', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(height: 1.5, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFooter(StudyProvider provider, int total, int correctAnswer) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          if (!_isAnswered)
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedIndex == null
                    ? null
                    : () {
                        provider.recordAnswer(_selectedIndex == correctAnswer);
                        setState(() => _isAnswered = true);
                      },
                child: const Text('提交答案'),
              ),
            ),
          if (_isAnswered)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  provider.nextQuestion();
                  setState(() {
                    _selectedIndex = null;
                    _isAnswered = false;
                  });
                },
                child: Text(provider.currentQuestionIndex < total - 1 ? '下一题' : '查看结果'),
              ),
            ),
        ],
      ),
    );
  }
}
