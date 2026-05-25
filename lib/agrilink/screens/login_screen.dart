import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../../auth_service.dart';
import 'signup_agri_page.dart';

class LoginScreen extends StatefulWidget {
  final AppState state;
  const LoginScreen({super.key, required this.state});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;
  String? error;
  bool obscure = true;

  Future<void> handleLogin() async {
    if (emailCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) {
      setState(() => error = "Veuillez remplir tous les champs.");
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    final result = await AuthService.signin(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
      appType: "agrilink",
    );

    if (!mounted) return;

    setState(() => loading = false);

    if (result["success"] == true) {
      widget.state.loginFromDb(result["user"]);
      Navigator.pop(context);
    } else {
      setState(() {
        error = result["message"]?.toString() ?? "Email ou mot de passe incorrect.";
      });
    }
  }

  void goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignupAgriPage(state: widget.state),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a3d17),
              Color(0xFF2d5a27),
              Color(0xFF4a7c3f),
              Color(0xFF6aaf55),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 48),
                const Text('🌱', style: TextStyle(fontSize: 60)),
                const SizedBox(height: 8),
                Text(
                  'AgriLink',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        fontSize: 38,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'La communauté des agriculteurs tunisiens',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 36),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Connexion AgriLink',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _label('📧  Email'),
                      const SizedBox(height: 6),
                      _field(emailCtrl, 'votre@email.com', TextInputType.emailAddress),
                      const SizedBox(height: 14),
                      _label('🔒  Mot de passe'),
                      const SizedBox(height: 6),
                      _passwordField(),
                      if (error != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEAEA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            error!,
                            style: const TextStyle(
                              color: Color(0xFFc0392b),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mediumGreen,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Se connecter  →',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: loading ? null : goToSignup,
                          child: const Text(
                            "Créer un compte AgriLink",
                            style: TextStyle(
                              color: AppColors.mediumGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: ['🌾 Céréales', '🫒 Oliviers', '🥬 Légumes', '🍋 Agrumes']
                      .map(
                        (b) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Text(
                            b,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.darkGreen,
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint,
    TextInputType type,
  ) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8FAF6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGreen, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGreen, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mediumGreen, width: 2),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: passCtrl,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: 'Mot de passe',
        filled: true,
        fillColor: const Color(0xFFF8FAF6),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => obscure = !obscure),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGreen, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mediumGreen, width: 2),
        ),
      ),
      onSubmitted: (_) => handleLogin(),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}