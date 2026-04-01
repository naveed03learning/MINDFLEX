import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/storage_service.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username = StorageService.getUsername() ?? 'Operative';
    final xp = StorageService.getXP();
    final level = StorageService.getLevel();
    final bestStreak = StorageService.getBestStreak();
    final interests = StorageService.getInterests();
    final joinDateRaw = StorageService.getJoinDate();
    String joinDate = 'Today';
    if (joinDateRaw != null) {
      final dt = DateTime.tryParse(joinDateRaw);
      if (dt != null) {
        joinDate =
            '${dt.day} ${_monthName(dt.month)} ${dt.year}';
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const AmbientGlow(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      children: [
                        // Top bar
                        Row(
                          children: [
                            Text(
                              'MINDFLEX',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3,
                              ),
                            ),
                            const Spacer(),
                            // Logout
                            GestureDetector(
                              onTap: () => _confirmLogout(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.logout_rounded,
                                        color: AppColors.onSurfaceVariant,
                                        size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Logout',
                                      style: GoogleFonts.manrope(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        // Avatar
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryDim
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 40,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surfaceContainerHighest,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: AppColors.primary,
                                      size: 60,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Username
                        Text(
                          username,
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.onSurface,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NEURAL RANK: LEVEL $level',
                          style: GoogleFonts.manrope(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Interest tags
                        if (interests.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: interests.map((t) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.25),
                                  ),
                                ),
                                child: Text(
                                  t.toUpperCase(),
                                  style: GoogleFonts.manrope(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 32),

                        // Stats grid
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: _ProfileStat(
                                    label: 'Total XP',
                                    value: '$xp XP',
                                    icon: Icons.bolt_rounded,
                                    iconColor: AppColors.primary),
                              ),
                              Container(
                                width: 1,
                                height: 56,
                                color: AppColors.outlineVariant.withOpacity(0.3),
                              ),
                              Expanded(
                                child: _ProfileStat(
                                    label: 'Best Streak',
                                    value: '🔥 $bestStreak',
                                    icon: null),
                              ),
                              Container(
                                width: 1,
                                height: 56,
                                color: AppColors.outlineVariant.withOpacity(0.3),
                              ),
                              Expanded(
                                child: _ProfileStat(
                                    label: 'Member Since',
                                    value: joinDate,
                                    icon: Icons.calendar_today_rounded,
                                    iconColor: AppColors.onSurfaceVariant,
                                    smallValue: true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Cognitive data section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'STORED COGNITIVE DATA',
                                style: GoogleFonts.manrope(
                                  color: AppColors.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  'ENCRYPTED',
                                  style: GoogleFonts.manrope(
                                    color: AppColors.primary,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _DataRow(
                          icon: Icons.map_outlined,
                          label: 'Personalized Neural Map',
                        ),
                        const SizedBox(height: 10),
                        _DataRow(
                          icon: Icons.history_edu_outlined,
                          label: 'Historical Training Data',
                        ),
                        const SizedBox(height: 10),
                        _DataRow(
                          icon: Icons.link_rounded,
                          label: 'Linked Neural Accounts',
                        ),
                        const SizedBox(height: 32),

                        // Settings section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'SETTINGS',
                            style: GoogleFonts.manrope(
                              color: AppColors.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _DataRow(
                          icon: Icons.notifications_outlined,
                          label: 'Notifications',
                        ),
                        const SizedBox(height: 10),
                        _DataRow(
                          icon: Icons.shield_outlined,
                          label: 'Privacy & Security',
                        ),
                        const SizedBox(height: 10),
                        _DataRow(
                          icon: Icons.help_outline_rounded,
                          label: 'Help & Support',
                        ),
                        const SizedBox(height: 40),

                        // Version tag
                        Text(
                          'MINDFLEX v1.0  ·  NEURAL LINK PROTOCOL v2.4',
                          style: GoogleFonts.manrope(
                            color: AppColors.outline.withOpacity(0.5),
                            fontSize: 9,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'End Session?',
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Your progress is saved. You can return to train anytime.',
          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.prefs.remove('mf_user');
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: Text('Logout',
                style: GoogleFonts.manrope(
                    color: AppColors.primaryDim,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[month];
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final bool smallValue;

  const _ProfileStat({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.smallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.onSurface,
            fontSize: smallValue ? 12 : 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            color: AppColors.onSurfaceVariant,
            fontSize: 9,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DataRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainer,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                color: AppColors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.onSurfaceVariant, size: 20),
        ],
      ),
    );
  }
}
