import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyFavorites = 'favorites';
  static const String _keyWrongAnswers = 'wrong_answers';
  static const String _keyStudyRecords = 'study_records';

  // --- Favorites ---
  Future<void> saveFavorite(String questionId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites) ?? [];
    if (!favorites.contains(questionId)) {
      favorites.add(questionId);
      await prefs.setStringList(_keyFavorites, favorites);
    }
  }

  Future<void> removeFavorite(String questionId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites) ?? [];
    if (favorites.contains(questionId)) {
      favorites.remove(questionId);
      await prefs.setStringList(_keyFavorites, favorites);
    }
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorites) ?? [];
  }

  // --- Wrong Answers ---
  Future<void> saveWrongAnswer(String questionId) async {
    final prefs = await SharedPreferences.getInstance();
    final wrongAnswers = prefs.getStringList(_keyWrongAnswers) ?? [];
    if (!wrongAnswers.contains(questionId)) {
      wrongAnswers.add(questionId);
      await prefs.setStringList(_keyWrongAnswers, wrongAnswers);
    }
  }

  Future<List<String>> getWrongAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyWrongAnswers) ?? [];
  }

  Future<void> removeWrongAnswer(String questionId) async {
    final prefs = await SharedPreferences.getInstance();
    final wrongAnswers = prefs.getStringList(_keyWrongAnswers) ?? [];
    if (wrongAnswers.contains(questionId)) {
      wrongAnswers.remove(questionId);
      await prefs.setStringList(_keyWrongAnswers, wrongAnswers);
    }
  }

  // --- Study Records ---
  // Record structure: { "date": "2026-04-10", "subject": "语文", "correct": 10, "total": 15 }
  Future<void> saveStudyRecord(String date, String subject, int correctCount, int totalCount) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_keyStudyRecords) ?? [];
    
    // Find if a record for this date and subject already exists
    int existingIndex = -1;
    for (int i = 0; i < recordsJson.length; i++) {
      final record = jsonDecode(recordsJson[i]);
      if (record['date'] == date && record['subject'] == subject) {
        existingIndex = i;
        break;
      }
    }

    if (existingIndex != -1) {
      final record = jsonDecode(recordsJson[existingIndex]);
      record['correct'] += correctCount;
      record['total'] += totalCount;
      recordsJson[existingIndex] = jsonEncode(record);
    } else {
      final newRecord = {
        'date': date,
        'subject': subject,
        'correct': correctCount,
        'total': totalCount,
      };
      recordsJson.add(jsonEncode(newRecord));
    }
    
    await prefs.setStringList(_keyStudyRecords, recordsJson);
  }

  Future<List<Map<String, dynamic>>> getStudyRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_keyStudyRecords) ?? [];
    return recordsJson
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  // --- Streak (连续学习天数) ---
  Future<int> getStudyStreak() async {
    final records = await getStudyRecords();
    if (records.isEmpty) return 0;

    // 收集所有学习过的日期（去重）
    final Set<String> studyDates = {};
    for (var r in records) {
      studyDates.add(r['date'] as String);
    }

    // 从今天开始往前数连续天数
    final now = DateTime.now();
    int streak = 0;
    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      if (studyDates.contains(dateStr)) {
        streak++;
      } else {
        // 如果是今天没学但昨天学了，streak从昨天开始算
        if (i == 0) continue;
        break;
      }
    }
    return streak;
  }

  // --- 总答题数统计 ---
  Future<Map<String, int>> getTotalAnswered() async {
    final records = await getStudyRecords();
    int totalCorrect = 0;
    int totalAnswered = 0;
    for (var r in records) {
      totalCorrect += (r['correct'] as int);
      totalAnswered += (r['total'] as int);
    }
    return {'correct': totalCorrect, 'total': totalAnswered};
  }
}
