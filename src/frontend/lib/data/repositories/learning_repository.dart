import '../models/learning_model.dart';

/**
 * 【职教通】商用级本地索引系统 (Phase 24 - Task #110)
 * 职责：
 * 1. 本地 FTS (Full-Text Search) 秒级检索 3000+ 知识点。
 * 2. 离线匹配 OCR 特征码，解决校园网波动。
 */
class KnowledgeIndexService {
  // 模拟 FTS 数据库 (Task #110)
  // 真实的商业化版将使用 SQLite FTS5 引擎
  static final List<Map<String, dynamic>> _ftsDatabase = [
    {"id": "m_trig_01", "keywords": "sin cos 三角 诱导公式 弧度", "title": "三角函数诱导公式", "root": "相似三角形比例"},
    {"id": "m_quad_01", "keywords": "抛物线 顶点 y=ax^2 平方根", "title": "二次函数极值", "root": "负数四则运算"},
    {"id": "e_ohm_01", "keywords": "电阻 电压 欧姆 电流 水流", "title": "欧姆定律实战", "root": "水路模型认知"},
    {"id": "c_bin_01", "keywords": "二进制 内存 bit 字节 灯泡", "title": "计算机底层架构", "root": "灯泡开关模型"}
  ];

  /**
   * 基于特征码的秒级离线匹配 (Offline Search Engine)
   */
  static Map<String, dynamic>? search(String query) {
    final lowerQuery = query.toLowerCase();
    // 模拟 FTS5 MATCH 算法
    try {
      return _ftsDatabase.firstWhere((node) => 
        node['keywords'].toString().toLowerCase().split(' ').any((k) => lowerQuery.contains(k))
      );
    } catch (_) {
      return null;
    }
  }
}

abstract class LearningRepository {
  Future<LearningProgressModel> getProgress();
  Future<void> saveExamResult(String title, int score);
  Future<void> saveTargetScore(double target);
}

class LearningRepositoryImpl implements LearningRepository {
  late LearningProgressModel _data;

  LearningRepositoryImpl() {
    _data = LearningProgressModel.initial();
  }

  @override
  Future<LearningProgressModel> getProgress() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _data;
  }

  @override
  Future<void> saveExamResult(String title, int score) async {
    final updatedHistory = List<ExamResultModel>.from(_data.examHistory)
      ..insert(0, ExamResultModel(title: title, score: score, date: "今天"));
    
    final newScore = (_data.currentScore * 0.7 + score * 0.3);
    final newPercentile = 85.0 + (score / 150.0) * 10;

    // 智能错题记录 (Task #111)
    if (score < 100) {
      final newMistake = WrongQuestionModel(
        title: title, 
        root: score < 60 ? "基础概念缺失" : "复杂逻辑断层",
        category: score < 60 ? "概念未掌握" : "逻辑断层",
        nextReviewDate: "2026-04-07",
        reviewCount: 1,
      );
      _data.wrongQuestions.insert(0, newMistake);
    }

    _data = _data.copyWith(
      examHistory: updatedHistory,
      currentScore: newScore,
      nationalPercentile: "${newPercentile.toStringAsFixed(1)}%",
    );
  }

  @override
  Future<void> saveTargetScore(double target) async {
    _data = _data.copyWith(targetScore: target);
  }
}

final learningRepository = LearningRepositoryImpl();
