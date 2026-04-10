import 'dart:async';
import 'data_loader.dart';
import '../models/app_models.dart';

class AIService {
  static Future<String> getExplanation(String query) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final questions = await DataLoader.loadQuestions();
      
      // 简单的关键词匹配逻辑
      Question? bestMatch;
      int maxOverlap = 0;
      
      final queryLower = query.toLowerCase();
      
      for (var q in questions) {
        int overlap = 0;
        if (q.content.toLowerCase().contains(queryLower)) {
          overlap += 10; // 强匹配
        }
        
        // 检查学科匹配
        if (queryLower.contains(q.subject.toLowerCase())) {
          overlap += 5;
        }
        
        // 简单的关键词拆分匹配
        final keywords = queryLower.split(RegExp(r'[\s，。？！、]')).where((e) => e.length > 1);
        for (var kw in keywords) {
          if (q.content.toLowerCase().contains(kw)) {
            overlap += 2;
          }
        }
        
        if (overlap > maxOverlap) {
          maxOverlap = overlap;
          bestMatch = q;
        }
      }

      if (bestMatch != null && maxOverlap > 5) {
        final answerLabel = String.fromCharCode(65 + bestMatch.answerIndex);
        return '''【为您找到相关题目】
${bestMatch.content}
${bestMatch.options.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}. ${e.value}').join('\n')}

【正确答案】
$answerLabel. ${bestMatch.options[bestMatch.answerIndex]}

【详细解析】
${bestMatch.explanation}

【相关知识点提示】
本题属于 ${bestMatch.subject} 核心考点。建议查阅“粤职通”学习板块中的相关专题进行深度复习。''';
      }
    } catch (e) {
      print('AI Service Error: $e');
    }

    // 通用回复逻辑
    if (query.contains('数学') || query.contains('函数') || query.contains('三角')) {
      return '关于数学三角函数，建议重点掌握：\n1. 诱导公式：奇变偶不变，符号看象限\n2. 特殊角取值：30°/45°/60° 的 sin/cos/tan\n3. 正余弦定理的实际应用。';
    }
    
    if (query.contains('英语') || query.contains('语法')) {
      return '英语语法复习建议：\n1. 词类：介词搭配、动词时态（现在完成时是重点）\n2. 句法：从句引导词、非谓语动词\n3. 多做往年真题中的语法填空。';
    }

    if (query.contains('语文') || query.contains('字音')) {
      return '语文备考锦囊：\n1. 字音：整理常考易错多音字\n2. 成语：区分贬义词与褒义词的误用\n3. 作文：积累关于职教、强国主题的素材。';
    }

    return '你好！我是你的粤职通 AI 助教。我已经在题库中为你准备了丰富的学习资源。\n\n你可以尝试输入关键词：\n• "三角函数"\n• "语法填空"\n• "字音辨析"\n\n或者直接粘贴你想解析的题目给我！';
  }
}
