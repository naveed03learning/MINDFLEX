import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme.dart';
import '../widgets/common_widgets.dart';
import 'interests_screen.dart';
import 'signup_screen.dart';
import '../data/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;

  void _authenticate() async {
    if (_isLoading) return;

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your email and password.',
            style: GoogleFonts.manrope(color: Colors.white),
          ),
          backgroundColor: AppColors.errorDim,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final supabase = Supabase.instance.client;

    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;

      if (user != null) {
        // 🔥 Fetch user data (optional, for future use)
        final data =
            await supabase.from('users').select().eq('id', user.id).single();

        await StorageService.setUsername(data['username']);

        print("USER DATA 👉 $data");

        await StorageService.syncFromSupabase();

        if (!mounted) return;

        // ✅ Navigate ONLY after success
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const InterestsScreen()),
        );
      }
    } catch (e) {
      print("LOGIN ERROR 👉 $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid email or password',
            style: GoogleFonts.manrope(color: Colors.white),
          ),
          backgroundColor: AppColors.errorDim,
        ),
      );
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1E),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.08),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primaryDim.withOpacity(0.05),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  Text(
                    'MINDFLEX',
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.onSurface,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'THE HIGH-PERFORMANCE SANCTUARY',
                    style: GoogleFonts.manrope(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 56),
                  _buildLabel('IDENTIFICATION'),
                  const SizedBox(height: 8),
                  _GlassInput(
                    controller: _emailCtrl,
                    hint: 'Email',
                    prefixIcon: Icons.email_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('SECURITY KEY'),
                  const SizedBox(height: 8),
                  _GlassInput(
                    controller: _passwordCtrl,
                    hint: 'Password',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscure: !_showPassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _authenticate(),
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _showPassword = !_showPassword),
                      child: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.outline,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.primary)
                      : NeuralButton(
                          label: 'Authenticate',
                          onTap: _authenticate,
                        ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _LinkText('Forgot Password?'),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.outlineVariant,
                        ),
                      ),
                      _LinkText('Sign Up', onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const SignupScreen(),
                            transitionsBuilder: (_, anim, __, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration:
                                const Duration(milliseconds: 400),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 64),
                  Opacity(
                    opacity: 0.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _BioButton(icon: Icons.fingerprint_rounded),
                        const SizedBox(width: 24),
                        _BioButton(icon: Icons.face_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'NEURAL LINK PROTOCOL v2.4',
                    style: GoogleFonts.manrope(
                      color: AppColors.outline.withOpacity(0.6),
                      fontSize: 9,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            color: AppColors.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _GlassInput({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscure = false,
    this.suffixIcon,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(prefixIcon, color: AppColors.outline, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              style: GoogleFonts.manrope(
                color: AppColors.onSurface,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.manrope(
                  color: AppColors.outline,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon!,
        ],
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const _LinkText(this.text, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.manrope(
          color: AppColors.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _BioButton extends StatelessWidget {
  final IconData icon;
  const _BioButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceContainerHighest.withOpacity(0.4),
      ),
      child: Icon(icon, color: AppColors.onSurface, size: 22),
    );
  }
}
