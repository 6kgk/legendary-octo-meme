import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/storage_service.dart';
import '../theme.dart';

/// 错题重练页面：逐题重做错题，答对可移除
class WrongPracticePage extends StatefulWidget {
  final List<Question> questions;
  const WrongPracticePage({super.key, required this.questions});

  @override
  State<WrongPracticePage> createState() => _WrongPracticePageState();
}

class _WrongPracticePageState extends State<WrongPracticePage> {
  final StorageService _storage = StorageService();
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _isAnswered = false;
  int _masteredCount = 0; // 答对并移除的数量
  final List<String> _removedIds = [];

  Question get _currentQuestion => widget.questions[_currentIndex];
  bool get _isFinished => _currentIndex >= widget.questions.length;

  void _handleAnswer(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedIndex = index;
      _isAnswered = true;
    });
  }

  Future<void> _next() async {
    final isCorrect = _selectedIndex == _currentQuestion.answerIndex;

    if (isCorrect) {
      // 答对了，从错题本移除
      _masteredCount++;
      _removedIds.add(_currentQuestion.id);
      // 异步移除，不阻塞 UI
      _storage.removeWrongAnswer(_currentQuestion.id);
    }

    setState(() {
      _currentIndex++;
      _selectedIndex = null;
      _isAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) return _buildResultScreen();

    final question = _currentQuestion;
    final progress = (_currentIndex + 1) / widget.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('错题重练'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text('${_currentIndex + 1}/${widget.questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
            valueColor: const AlwaysStoppedAnimation(AppColors.accent),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(question.subject,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Text('错题重练', style: TextStyle(color: AppColors.subText, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(question.content, style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500, height: 1.6, color: AppColors.mainText)),
                  const SizedBox(height: 32),
                  ...List.generate(question.options.length,
                    (index) => _buildOptionTile(index, question.options[index], question.answerIndex)),
                  if (_isAnswered) ...[
                    const SizedBox(height: 24),
                    _buildExplanation(question.explanation),
                  ],
                ],
              ),
            ),
          ),
          if (_isAnswered) _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildOptionTile(int index, String text, int correctIndex) {
    bool isSelected = _selectedIndex == index;
    bool isCorrect = index == correctIndex;

    Color borderColor = AppColors.divider;
    Color bgColor = AppColors.background;
    Widget? trailing;

    if (_isAnswered) {
      if (isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.05);
        trailing = const Icon(Icons.check_circle, color: Colors.green, size: 20);
      } else if (isSelected) {
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.05);
        trailing = const Icon(Icons.cancel, color: Colors.red, size: 20);
      }
    } else if (isSelected) {
      borderColor = AppColors.mainText;
    }

    return GestureDetector(
      onTap: () => _handleAnswer(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Text(String.fromCharCode(65 + index),
              style: TextStyle(fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.mainText : AppColors.subText)),
            const SizedBox(width: 16),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 15, color: AppColors.mainText))),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildExplanation(String text) {
    final isCorrect = _selectedIndex == _currentQuestion.answerIndex;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.05) : AppColors.areaBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCorrect ? Colors.green.withOpacity(0.3) : AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isCorrect ? Icons.check_circle_outline : Icons.lightbulb_outline,
                size: 16, color: isCorrect ? Colors.green : AppColors.mainText),
              const SizedBox(width: 6),
              Text(isCorrect ? '回答正确！此题将从错题本移除' : '再想想，看看解析吧',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
                  color: isCorrect ? Colors.green : AppColors.mainText)),
            ],
          ),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(height: 1.5, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _next,
          child: Text(_currentIndex < widget.questions.length - 1 ? '下一题' : '查看结果'),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final remaining = widget.questions.length - _masteredCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Center(
              child: Text('错题重练完成',
                style: TextStyle(fontSize: 16, color: AppColors.subText, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 12),
            Text('$_masteredCount / ${widget.questions.length}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.mainText)),
            const SizedBox(height: 8),
            const Text('已掌握', style: TextStyle(fontSize: 16, color: AppColors.subText)),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem('已掌握', '$_masteredCount 题'),
                  Container(width: 1, height: 24, color: AppColors.divider),
                  _buildStatItem('仍需复习', '$remaining 题'),
                ],
              ),
            ),
            const SizedBox(height: 48),
            if (_masteredCount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('已从错题本移除 $_masteredCount 道已掌握的题目',
                          style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _removedIds),
                child: const Text('返回错题本'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mainText)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
      ],
    );
  }
}
