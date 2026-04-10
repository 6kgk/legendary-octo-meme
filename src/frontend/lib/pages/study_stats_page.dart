import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme.dart';

class StudyStatsPage extends StatefulWidget {
  const StudyStatsPage({super.key});

  @override
  State<StudyStatsPage> createState() => _StudyStatsPageState();
}

class _StudyStatsPageState extends State<StudyStatsPage> {
  final StorageService _storage = StorageService();
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final records = await _storage.getStudyRecords();
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('学习统计')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    int totalCorrect = 0;
    int totalAnswered = 0;
    Map<String, List<int>> subjectStats = {};

    for (var r in _records) {
      totalCorrect += (r['correct'] as int);
      totalAnswered += (r['total'] as int);
      
      String sub = r['subject'] ?? '未知';
      if (!subjectStats.containsKey(sub)) {
        subjectStats[sub] = [0, 0]; // [correct, total]
      }
      subjectStats[sub]![0] += (r['correct'] as int);
      subjectStats[sub]![1] += (r['total'] as int);
    }

    double totalAccuracy = totalAnswered > 0 ? (totalCorrect / totalAnswered) * 100 : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('学习统计')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallStats(totalAnswered, totalAccuracy),
            const SizedBox(height: 32),
            const Text('分科统计', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ...subjectStats.entries.map((e) => _buildSubjectRow(e.key, e.value[0], e.value[1])),
            const SizedBox(height: 32),
            const Text('每日记录', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _buildDailyList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStats(int total, double accuracy) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.mainText,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('累计答题', total.toString(), Colors.white),
          _buildStatItem('正确率', '${accuracy.toStringAsFixed(1)}%', Colors.white),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: color.withOpacity(0.7))),
      ],
    );
  }

  Widget _buildSubjectRow(String subject, int correct, int total) {
    double acc = total > 0 ? (correct / total) : 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('$correct/$total (${(acc * 100).toStringAsFixed(0)}%)', 
                  style: const TextStyle(fontSize: 13, color: AppColors.subText)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: acc,
              minHeight: 8,
              backgroundColor: AppColors.areaBg,
              valueColor: const AlwaysStoppedAnimation(AppColors.mainText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyList() {
    // Group records by date
    Map<String, List<int>> dailyData = {};
    for (var r in _records) {
      String date = r['date'];
      if (!dailyData.containsKey(date)) {
        dailyData[date] = [0, 0];
      }
      dailyData[date]![0] += (r['correct'] as int);
      dailyData[date]![1] += (r['total'] as int);
    }

    var sortedDates = dailyData.keys.toList()..sort((a, b) => b.compareTo(a));

    if (sortedDates.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Text('暂无数据', style: TextStyle(color: AppColors.subText)),
      ));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        String date = sortedDates[index];
        int correct = dailyData[date]![0];
        int total = dailyData[date]![1];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 15)),
              Text('答题 $total | 正确率 ${((correct/total)*100).toStringAsFixed(0)}%', 
                  style: const TextStyle(fontSize: 14, color: AppColors.subText)),
            ],
          ),
        );
      },
    );
  }
}
