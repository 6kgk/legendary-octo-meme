import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/forum_provider.dart';
import '../models/app_models.dart';
import '../theme.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForumProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('树洞', style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.mainText)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('匿名分享备考心情', style: TextStyle(fontSize: 14, color: AppColors.subText)),
                      const Spacer(),
                      Text('${provider.posts.length} 条帖子', style: const TextStyle(
                        fontSize: 13, color: AppColors.weakText)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
                itemCount: provider.posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _PostCard(post: provider.posts[i]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePost(context, provider),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded, size: 20),
        label: const Text('发帖', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showCreatePost(BuildContext context, ForumProvider provider) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(
              color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            const Text('发布新帖', style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.mainText)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(hintText: '分享你的备考心情或疑问...'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    provider.addPost(controller.text.trim());
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('发布'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 单个帖子卡片（StatefulWidget 以支持点赞动画）
class _PostCard extends StatefulWidget {
  final Post post;
  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeScale;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _likeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _likeController.dispose(); super.dispose(); }

  void _handleLike() {
    final provider = Provider.of<ForumProvider>(context, listen: false);
    provider.toggleLike(widget.post.id);
    if (!widget.post.isLiked) {
      // 刚取消了赞，不播放动画
    } else {
      _likeController.forward(from: 0);
    }
  }

  void _showComments() {
    final provider = Provider.of<ForumProvider>(context, listen: false);
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.3,
            expand: false,
            builder: (_, sc) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    children: [
                      Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(
                        color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text('评论 (${widget.post.comments.length})', style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainText)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: const Icon(Icons.close, size: 22, color: AppColors.subText),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 24),
                Expanded(
                  child: widget.post.comments.isEmpty
                    ? const Center(child: Text('暂无评论，快来抢沙发吧！',
                        style: TextStyle(color: AppColors.subText)))
                    : ListView.separated(
                        controller: sc,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: widget.post.comments.length,
                        separatorBuilder: (_, __) => const Divider(height: 20),
                        itemBuilder: (_, i) {
                          final comment = widget.post.comments[i];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.areaBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.person_rounded, size: 16, color: AppColors.subText),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(comment.author, style: const TextStyle(
                                          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.mainText)),
                                        const SizedBox(width: 8),
                                        Text(comment.time, style: const TextStyle(
                                          fontSize: 11, color: AppColors.weakText)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(comment.content, style: const TextStyle(
                                      fontSize: 14, height: 1.4, color: AppColors.mainText)),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ),
                // 输入框
                Container(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(ctx).viewInsets.bottom + 12),
                  decoration: const BoxDecoration(
                    color: AppColors.cardBg,
                    border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: '写条评论...',
                            filled: true, fillColor: AppColors.areaBg,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (commentController.text.trim().isNotEmpty) {
                            provider.addComment(widget.post.id, commentController.text.trim());
                            commentController.clear();
                            setSheetState(() {});
                          }
                        },
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForumProvider>(context);
    final post = widget.post;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_rounded, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.author, style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.mainText)),
                    Text(post.time, style: const TextStyle(fontSize: 12, color: AppColors.weakText)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(post.content, style: const TextStyle(
            fontSize: 15, height: 1.6, color: AppColors.mainText)),
          const SizedBox(height: 16),
          Row(
            children: [
              // 点赞按钮（带动画）
              GestureDetector(
                onTap: _handleLike,
                child: Row(
                  children: [
                    ScaleTransition(
                      scale: _likeScale,
                      child: Icon(
                        post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 18,
                        color: post.isLiked ? AppColors.accent : AppColors.subText,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('${post.likes}', style: TextStyle(
                      fontSize: 13,
                      color: post.isLiked ? AppColors.accent : AppColors.subText,
                      fontWeight: post.isLiked ? FontWeight.w600 : FontWeight.normal,
                    )),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // 评论按钮
              GestureDetector(
                onTap: _showComments,
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.subText),
                    const SizedBox(width: 6),
                    Text('${post.commentsCount}', style: const TextStyle(
                      fontSize: 13, color: AppColors.subText)),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('分享功能即将上线'), duration: Duration(seconds: 1)),
                  );
                },
                child: const Icon(Icons.share_outlined, size: 18, color: AppColors.subText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
