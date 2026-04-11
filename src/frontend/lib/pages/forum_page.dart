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
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('树洞', style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.mainText)),
                  SizedBox(height: 4),
                  Text('匿名分享备考心情', style: TextStyle(fontSize: 14, color: AppColors.subText)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: provider.posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _buildPostCard(provider, provider.posts[i]),
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

  Widget _buildPostCard(ForumProvider provider, Post post) {
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
              _buildAction(Icons.favorite_border_rounded, '${post.likes}',
                  () => provider.toggleLike(post.id)),
              const SizedBox(width: 24),
              _buildAction(Icons.chat_bubble_outline_rounded, '${post.commentsCount}', () {}),
              const Spacer(),
              _buildAction(Icons.share_outlined, '', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.subText),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
          ],
        ],
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
