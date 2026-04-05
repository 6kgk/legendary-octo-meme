import 'dart:convert';

class LearningProgressModel {
  final double currentScore;
  final double targetScore;
  final String improvementRate;
  final String nationalPercentile;
  final List<String> medals;
  final List<ExamResultModel> examHistory;
  final List<WrongQuestionModel> wrongQuestions;

  LearningProgressModel({
    required this.currentScore,
    required this.targetScore,
    required this.improvementRate,
    required this.nationalPercentile,
    required this.medals,
    required this.examHistory,
    required this.wrongQuestions,
  });

  factory LearningProgressModel.initial() {
    return LearningProgressModel(
      currentScore: 272.0,
      targetScore: 350.0,
      improvementRate: "15.4%",
      nationalPercentile: "92.8%",
      medals: ["提分先锋", "考场战神", "认知达人"],
      examHistory: [
        ExamResultModel(title: "广东省 3+证书 数学 (A)", score: 128, date: "2026-04-01"),
        ExamResultModel(title: "PETS-1 英语模拟", score: 92, date: "2026-04-03"),
      ],
      wrongQuestions: [
        WrongQuestionModel(
          title: "相似三角形比", 
          root: "比例性质混淆",
          category: "概念未掌握",
          nextReviewDate: "2026-04-07",
          reviewCount: 2,
        ),
        WrongQuestionModel(
          title: "二次函数开口", 
          root: "系数 a 的正负号误判",
          category: "计算粗心",
          nextReviewDate: "2026-04-08",
          reviewCount: 1,
        ),
        WrongQuestionModel(
          title: "诱导公式 sin(180+a)", 
          root: "象限判定逻辑断层",
          category: "逻辑断层",
          nextReviewDate: "2026-04-06",
          reviewCount: 3,
        ),
      ],
    );
  }

  LearningProgressModel copyWith({
    double? currentScore,
    double? targetScore,
    String? improvementRate,
    String? nationalPercentile,
    List<String>? medals,
    List<ExamResultModel>? examHistory,
    List<WrongQuestionModel>? wrongQuestions,
  }) {
    return LearningProgressModel(
      currentScore: currentScore ?? this.currentScore,
      targetScore: targetScore ?? this.targetScore,
      improvementRate: improvementRate ?? this.improvementRate,
      nationalPercentile: nationalPercentile ?? this.nationalPercentile,
      medals: medals ?? this.medals,
      examHistory: examHistory ?? this.examHistory,
      wrongQuestions: wrongQuestions ?? this.wrongQuestions,
    );
  }
}

class ExamResultModel {
  final String title;
  final int score;
  final String date;

  ExamResultModel({required this.title, required this.score, required this.date});
}

class WrongQuestionModel {
  final String title;
  final String root;
  final String category; // 错误归类: 计算粗心 / 逻辑断层 / 概念未掌握
  final String nextReviewDate; // 艾宾浩斯重练日期
  final int reviewCount; // 复习次数

  WrongQuestionModel({
    required this.title, 
    required this.root,
    required this.category,
    required this.nextReviewDate,
    this.reviewCount = 0,
  });

  factory WrongQuestionModel.fromJson(Map<String, dynamic> json) {
    return WrongQuestionModel(
      title: json['title'],
      root: json['root'],
      category: json['category'],
      nextReviewDate: json['nextReviewDate'],
      reviewCount: json['reviewCount'] ?? 0,
    );
  }
}
