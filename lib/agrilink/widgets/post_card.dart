import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final bool showDelete;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback? onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLike,
    required this.onSave,
    this.showDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: showDelete ? const Border(left: BorderSide(color: AppColors.lightGreen, width: 4)) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: AppColors.cardGreen, borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(post.avatar, style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.author, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.darkGreen)),
                      Text('${post.region} · ${post.time}', style: const TextStyle(fontSize: 11, color: AppColors.softGreen)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.cardGreen, borderRadius: BorderRadius.circular(20)),
                  child: Text('${post.tag} ${post.category}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.mediumGreen)),
                ),
                if (showDelete && onDelete != null) ...[
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onDelete,
                    child: Opacity(opacity: 0.6, child: const Text('🗑️', style: TextStyle(fontSize: 18))),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(post.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.darkGreen, height: 1.3)),
            const SizedBox(height: 8),
            Text(post.body, style: const TextStyle(fontSize: 13, color: Color(0xFF5a7a5a), height: 1.6)),
            const SizedBox(height: 14),
            const Divider(color: AppColors.cardGreen, height: 1),
            const SizedBox(height: 10),
            // Actions
            Row(
              children: [
                _actionBtn(isLiked ? '❤️' : '🤍', '${post.likes}', onLike, color: isLiked ? Colors.red : AppColors.softGreen),
                _actionBtn('💬', '${post.comments}', () {}, color: AppColors.softGreen),
                _actionBtn('↗️', 'Partager', () {}, color: AppColors.softGreen),
                _actionBtn(post.saved ? '🔖' : '🏷️', '', onSave, color: post.saved ? Colors.orange : AppColors.softGreen),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(String icon, String label, VoidCallback onTap, {required Color color}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 14)),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 3),
                Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}