import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../services/study_provider.dart';
import '../models/app_models.dart';
import '../theme.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final StorageService _storage = StorageService();
  List<Question> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final studyProvider = Provider.of<StudyProvider>(context, listen: false);
    if (!studyProvider.isLoaded) {
      await studyProvider.loadData();
    }
    
    final favIds = await _storage.getFavorites();
    final List<Question> questions = [];
    for (final id in favIds) {
      final q = studyProvider.getQuestionById(id);
      if (q != null) questions.add(q);
    }
    
    setState(() {
      _favorites = questions;
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite(Question question) async {
    await _storage.removeFavorite(question.id);
    setState(() {
      _favorites.removeWhere((q) => q.id == question.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已从收藏夹移除')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favorites.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final question = _favorites[index];
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
                      trailing: const Icon(Icons.bookmark, color: AppColors.warning),
                      onTap: () => _showQuestionDetail(question),
                      onLongPress: () => _confirmRemove(question),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 64, color: AppColors.weakText),
          const SizedBox(height: 16),
          const Text('收藏夹是空的哦', style: TextStyle(color: AppColors.subText)),
        ],
      ),
    );
  }

  void _confirmRemove(Question question) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移除收藏'),
        content: const Text('确定从收藏夹移除该题目吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: AppColors.subText)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _toggleFavorite(question);
            },
            child: const Text('确定', style: TextStyle(color: Colors.redAccent)),
          ),
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
