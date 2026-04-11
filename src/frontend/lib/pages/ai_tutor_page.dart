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
    {'role': 'ai', 'content': '你好！我是你的 3+证书 AI 助教，由 DeepSeek 大模型驱动。你可以问我任何关于语文、数学、英语的题目，我会给你详细的解析。'}
  ];
  bool _isLoading = false;

  final List<String> _quickChips = ['数学三角函数怎么解', '英语语法填空技巧', '语文成语辨析方法', '3+证书报考政策'];

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'content': text.trim()});
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    final history = _messages
        .map((m) => {'role': m['role'] == 'ai' ? 'assistant' : 'user', 'content': m['content']!})
        .toList();
    final response = await AIService.chat(history);

    if (mounted) {
      setState(() {
        _messages.add({'role': 'ai', 'content': response});
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 14, color: AppColors.secondary),
                SizedBox(width: 4),
                Text('DeepSeek', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick chips
          if (_messages.length <= 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Row(
                children: _quickChips.map((chip) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _sendMessage(chip),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(chip, style: const TextStyle(
                        fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
                    ),
                  ),
                )).toList(),
              ),
            ),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildBubble(_messages[i]),
            ),
          ),
          // Loading
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: Row(
                children: [
                  SizedBox(width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                  const SizedBox(width: 8),
                  const Text('AI 正在思考...', style: TextStyle(fontSize: 13, color: AppColors.subText)),
                ],
              ),
            ),
          // Input
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildBubble(Map<String, String> msg) {
    final isAi = msg['role'] == 'ai';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAi)
            Container(
              width: 32, height: 32, margin: const EdgeInsets.only(right: 10, top: 4),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.psychology_rounded, size: 18, color: Colors.white),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isAi ? AppColors.cardBg : AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isAi ? 4 : 18),
                  bottomRight: Radius.circular(isAi ? 18 : 4),
                ),
                border: isAi ? Border.all(color: AppColors.divider) : null,
              ),
              child: Text(msg['content']!, style: TextStyle(
                fontSize: 15, height: 1.6,
                color: isAi ? AppColors.mainText : Colors.white)),
            ),
          ),
          if (!isAi) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [BoxShadow(color: AppColors.mainText.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '输入你的问题...',
                filled: true, fillColor: AppColors.areaBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
