import 'package:flutter/material.dart';
import '../models/user.dart';
import '../theme.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        const Text('Membres actifs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
        const SizedBox(height: 12),
        ...usersDB.map((u) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: AppColors.cardGreen, borderRadius: BorderRadius.circular(26)),
                child: Center(child: Text(u.avatar, style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
                    const SizedBox(height: 3),
                    Text('📍 ${u.region} · ${u.specialty}', style: const TextStyle(fontSize: 12, color: AppColors.softGreen)),
                    const SizedBox(height: 3),
                    Text('📝 ${u.posts} posts · 👥 ${u.followers} abonnés', style: const TextStyle(fontSize: 11, color: Color(0xFFaac4a0))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.mediumGreen, AppColors.lightGreen]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Suivre', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        )),
        const SizedBox(height: 8),
        // Banner
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.mediumGreen, AppColors.lightGreen]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            children: [
              Text('🌍', style: TextStyle(fontSize: 32)),
              SizedBox(height: 8),
              Text('Rejoignez la communauté', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
              SizedBox(height: 6),
              Text('+1,200 agriculteurs partagent leurs savoirs sur AgriLink', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xBBFFFFFF))),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}