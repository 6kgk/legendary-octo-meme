import 'package:flutter/material.dart';
import '../theme.dart';

class PostsManagePage extends StatefulWidget {
  const PostsManagePage({super.key});

  @override
  State<PostsManagePage> createState() => _PostsManagePageState();
}

class _PostsManagePageState extends State<PostsManagePage> {
  final List<Map<String, dynamic>> _posts = [
    {'author': '深职大小迷妹', 'content': '今天在图书馆复习数学，三角函数真的好难', 'status': '已审核', 'time': '10分钟前'},
    {'author': '广轻工准学子', 'content': '刚查了去年分数线，感觉要再努力', 'status': '待审核', 'time': '30分钟前'},
    {'author': '匿名用户', 'content': '有人买到答案了吗？？？', 'status': '已举报', 'time': '1小时前'},
    {'author': '中职老司机', 'content': '建议多刷真题，特别是英语语法填空', 'status': '已审核', 'time': '2小时前'},
    {'author': '备考打工人', 'content': '数列公式总结，希望对大家有用', 'status': '待审核', 'time': '3小时前'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('内容审核')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: AdminColors.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            itemCount: _posts.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: AdminColors.divider),
            itemBuilder: (_, i) {
              final p = _posts[i];
              Color statusColor;
              if (p['status'] == '已举报') {
                statusColor = AdminColors.danger;
              } else if (p['status'] == '待审核') {
                statusColor = AdminColors.warning;
              } else {
                statusColor = AdminColors.success;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AdminColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, size: 20, color: AdminColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(p['author'], style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14, color: AdminColors.mainText)),
                              const Spacer(),
                              Text(p['time'], style: const TextStyle(
                                fontSize: 12, color: AdminColors.weakText)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(p['content'], style: const TextStyle(
                            fontSize: 14, color: AdminColors.mainText, height: 1.4)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(p['status'], style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
                              ),
                              const Spacer(),
                              if (p['status'] != '已审核')
                                TextButton(
                                  onPressed: () => setState(() => p['status'] = '已审核'),
                                  child: const Text('通过', style: TextStyle(color: AdminColors.success)),
                                ),
                              if (p['status'] != '已举报')
                                TextButton(
                                  onPressed: () => setState(() => p['status'] = '已举报'),
                                  child: const Text('删除', style: TextStyle(color: AdminColors.danger)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
