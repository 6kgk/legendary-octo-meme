import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/study_provider.dart';
import '../services/storage_service.dart';
import '../theme.dart';
import 'package:intl/intl.dart';
import 'wrong_answers_page.dart';

class QuizView extends StatefulWidget {
  final String subject;
  const QuizView({super.key, required this.subject});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int? _selectedIndex;
  bool _isAnswered = false;
  final StorageService _storage = StorageService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final studyProvider = Provider.of<StudyProvider>(context, listen: false);
    final questions = studyProvider.getQuestionsBySubject(widget.subject);
    if (questions.isNotEmpty && studyProvider.currentQuestionIndex < questions.length) {
      final question = questions[studyProvider.currentQuestionIndex];
      final favorites = await _storage.getFavorites();
      if (mounted) {
        setState(() {
          _isFavorite = favorites.contains(question.id);
        });
      }
    }
  }

  Future<void> _toggleFavorite(String id) async {
    if (_isFavorite) {
      await _storage.removeFavorite(id);
    } else {
      await _storage.saveFavorite(id);
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

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
          IconButton(
            icon: Icon(_isFavorite ? Icons.bookmark : Icons.bookmark_border, 
                color: _isFavorite ? AppColors.warning : AppColors.mainText),
            onPressed: () => _toggleFavorite(question.id),
          ),
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
    final wrong = total - correct;
    final percentage = (correct / total * 100).round();

    // 分段激励语
    String emoji, headline, subtitle;
    Color accentColor;
    if (percentage >= 90) {
      emoji = '🏆'; headline = '太厉害了！'; subtitle = '满分冲刺中，继续保持！';
      accentColor = const Color(0xFFFFB800);
    } else if (percentage >= 70) {
      emoji = '👍'; headline = '表现不错！'; subtitle = '再巩固几道，更上一层楼！';
      accentColor = AppColors.primary;
    } else if (percentage >= 50) {
      emoji = '💪'; headline = '继续努力！'; subtitle = '错题是最好的老师，去看看吧。';
      accentColor = AppColors.secondary;
    } else {
      emoji = '📖'; headline = '加油加油！'; subtitle = '基础题要多练，错题本等着你！';
      accentColor = AppColors.accent;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.subject} 练习报告'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () { provider.resetQuiz(); Navigator.pop(context); },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 激励卡
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor, accentColor.withOpacity(0.7)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(headline, style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.85))),
                  const SizedBox(height: 24),
                  Text('$percentage%', style: const TextStyle(
                    fontSize: 64, fontWeight: FontWeight.w900, color: Colors.white)),
                  const Text('正确率', style: TextStyle(
                    fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 详细数据
            Row(
              children: [
                _buildResultStat('答题总数', '$total 题', AppColors.mainText),
                const SizedBox(width: 12),
                _buildResultStat('答对', '$correct 题', Colors.green),
                const SizedBox(width: 12),
                _buildResultStat('答错', '$wrong 题', AppColors.accent),
              ],
            ),
            const SizedBox(height: 32),
            // 操作按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  provider.resetQuiz();
                  // 原地重做：pop当前页，重新push
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => QuizView(subject: widget.subject)));
                },
                icon: const Icon(Icons.replay_rounded, size: 20),
                label: const Text('再做一遍'),
              ),
            ),
            const SizedBox(height: 12),
            if (wrong > 0)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    provider.resetQuiz();
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const WrongAnswersPage()));
                  },
                  icon: const Icon(Icons.replay_circle_filled_rounded, size: 20),
                  label: Text('查看错题（$wrong 道）'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () { provider.resetQuiz(); Navigator.pop(context); },
              child: const Text('返回题库', style: TextStyle(color: AppColors.subText)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
          ],
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
                        bool isCorrect = _selectedIndex == correctAnswer;
                        provider.recordAnswer(isCorrect);
                        if (!isCorrect) {
                          final questions = provider.getQuestionsBySubject(widget.subject);
                          final question = questions[provider.currentQuestionIndex];
                          _storage.saveWrongAnswer(question.id);
                        }
                        setState(() => _isAnswered = true);
                      },
                child: const Text('提交答案'),
              ),
            ),
          if (_isAnswered)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (provider.currentQuestionIndex >= total - 1) {
                    // Quiz finished, save record
                    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                    _storage.saveStudyRecord(date, widget.subject, provider.correctCount, total);
                  }
                  
                  provider.nextQuestion();
                  setState(() {
                    _selectedIndex = null;
                    _isAnswered = false;
                  });
                  if (provider.currentQuestionIndex < total) {
                    _checkFavorite();
                  }
                },
                child: Text(provider.currentQuestionIndex < total - 1 ? '下一题' : '查看结果'),
              ),
            ),
        ],
      ),
    );
  }
}
