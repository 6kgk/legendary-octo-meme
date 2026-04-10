import '../models/app_models.dart';
import '../models/mock_data.dart';

class StudyService {
  // 模拟从服务器异步获取学校列表
  static Future<List<School>> getSchools() async {
    await Future.delayed(const Duration(milliseconds: 800)); // 模拟网络延迟
    return MockData.schools;
  }

  // 模拟获取题库科目
  static Future<List<QuestionSubject>> getSubjects() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.subjects;
  }

  // 模拟 AI 解析题目逻辑 (增加客观性校验)
  static Future<Map<String, dynamic>> analyzeQuestion(String content) async {
    await Future.delayed(const Duration(seconds: 2)); 
    // 这里模拟一个标准的、客观的返回结果
    return {
      "knowledgePoint": "等差数列：通项公式与求和",
      "formula": "an = a1 + (n-1)d",
      "steps": [
        "1. 提取已知量：a1=2, d=3, n=10",
        "2. 根据题目要求，代入通项公式：a10 = 2 + (10-1)*3",
        "3. 进行算术计算：a10 = 2 + 27 = 29"
      ],
      "verification": "符合《广东省中职数学考纲》第 4.2 章节标准。"
    };
  }
}
