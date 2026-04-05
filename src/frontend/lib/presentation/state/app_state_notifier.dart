import 'package:flutter/material.dart';
import '../../data/models/learning_model.dart';
import '../../data/repositories/learning_repository.dart';

/**
 * 【职教通】商用级状态管理引擎 (Task #104)
 * 职责：
 * 1. 集中管理全局学习状态。
 * 2. 调度 Repository 层执行异步数据读写。
 * 3. 驱动全量页面的 UI 响应。
 */
class AppStateNotifier extends ChangeNotifier {
  final LearningRepository _repository;
  
  LearningProgressModel? _progress;
  bool _isLoading = false;

  AppStateNotifier(this._repository) {
    _loadInitialData();
  }

  // Getter
  LearningProgressModel get progress => _progress ?? LearningProgressModel.initial();
  bool get isLoading => _isLoading;

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    _progress = await _repository.getProgress();
    _isLoading = false;
    notifyListeners();
  }

  // 更新考试成绩 (Task #105)
  Future<void> addExamResult(String title, int score) async {
    await _repository.saveExamResult(title, score);
    _progress = await _repository.getProgress();
    notifyListeners();
  }

  // 更新目标分 (Task #97)
  Future<void> updateTargetScore(double score) async {
    await _repository.saveTargetScore(score);
    _progress = await _repository.getProgress();
    notifyListeners();
  }
}

// 供全局便捷访问
final globalStateNotifier = AppStateNotifier(learningRepository);
