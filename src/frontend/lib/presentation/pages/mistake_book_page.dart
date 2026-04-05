import 'package:flutter/material.dart';
import '../../data/models/learning_model.dart';
import '../state/app_state_notifier.dart';

/**
 * 【职教通】认知聚类错题本 (Task #111)
 * 职责：
 * 1. 按错误原因进行聚类展示。
 * 2. 关联艾宾浩斯复习计划。
 * 3. 一键开启“认知溯源”重练。
 */
class MistakeBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: globalStateNotifier,
      builder: (context, _) {
        final progress = globalStateNotifier.progress;
        final grouped = _groupMistakes(progress.wrongQuestions);

        return Scaffold(
          appBar: AppBar(title: Text('认知聚类错题本')),
          body: ListView(
            padding: EdgeInsets.all(20),
            children: [
              _buildCategoryStats(progress.wrongQuestions),
              SizedBox(height: 25),
              ...grouped.entries.map((entry) => _buildCategorySection(entry.key, entry.value)).toList(),
            ],
          ),
        );
      }
    );
  }

  Map<String, List<WrongQuestionModel>> _groupMistakes(List<WrongQuestionModel> mistakes) {
    Map<String, List<WrongQuestionModel>> grouped = {};
    for (var m in mistakes) {
      grouped.putIfAbsent(m.category, () => []).add(m);
    }
    return grouped;
  }

  Widget _buildCategoryStats(List<WrongQuestionModel> mistakes) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Color(0xFF1D4E89), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("概念未掌握", mistakes.where((m) => m.category == '概念未掌握').length.toString()),
          _buildStatItem("逻辑断层", mistakes.where((m) => m.category == '逻辑断层').length.toString()),
          _buildStatItem("计算粗心", mistakes.where((m) => m.category == '计算粗心').length.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(children: [Text(count, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), Text(label, style: TextStyle(color: Colors.white70, fontSize: 11))]);
  }

  Widget _buildCategorySection(String category, List<WrongQuestionModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(width: 4, height: 16, color: Color(0xFF1D4E89)),
              SizedBox(width: 10),
              Text(category, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ...items.map((item) => _buildMistakeItem(item)).toList(),
      ],
    );
  }

  Widget _buildMistakeItem(WrongQuestionModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(Icons.history_edu, color: _getCategoryColor(item.category)),
          SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('病根：${item.root}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ])),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('下次重练', style: TextStyle(fontSize: 10, color: Colors.blue)),
              Text(item.nextReviewDate, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    if (cat == '概念未掌握') return Colors.red;
    if (cat == '逻辑断层') return Colors.orange;
    return Colors.blue;
  }
}
