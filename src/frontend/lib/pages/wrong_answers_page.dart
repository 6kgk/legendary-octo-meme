import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../services/study_provider.dart';
import '../models/app_models.dart';
import '../theme.dart';
import 'wrong_practice_page.dart';

class WrongAnswersPage extends StatefulWidget {
  const WrongAnswersPage({super.key});

  @override
  State<WrongAnswersPage> createState() => _WrongAnswersPageState();
}

class _WrongAnswersPageState extends State<WrongAnswersPage> {
  final StorageService _storage = StorageService();
  List<Question> _wrongQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWrongAnswers();
  }

  Future<void> _loadWrongAnswers() async {
    final studyProvider = Provider.of<StudyProvider>(context, listen: false);
    if (!studyProvider.isLoaded) {
      await studyProvider.loadData();
    }
    
    final wrongIds = await _storage.getWrongAnswers();
    final List<Question> questions = [];
    for (final id in wrongIds) {
      final q = studyProvider.getQuestionById(id);
      if (q != null) questions.add(q);
    }
    
    setState(() {
      _wrongQuestions = questions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('错题本'),
        actions: [
          if (_wrongQuestions.isNotEmpty)
            TextButton.icon(
              onPressed: _startPractice,
              icon: const Icon(Icons.replay_rounded, size: 18),
              label: const Text('重新练习'),
              style: TextButton.styleFrom(foregroundColor: AppColors.accent),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wrongQuestions.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _wrongQuestions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final question = _wrongQuestions[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      title: Text(
                        question.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '科目：${question.subject}',
                          style: const TextStyle(color: AppColors.subText, fontSize: 12),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.weakText),
                      onTap: () {
                        // For re-doing, we could navigate to a special quiz view
                        // Or just show the answer for now.
                        // Let's show a simple alert or bottom sheet with the question.
                        _showQuestionDetail(question);
                      },
                    );
                  },
                ),
    );
  }

  Future<void> _startPractice() async {
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (_) => WrongPracticePage(questions: List.from(_wrongQuestions))),
    );
    // 如果有题目被移除（答对了），刷新列表
    if (result != null && result.isNotEmpty) {
      setState(() {
        _wrongQuestions.removeWhere((q) => result.contains(q.id));
      });
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 64, color: AppColors.weakText),
          const SizedBox(height: 16),
          const Text('没有错题，继续保持哦！', style: TextStyle(color: AppColors.subText)),
        ],
      ),
    );
  }

  void _showQuestionDetail(Question question) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.areaBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(question.subject, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(question.content, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              ...List.generate(question.options.length, (index) {
                final isCorrect = index == question.answerIndex;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green.withOpacity(0.05) : AppColors.areaBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isCorrect ? Colors.green : AppColors.divider, width: 1),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: isCorrect ? Colors.green : AppColors.weakText,
                        child: Text(String.fromCharCode(65 + index), style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(question.options[index])),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              const Text('解析', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(question.explanation, style: const TextStyle(color: AppColors.subText, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
