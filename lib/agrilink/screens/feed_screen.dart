import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/post_card.dart';

const categories = ['Tout', 'Irrigation', 'Maladies', 'Semences', 'Marché', 'Matériel'];

class FeedScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onPublish;
  const FeedScreen({super.key, required this.state, required this.onPublish});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String activeCategory = 'Tout';

  @override
  Widget build(BuildContext context) {
    final filtered = activeCategory == 'Tout'
      ? widget.state.posts
      : widget.state.posts.where((p) => p.category == activeCategory).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 16),
        // Stats strip
        Row(
          children: [
            _statCard('📝', '${widget.state.currentUser?.posts ?? 0}', 'Publications'),
            const SizedBox(width: 10),
            _statCard('👥', '${widget.state.currentUser?.followers ?? 0}', 'Abonnés'),
            const SizedBox(width: 10),
            _statCard('🔖', '${widget.state.savedPosts.length}', 'Sauvegardés'),
          ],
        ),
        const SizedBox(height: 16),
        // Categories
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final active = cat == activeCategory;
              return GestureDetector(
                onTap: () => setState(() => activeCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: active ? const LinearGradient(colors: [AppColors.mediumGreen, AppColors.lightGreen]) : null,
                    color: active ? null : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: active ? Colors.transparent : AppColors.borderGreen, width: 2),
                  ),
                  child: Text(cat, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.softGreen)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Section title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Publications récentes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
            Text('${filtered.length} articles', style: const TextStyle(fontSize: 11, color: AppColors.softGreen)),
          ],
        ),
        const SizedBox(height: 10),
        // Posts
        ...filtered.map((post) => PostCard(
          post: post,
          isLiked: widget.state.likedPosts.contains(post.id),
          onLike: () => widget.state.toggleLike(post.id),
          onSave: () => widget.state.toggleSave(post.id),
        )),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _statCard(String icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.darkGreen)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.softGreen)),
          ],
        ),
      ),
    );
  }
}