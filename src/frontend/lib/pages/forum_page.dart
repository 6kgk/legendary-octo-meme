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
      appBar: AppBar(
        title: const Text('树洞'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: provider.posts.length,
        itemBuilder: (context, index) {
          return _buildPostTile(context, provider, provider.posts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context, provider),
        backgroundColor: AppColors.mainText,
        foregroundColor: AppColors.background,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostTile(BuildContext context, ForumProvider provider, Post post) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.areaBg,
                child: Icon(Icons.person_outline, size: 14, color: AppColors.mainText),
              ),
              const SizedBox(width: 8),
              Text(
                post.author,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.mainText),
              ),
              const Spacer(),
              Text(
                post.time,
                style: const TextStyle(fontSize: 12, color: AppColors.weakText),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            post.content,
            style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.mainText),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.favorite_border,
                label: post.likes.toString(),
                onTap: () => provider.toggleLike(post.id),
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                label: post.commentsCount.toString(),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.subText),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context, ForumProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('发布新说说'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: '分享你的备考心情或疑问...',
            hintStyle: const TextStyle(color: AppColors.weakText),
            filled: true,
            fillColor: AppColors.areaBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.addPost(controller.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
            child: const Text('发布'),
          ),
        ],
      ),
    );
  }
}
