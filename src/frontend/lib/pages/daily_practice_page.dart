import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../services/study_provider.dart';
import '../theme.dart';

class DailyPracticePage extends StatefulWidget {
  const DailyPracticePage({super.key});

  @override
  State<DailyPracticePage> createState() => _DailyPracticePageState();
}

class _DailyPracticePageState extends State<DailyPracticePage> {
  List<Question> _practiceQuestions = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  final List<bool?> _results = [null, null, null]; // To track which subject was correct
  int? _selectedIndex;
  bool _isAnswered = false;
  late DateTime _startTime;
  Duration? _totalTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _prepareQuestions();
  }

  void _prepareQuestions() {
    final study = Provider.of<StudyProvider>(context, listen: false);
    final subjects = ['语文', '数学', '英语'];
    List<Question> selected = [];

    for (var subject in subjects) {
      final qs = study.getQuestionsBySubject(subject);
      if (qs.isNotEmpty) {
        qs.shuffle();
        selected.add(qs.first);
      }
    }
    setState(() {
      _practiceQuestions = selected;
    });
  }

  void _handleAnswer(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedIndex = index;
      _isAnswered = true;
      bool isCorrect = index == _practiceQuestions[_currentIndex].answerIndex;
      if (isCorrect) _correctCount++;
      _results[_currentIndex] = isCorrect;
    });

    // Auto switch after 1 second
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        if (_currentIndex < _practiceQuestions.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedIndex = null;
            _isAnswered = false;
          });
        } else {
          setState(() {
            _totalTime = DateTime.now().difference(_startTime);
            _currentIndex++; // To show result screen
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_practiceQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('每日一练')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentIndex >= _practiceQuestions.length) {
      return _buildResultScreen();
    }

    final question = _practiceQuestions[_currentIndex];
    final progress = (_currentIndex + 1) / _practiceQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('每日一练'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text('${_currentIndex + 1}/3',
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
            valueColor: const AlwaysStoppedAnimation(AppColors.mainText),
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
                          color: AppColors.mainText,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          question.subject,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '基础练习',
                        style: TextStyle(color: AppColors.subText, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    question.content,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                      color: AppColors.mainText,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ...List.generate(
                    question.options.length,
                    (index) => _buildOptionTile(index, question.options[index], question.answerIndex),
                  ),
                ],
              ),
            ),
          ),
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
            Text(
              String.fromCharCode(65 + index),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.mainText : AppColors.subText,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 15, color: AppColors.mainText),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final subjects = ['语文', '数学', '英语'];
    final timeStr = _totalTime != null 
        ? '${_totalTime!.inMinutes}:${(_totalTime!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '--:--';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Center(
              child: Text('练习完成',
                  style: TextStyle(fontSize: 16, color: AppColors.subText, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 12),
            Text('$_correctCount / 3',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.mainText)),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem('用时', timeStr),
                  Container(width: 1, height: 24, color: AppColors.divider),
                  _buildStatItem('准确率', '${((_correctCount / 3) * 100).round()}%'),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('各科详情',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.mainText)),
                  const SizedBox(height: 16),
                  ...List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.areaBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(subjects[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Text(
                            _results[index] == true ? '正确' : (_results[index] == false ? '错误' : '未做'),
                            style: TextStyle(
                              color: _results[index] == true ? Colors.green : Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _results[index] == true ? Icons.check_circle_outline : Icons.highlight_off,
                            size: 16,
                            color: _results[index] == true ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('返回首页'),
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
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mainText)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
      ],
    );
  }
}
