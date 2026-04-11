import 'package:flutter/material.dart';
import '../theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于粤职通')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo
            Container(
              width: 88, height: 88,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: const Icon(Icons.school_rounded, size: 44, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text('粤职通', style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.mainText)),
            const SizedBox(height: 4),
            const Text('广东3+证书高职高考备考助手', style: TextStyle(
              fontSize: 14, color: AppColors.subText)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('v2.0.0', style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ),
            const SizedBox(height: 40),

            // Features section
            _buildSection('核心功能', [
              _buildFeatureItem(Icons.quiz_rounded, '真题刷题',
                '收录 150+ 道语文、数学、英语 3+证书历年真题，带详细解析', AppColors.primary),
              _buildFeatureItem(Icons.school_rounded, '院校查询',
                '30+ 所广东高职院校信息，含投档线、专业、官网', AppColors.secondary),
              _buildFeatureItem(Icons.psychology_rounded, 'AI 助教',
                '基于 DeepSeek 大模型，智能解答考试题目和政策问题', AppColors.warning),
              _buildFeatureItem(Icons.chat_bubble_rounded, '备考社区',
                '匿名树洞，分享备考心情，互相鼓励', AppColors.accent),
            ]),
            const SizedBox(height: 32),

            // Tech stack
            _buildSection('技术栈', [
              _buildInfoRow('前端框架', 'Flutter 3.24'),
              _buildInfoRow('AI 引擎', 'DeepSeek Chat API'),
              _buildInfoRow('状态管理', 'Provider'),
              _buildInfoRow('数据存储', 'SharedPreferences'),
              _buildInfoRow('CI/CD', 'GitHub Actions'),
            ]),
            const SizedBox(height: 32),

            // Contact
            _buildSection('联系我们', [
              _buildInfoRow('GitHub', 'github.com/6kgk'),
              _buildInfoRow('邮箱', 'feedback@yuezhitong.com'),
            ]),
            const SizedBox(height: 32),

            // Disclaimer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.areaBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('免责声明', style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.mainText)),
                  SizedBox(height: 8),
                  Text(
                    '本应用仅供学习参考。院校信息和分数线数据来源于公开渠道，'
                    '实际录取以广东省教育考试院官方公布为准。'
                    'AI 助教回答仅供参考，不保证 100% 准确。',
                    style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.subText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Made with Flutter', style: TextStyle(
              fontSize: 12, color: AppColors.weakText)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.mainText)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(
            fontSize: 14, color: AppColors.subText))),
          Expanded(child: Text(value, style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.mainText))),
        ],
      ),
    );
  }
}
