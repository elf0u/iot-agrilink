import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';

const _categories = ['Irrigation', 'Maladies', 'Semences', 'Marché', 'Matériel'];
const _tags = {'Irrigation': '🌊', 'Maladies': '🌿', 'Semences': '🌱', 'Marché': '📈', 'Matériel': '🚜'};

class PublishSheet extends StatefulWidget {
  final AppState state;
  const PublishSheet({super.key, required this.state});

  @override
  State<PublishSheet> createState() => _PublishSheetState();
}

class _PublishSheetState extends State<PublishSheet> {
  final titleCtrl = TextEditingController();
  final bodyCtrl = TextEditingController();
  String selectedCat = 'Irrigation';
  bool success = false;

  void handlePublish() async {
    if (titleCtrl.text.trim().isEmpty || bodyCtrl.text.trim().isEmpty) return;
    widget.state.addPost(titleCtrl.text.trim(), bodyCtrl.text.trim(), selectedCat);
    setState(() => success = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 32),
      child: success ? _successView() : _formView(),
    );
  }

  Widget _successView() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 40),
        Text('🎉', style: TextStyle(fontSize: 52)),
        SizedBox(height: 12),
        Text('Publication partagée !', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.mediumGreen)),
        SizedBox(height: 6),
        Text('Votre publication est visible par la communauté', style: TextStyle(fontSize: 13, color: AppColors.softGreen)),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _formView() {
    final user = widget.state.currentUser!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 16),
        // Title bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('✍️  Nouvelle publication', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.darkGreen)),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: AppColors.cardGreen, borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Text('✕', style: TextStyle(fontSize: 14, color: AppColors.softGreen))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        // Author row
        Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.lightGreen, AppColors.mediumGreen]), borderRadius: BorderRadius.circular(22)),
              child: Center(child: Text(user.avatar, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
                Text(user.region, style: const TextStyle(fontSize: 12, color: AppColors.softGreen)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Category
        const Text('📌  Catégorie', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lightGreen)),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final active = cat == selectedCat;
              return GestureDetector(
                onTap: () => setState(() => selectedCat = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: active ? const LinearGradient(colors: [AppColors.mediumGreen, AppColors.lightGreen]) : null,
                    color: active ? null : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: active ? Colors.transparent : AppColors.borderGreen, width: 2),
                  ),
                  child: Text('${_tags[cat]} $cat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.softGreen)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        // Title field
        const Text('📝  Titre', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lightGreen)),
        const SizedBox(height: 6),
        TextField(
          controller: titleCtrl,
          maxLength: 80,
          decoration: _inputDeco('Ex: Ma technique pour les tomates...'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 10),
        // Body field
        const Text('💬  Contenu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lightGreen)),
        const SizedBox(height: 6),
        TextField(
          controller: bodyCtrl,
          maxLines: 4,
          maxLength: 500,
          decoration: _inputDeco('Partagez votre expérience, technique ou conseil agricole...'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (titleCtrl.text.trim().isNotEmpty && bodyCtrl.text.trim().isNotEmpty) ? handlePublish : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mediumGreen,
              disabledBackgroundColor: AppColors.softGreen.withOpacity(0.4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text('🌱  Partager avec la communauté', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFaaaaaa), fontSize: 13),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderGreen, width: 2)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderGreen, width: 2)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightGreen, width: 2)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
  );
}