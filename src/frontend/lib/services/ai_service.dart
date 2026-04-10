import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = 'sk-ad16d2814bf640a3b9842b9ed1f04963';
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';
  static const String _model = 'deepseek-chat';

  static const String _systemPrompt = '''你是"粤职通 AI 助教"，一个专门帮助广东中职学生备考"3+证书"高职高考的智能学习助手。

你的核心能力：
1. 解答语文、数学、英语三科的考试题目
2. 提供详细的解题步骤和思路分析
3. 针对学生薄弱环节给出针对性的学习建议
4. 解释 3+证书考试政策、报考流程、院校信息

回答要求：
- 用通俗易懂的语言，适合中职学生的理解水平
- 数学题要写出完整的解题步骤
- 语文题要引用原文分析
- 英语题要解释语法规则
- 回答简洁有条理，用序号或分点列出
- 如果学生的问题不明确，主动引导他们把问题说清楚''';

  static Future<String> getExplanation(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'max_tokens': 1024,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        return '抱歉，AI 助教暂时无法回应（错误码：${response.statusCode}）。请稍后再试。';
      }
    } catch (e) {
      return '网络连接失败，请检查网络后重试。';
    }
  }

  /// 带上下文的多轮对话
  static Future<String> chat(List<Map<String, String>> history) async {
    try {
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _systemPrompt},
        ...history,
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': _model,
          'messages': messages,
          'max_tokens': 1024,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        return '抱歉，AI 助教暂时无法回应（错误码：${response.statusCode}）。请稍后再试。';
      }
    } catch (e) {
      return '网络连接失败，请检查网络后重试。';
    }
  }
}
