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
  int _streak = 0;
  bool _isLoading = true;

  // 各科颜色
  static const Map<String, Color> _subjectColors = {
    '语文': AppColors.primary,
    '数学': AppColors.secondary,
    '英语': AppColors.warning,
  };

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final records = await _storage.getStudyRecords();
    final streak = await _storage.getStudyStreak();
    setState(() {
      _records = records;
      _streak = streak;
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
    final Map<String, List<int>> subjectStats = {};

    for (var r in _records) {
      totalCorrect += (r['correct'] as int);
      totalAnswered += (r['total'] as int);
      final sub = r['subject'] as String? ?? '未知';
      subjectStats.putIfAbsent(sub, () => [0, 0]);
      subjectStats[sub]![0] += (r['correct'] as int);
      subjectStats[sub]![1] += (r['total'] as int);
    }

    final totalAccuracy = totalAnswered > 0 ? (totalCorrect / totalAnswered) * 100 : 0.0;

    // 收集所有有学习记录的日期
    final Set<String> studyDates = _records.map((r) => r['date'] as String).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('学习统计')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallStats(totalAnswered, totalAccuracy, _streak),
            const SizedBox(height: 24),
            _buildWeekCalendar(studyDates),
            const SizedBox(height: 32),
            const Text('分科统计', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
            const SizedBox(height: 16),
            if (subjectStats.isEmpty)
              const Text('暂无分科数据', style: TextStyle(color: AppColors.subText))
            else
              ...['语文', '数学', '英语'].where(subjectStats.containsKey).map(
                (sub) => _buildSubjectRow(sub, subjectStats[sub]![0], subjectStats[sub]![1])),
            const SizedBox(height: 32),
            const Text('每日记录', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
            const SizedBox(height: 16),
            _buildDailyList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStats(int total, double accuracy, int streak) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('累计答题', '$total 题', Colors.white),
          Container(width: 1, height: 36, color: Colors.white24),
          _buildStatItem('正确率', '${accuracy.toStringAsFixed(1)}%', Colors.white),
          Container(width: 1, height: 36, color: Colors.white24),
          _buildStatItem('连续学习', '$streak 天', Colors.white),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color.withOpacity(0.75))),
      ],
    );
  }

  /// 本周7格热力图
  Widget _buildWeekCalendar(Set<String> studyDates) {
    final now = DateTime.now();
    // 找到本周一
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    const weekDays = ['一', '二', '三', '四', '五', '六', '日'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('本周学习', style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(7, (i) {
            final day = weekStart.add(Duration(days: i));
            final dateStr = '${day.year}-${day.month.toString().padLeft(2,'0')}-${day.day.toString().padLeft(2,'0')}';
            final hasStudy = studyDates.contains(dateStr);
            final isToday = day.year == now.year && day.month == now.month && day.day == now.day;
            final isPast = day.isBefore(DateTime(now.year, now.month, now.day));

            return Expanded(
              child: Column(
                children: [
                  Text(weekDays[i], style: const TextStyle(
                    fontSize: 11, color: AppColors.subText)),
                  const SizedBox(height: 6),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: hasStudy
                        ? AppColors.primary
                        : (isToday ? AppColors.primaryLight : AppColors.areaBg),
                      borderRadius: BorderRadius.circular(10),
                      border: isToday ? Border.all(color: AppColors.primary, width: 1.5) : null,
                    ),
                    child: Center(
                      child: hasStudy
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                        : Text('${day.day}', style: TextStyle(
                            fontSize: 12,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isPast && !hasStudy ? AppColors.weakText : AppColors.mainText)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSubjectRow(String subject, int correct, int total) {
    final acc = total > 0 ? (correct / total) : 0.0;
    final color = _subjectColors[subject] ?? AppColors.mainText;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(subject, style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.mainText)),
              ]),
              Text('$correct / $total  ·  ${(acc * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 13, color: AppColors.subText)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: acc,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyList() {
    final Map<String, List<int>> dailyData = {};
    for (var r in _records) {
      final date = r['date'] as String;
      dailyData.putIfAbsent(date, () => [0, 0]);
      dailyData[date]![0] += (r['correct'] as int);
      dailyData[date]![1] += (r['total'] as int);
    }

    final sortedDates = dailyData.keys.toList()..sort((a, b) => b.compareTo(a));

    if (sortedDates.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: const Column(
          children: [
            Icon(Icons.bar_chart_rounded, size: 36, color: AppColors.weakText),
            SizedBox(height: 8),
            Text('暂无学习记录', style: TextStyle(color: AppColors.subText)),
            SizedBox(height: 4),
            Text('完成练习后数据将显示在这里', style: TextStyle(color: AppColors.weakText, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedDates.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final correct = dailyData[date]![0];
        final total = dailyData[date]![1];
        final acc = total > 0 ? ((correct / total) * 100).round() : 0;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          color: AppColors.cardBg,
          child: Row(
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: acc >= 70 ? Colors.green : AppColors.accent,
                  shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(date, style: const TextStyle(
                  fontSize: 14, color: AppColors.mainText))),
              Text('$total 题  ·  正确率 $acc%',
                style: const TextStyle(fontSize: 13, color: AppColors.subText)),
            ],
          ),
        );
      },
    );
  }
}
