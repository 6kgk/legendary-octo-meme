import 'package:flutter/material.dart';
import '../theme.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _selectedType = 0;
  final _controller = TextEditingController();
  final _contactController = TextEditingController();
  bool _submitted = false;

  final _types = [
    {'icon': Icons.bug_report_rounded, 'label': 'Bug 反馈', 'color': AppColors.accent},
    {'icon': Icons.lightbulb_rounded, 'label': '功能建议', 'color': AppColors.warning},
    {'icon': Icons.help_rounded, 'label': '使用疑问', 'color': AppColors.primary},
    {'icon': Icons.thumb_up_rounded, 'label': '体验表扬', 'color': AppColors.secondary},
  ];

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSuccessScreen();

    return Scaffold(
      appBar: AppBar(title: const Text('帮助与反馈')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('常见问题', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
            const SizedBox(height: 16),
            _buildFaqItem('如何使用刷题功能？', '进入"刷题"页面，选择语文/数学/英语任一科目，即可开始答题。答完后会显示正确答案和解析。'),
            _buildFaqItem('AI 助教支持哪些问题？', 'AI 助教由 DeepSeek 大模型驱动，可以解答 3+证书考试的语文、数学、英语题目，也可以回答报考政策问题。'),
            _buildFaqItem('错题本数据会丢失吗？', '错题本数据保存在本地设备上。卸载 APP 会清除数据，建议备考前不要卸载。'),
            _buildFaqItem('院校分数线准确吗？', '院校数据来源于公开信息，分数线以广东省教育考试院官方公布为准。'),

            const SizedBox(height: 32),
            const Text('提交反馈', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
            const SizedBox(height: 16),

            // Type selector
            Row(
              children: List.generate(_types.length, (i) {
                final t = _types[i];
                final selected = _selectedType == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = i),
                    child: Container(
                      margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? (t['color'] as Color).withOpacity(0.1) : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? t['color'] as Color : AppColors.divider, width: selected ? 1.5 : 1),
                      ),
                      child: Column(
                        children: [
                          Icon(t['icon'] as IconData, size: 22,
                            color: selected ? t['color'] as Color : AppColors.weakText),
                          const SizedBox(height: 6),
                          Text(t['label'] as String, style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600,
                            color: selected ? t['color'] as Color : AppColors.subText)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Content
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(hintText: '请详细描述你的问题或建议...'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(
                hintText: '联系方式（QQ/微信/手机，选填）',
                prefixIcon: Icon(Icons.contact_mail_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _controller.text.trim().isEmpty ? null : () {
                  setState(() => _submitted = true);
                },
                child: const Text('提交反馈'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(question, style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.mainText)),
        children: [
          Text(answer, style: const TextStyle(
            fontSize: 14, height: 1.5, color: AppColors.subText)),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('帮助与反馈')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.check_circle_rounded, size: 44, color: AppColors.secondary),
              ),
              const SizedBox(height: 24),
              const Text('感谢你的反馈！', style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.mainText)),
              const SizedBox(height: 8),
              const Text('我们会认真查看每一条反馈，持续改进粤职通。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.subText)),
              const SizedBox(height: 32),
              SizedBox(
                width: 160, height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('返回'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
