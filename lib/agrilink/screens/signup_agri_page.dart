import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../../auth_service.dart';

class SignupAgriPage extends StatefulWidget {
  final AppState state;
  const SignupAgriPage({super.key, required this.state});

  @override
  State<SignupAgriPage> createState() => _SignupAgriPageState();
}

class _SignupAgriPageState extends State<SignupAgriPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;
  String? error;

  Future<void> handleSignup() async {
    if (nameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        passCtrl.text.trim().isEmpty) {
      setState(() => error = "Veuillez remplir tous les champs.");
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    final result = await AuthService.signup(
      fullname: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
      appType: "agrilink",
    );

    if (!mounted) return;

    setState(() => loading = false);

    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte AgriLink créé avec succès")),
      );
      Navigator.pop(context);
    } else {
      setState(() {
        error = result["message"]?.toString() ?? "Erreur création compte.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F0),
      appBar: AppBar(
        title: const Text("Créer compte AgriLink"),
        backgroundColor: AppColors.mediumGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text('🌱', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              const Text(
                "Rejoindre AgriLink",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: nameCtrl,
                decoration: _input("Nom complet", Icons.person),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _input("Email", Icons.email),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: _input("Mot de passe", Icons.lock),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumGreen,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Créer le compte",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.lightGreen),
      filled: true,
      fillColor: const Color(0xFFF8FAF6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.mediumGreen, width: 2),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}