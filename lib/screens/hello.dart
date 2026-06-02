import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // ✅ KEEP LOGIC
import '../theme.dart';
import '../data/storage_service.dart';
import '../widgets/common_widgets.dart';
import 'interests_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  final supabase = Supabase.instance.client;

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  void _signup() async {
    if (_isLoading) return;

    final email = _emailCtrl.text.trim();
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final confirmPassword = _confirmPasswordCtrl.text.trim();

    // ───── VALIDATION (UNCHANGED LOGIC) ─────
    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showError('Please enter a valid email address.');
      return;
    }

    if (username.length < 3) {
      _showError('Username must be at least 3 characters.');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ───── SUPABASE AUTH (LOGIC KEPT SAME) ─────
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = res.user ?? supabase.auth.currentUser;

      if (user != null) {
        await supabase.from('users').upsert({
          'id': user.id,
          'email': email,
          'username': username,
          'xp': 0,
          'level': 1,
          'correct_total': 0,
          'questions_total': 0,
          'quizzes_taken': 0,
          'best_streak': 0,
          'daily_streak': 0,
          'last_active': DateTime.now().toIso8601String(),
        });

        _showSuccess('Account created successfully');

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const InterestsScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }

    setState(() => _isLoading = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.manrope(color: Colors.white)),
        backgroundColor: AppColors.errorDim,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.manrope(color: Colors.white)),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1E),
      body: Stack(
        children: [
          // Ambient glows
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
                  const SizedBox(height: 32),

                  // Title
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
                    'CREATE YOUR ACCOUNT',
                    style: GoogleFonts.manrope(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email field
                  _buildLabel('EMAIL'),
                  const SizedBox(height: 8),
                  _GlassInput(
                    controller: _emailCtrl,
                    hint: 'Email',
                    prefixIcon: Icons.email_outlined,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Username field
                  _buildLabel('USERNAME'),
                  const SizedBox(height: 8),
                  _GlassInput(
                    controller: _usernameCtrl,
                    hint: 'Username',
                    prefixIcon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  _buildLabel('PASSWORD'),
                  const SizedBox(height: 8),
                  _GlassInput(
                    controller: _passwordCtrl,
                    hint: 'Password',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscure: !_showPassword,
                    textInputAction: TextInputAction.next,
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
                  const SizedBox(height: 20),

                  // Confirm Password field
                  _buildLabel('CONFIRM PASSWORD'),
                  const SizedBox(height: 8),
                  _GlassInput(
                    controller: _confirmPasswordCtrl,
                    hint: 'Confirm Password',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscure: !_showConfirmPassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _signup(),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                          () => _showConfirmPassword = !_showConfirmPassword),
                      child: Icon(
                        _showConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.outline,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Sign Up button
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.primary)
                      : NeuralButton(
                          label: 'Create Account',
                          onTap: _signup,
                        ),
                  const SizedBox(height: 24),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.manrope(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      _LinkText('Login', onTap: () {
                        Navigator.of(context).pop();
                      }),
                    ],
                  ),
                  const SizedBox(height: 64),

                  // Version text
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
  final TextInputType? keyboardType;

  const _GlassInput({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscure = false,
    this.suffixIcon,
    this.textInputAction,
    this.onSubmitted,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        keyboardType: keyboardType,
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
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.outline,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
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
      onTap: onTap ?? () => Navigator.of(context).pop(),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primary,
        ),
      ),
    );
  }
}//claude