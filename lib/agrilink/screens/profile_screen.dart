import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onPublish;
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.state, required this.onPublish, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final user = widget.state.currentUser!;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 16),
        // Profile card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.lightGreen, AppColors.mediumGreen]),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(child: Text(user.avatar, style: const TextStyle(fontSize: 40))),
              ),
              const SizedBox(height: 12),
              Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.darkGreen)),
              const SizedBox(height: 4),
              Text('📍 ${user.region} · 🌱 ${user.specialty}', style: const TextStyle(fontSize: 13, color: AppColors.softGreen)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _pStat('${user.posts}', 'Publications'),
                  const _PDivider(),
                  _pStat('${user.followers}', 'Abonnés'),
                  const _PDivider(),
                  _pStat('56', 'Abonnements'),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onPublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumGreen,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('✍️  Nouvelle publication', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Sub tabs
        Row(
          children: [
            _tabBtn('📝 Mes posts', 0),
            const SizedBox(width: 6),
            _tabBtn('🔖 Sauvegardés', 1),
            const SizedBox(width: 6),
            _tabBtn('⚙️ Paramètres', 2),
          ],
        ),
        const SizedBox(height: 14),
        // Tab content
        if (_tab == 0) _myPosts(),
        if (_tab == 1) _savedPosts(),
        if (_tab == 2) _settings(),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _tabBtn(String label, int idx) {
    final active = _tab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: active ? const LinearGradient(colors: [AppColors.mediumGreen, AppColors.lightGreen]) : null,
            color: active ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: active ? Colors.transparent : AppColors.borderGreen, width: 2),
          ),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.softGreen)),
        ),
      ),
    );
  }

  Widget _myPosts() {
    final myPosts = widget.state.myPosts;
    if (myPosts.isEmpty) return _emptyState('🌱', 'Aucune publication encore', 'Partagez votre premier conseil !', widget.onPublish);
    return Column(children: myPosts.map((post) => PostCard(
      post: post,
      isLiked: widget.state.likedPosts.contains(post.id),
      showDelete: true,
      onLike: () => widget.state.toggleLike(post.id),
      onSave: () => widget.state.toggleSave(post.id),
      onDelete: () { widget.state.deletePost(post.id); setState(() {}); },
    )).toList());
  }

  Widget _savedPosts() {
    final saved = widget.state.savedPosts;
    if (saved.isEmpty) return _emptyState('🔖', 'Aucun article sauvegardé', 'Sauvegardez des articles depuis le fil', null);
    return Column(children: saved.map((post) => PostCard(
      post: post,
      isLiked: widget.state.likedPosts.contains(post.id),
      onLike: () => widget.state.toggleLike(post.id),
      onSave: () => widget.state.toggleSave(post.id),
    )).toList());
  }

  Widget _settings() {
    final items = [
      {'icon': '⚙️', 'label': 'Paramètres du compte'},
      {'icon': '🌍', 'label': 'Ma région agricole'},
      {'icon': '📞', 'label': 'Support AgriLink'},
    ];
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
          child: Column(
            children: [
              ...items.map((item) => _menuItem(item['icon']!, item['label']!, AppColors.darkGreen, () {})),
              _menuItem('🚪', 'Se déconnecter', const Color(0xFFc0392b), widget.onLogout, bold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuItem(String icon, String label, Color color, VoidCallback onTap, {bool bold = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardGreen))),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: color, fontWeight: bold ? FontWeight.w700 : FontWeight.normal))),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String emoji, String title, String sub, VoidCallback? onAction) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
          const SizedBox(height: 6),
          Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.softGreen)),
          if (onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.mediumGreen, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('✍️  Créer une publication', style: TextStyle(color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _pStat(String val, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.darkGreen)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.softGreen)),
        ],
      ),
    );
  }
}

class _PDivider extends StatelessWidget {
  const _PDivider();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 40, color: AppColors.borderGreen);
}