import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/ai_service.dart';

class AITutorPage extends StatefulWidget {
  const AITutorPage({super.key});

  @override
  State<AITutorPage> createState() => _AITutorPageState();
}

class _AITutorPageState extends State<AITutorPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [
    {
      "role": "ai",
      "content": "你好！我是你的 3+证书 AI 助教。你可以发给我题目，或者询问报考政策，我会为你提供专业的解析。"
    }
  ];
  bool _isLoading = false;

  void _handleSendMessage({String? overrideText}) async {
    final text = overrideText ?? _controller.text.trim();
    if (text.isEmpty) return;

    if (overrideText == null) {
      _controller.clear();
    }

    setState(() {
      _messages.add({"role": "user", "content": text});
      _isLoading = true;
    });

    _scrollToBottom();

    final response = await AIService.getExplanation(text);

    if (mounted) {
      setState(() {
        _messages.add({"role": "ai", "content": response});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 助教'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageTile(msg['role'] == 'ai', msg['content']!);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'AI 正在思考中...',
                style: TextStyle(fontSize: 12, color: AppColors.subText),
              ),
            ),
          _buildQuickActions(),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = ['语文字音辨析', '数学三角函数', '英语语法填空'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              actions[index],
              style: const TextStyle(fontSize: 12, color: AppColors.mainText),
            ),
            backgroundColor: AppColors.areaBg,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onPressed: () => _handleSendMessage(overrideText: actions[index]),
          );
        },
      ),
    );
  }

  Widget _buildMessageTile(bool isAi, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (isAi) ...[
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.mainText,
                  child: Icon(Icons.psychology, size: 14, color: AppColors.background),
                ),
                const SizedBox(width: 8),
                const Text('AI 助教', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ] else ...[
                const Text('我', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.areaBg,
                  child: Icon(Icons.person, size: 14, color: AppColors.mainText),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isAi ? AppColors.areaBg : AppColors.mainText,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: isAi ? AppColors.mainText : AppColors.background,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '输入题目或问题...',
                hintStyle: const TextStyle(color: AppColors.weakText),
                filled: true,
                fillColor: AppColors.areaBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _handleSendMessage,
            icon: const Icon(Icons.send, color: AppColors.mainText),
          ),
        ],
      ),
    );
  }
}
