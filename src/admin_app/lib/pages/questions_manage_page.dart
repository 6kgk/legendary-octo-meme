import 'package:flutter/material.dart';
import '../theme.dart';

class QuestionsManagePage extends StatefulWidget {
  const QuestionsManagePage({super.key});

  @override
  State<QuestionsManagePage> createState() => _QuestionsManagePageState();
}

class _QuestionsManagePageState extends State<QuestionsManagePage> {
  String _selectedSubject = '全部';
  final List<Map<String, dynamic>> _questions = [];
  @override
  void initState() {
    super.initState();
    _loadDemoData();
  }

  void _loadDemoData() {
    final subjects = ['语文', '数学', '英语'];
    for (int i = 0; i < 30; i++) {
      _questions.add({
        'id': 'q_$i',
        'subject': subjects[i % 3],
        'content': '示例题目 ${i + 1}：这是一道${subjects[i % 3]}选择题...',
        'year': '2024',
        'status': i % 5 == 0 ? '待审核' : '已发布',
      });
    }
    setState(() {});
  }

  List<Map<String, dynamic>> get _filteredQuestions {
    if (_selectedSubject == '全部') return _questions;
    return _questions.where((q) => q['subject'] == _selectedSubject).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('题库管理'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showAddDialog(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('添加题目'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(120, 40)),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Filters
            Row(
              children: ['全部', '语文', '数学', '英语'].map((s) {
                final sel = _selectedSubject == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(s),
                    selected: sel,
                    onSelected: (_) => setState(() => _selectedSubject = s),
                    selectedColor: AdminColors.primaryLight,
                    labelStyle: TextStyle(
                      color: sel ? AdminColors.primary : AdminColors.subText,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AdminColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: AdminColors.divider)),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 60, child: Text('ID', style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13, color: AdminColors.subText))),
                          SizedBox(width: 60, child: Text('科目', style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13, color: AdminColors.subText))),
                          Expanded(child: Text('题目内容', style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13, color: AdminColors.subText))),
                          SizedBox(width: 60, child: Text('年份', style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13, color: AdminColors.subText))),
                          SizedBox(width: 80, child: Text('状态', style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13, color: AdminColors.subText))),
                          SizedBox(width: 80, child: Text('操作', style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13, color: AdminColors.subText))),
                        ],
                      ),
                    ),
                    // Rows
                    Expanded(
                      child: ListView.separated(
                        itemCount: _filteredQuestions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: AdminColors.divider),
                        itemBuilder: (_, i) {
                          final q = _filteredQuestions[i];
                          final isPending = q['status'] == '待审核';
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            child: Row(
                              children: [
                                SizedBox(width: 60, child: Text(q['id'],
                                  style: const TextStyle(fontSize: 13, color: AdminColors.subText))),
                                SizedBox(width: 60, child: Text(q['subject'],
                                  style: const TextStyle(fontSize: 13, color: AdminColors.mainText))),
                                Expanded(child: Text(q['content'], maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, color: AdminColors.mainText))),
                                SizedBox(width: 60, child: Text(q['year'],
                                  style: const TextStyle(fontSize: 13, color: AdminColors.subText))),
                                SizedBox(width: 80, child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isPending ? AdminColors.warning.withOpacity(0.1) : AdminColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(q['status'], textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                                      color: isPending ? AdminColors.warning : AdminColors.success)),
                                )),
                                SizedBox(width: 80, child: Row(
                                  children: [
                                    IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () {},
                                      color: AdminColors.primary, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                                    const SizedBox(width: 8),
                                    IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () {},
                                      color: AdminColors.danger, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                                  ],
                                )),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('添加新题目'),
        content: const SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: '题目内容')),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: '选项 A')),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: '正确答案索引 (0-3)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('保存')),
        ],
      ),
    );
  }
}
