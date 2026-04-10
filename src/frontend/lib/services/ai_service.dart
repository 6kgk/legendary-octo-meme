import 'dart:async';

class AIService {
  static Future<String> getExplanation(String query) async {
    await Future.delayed(const Duration(seconds: 1));

    if (query.contains('数学') || query.contains('函数') || query.contains('三角')) {
      return '''三角函数核心考点解析

对于 3+证书数学，三角函数求值通常遵循以下步骤：

1. 诱导公式：先将大角化小角，如 sin(180° - α) = sin α
2. 符号判断：根据象限判断正负（一全正、二正弦、三切、四余弦）
3. 特殊角：熟记 30°、45°、60° 的三角函数值

示例题解：
求 sin 150° 的值。
解：sin 150° = sin(180° - 30°) = sin 30° = 1/2
''';
    }

    if (query.contains('英语') || query.contains('语法') || query.contains('English')) {
      return '''英语语法高频考点

3+证书英语常考语法点：

1. 时态辨析：一般过去时 vs 现在完成时
   - I have lived here for 5 years. (强调持续)
   - I lived there in 2020. (强调过去某时间点)

2. 定语从句：who/which/that 的选用
   - 先行词是人用 who/that
   - 先行词是物用 which/that

3. 固定搭配：look forward to doing, be used to doing
''';
    }

    if (query.contains('语文') || query.contains('成语') || query.contains('古诗')) {
      return '''语文选择题高频考点

1. 字音辨析：注意多音字和易错读音
   - 休憩(qì) 狡黠(xiá) 渲染(xuàn)

2. 成语辨析：注意褒贬色彩和使用对象
   - "巧夺天工"只能形容人工制品，不能形容自然景观
   - "首当其冲"是最先受到攻击，不是"首先"的意思

3. 病句辨析：常见类型
   - 两面对一面（"能否...取决于..."）
   - 成分残缺（缺主语或宾语）
''';
    }

    return '你好！我是你的粤职通 AI 助教。你可以问我关于 3+证书 的任何考点，比如"数学三角函数怎么求"、"英语语法考什么"、"语文成语辨析"等。';
  }
}
