import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/storage_service.dart';
import '../widgets/common_widgets.dart';
import 'quiz_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _HomeTab(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          border: Border(
            top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.2)),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  selected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Progress',
                  selected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  selected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 22,
            ),
            if (selected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  @override
  Widget build(BuildContext context) {
    final username = StorageService.getUsername() ?? 'Operative';
    final xp = StorageService.getXP();
    final level = StorageService.getLevel();
    final quizzesTaken = StorageService.getQuizzesTaken();
    final xpToNext = (level * 100) - xp;
    final xpProgress = (xp % 100) / 100.0;
    final interests = StorageService.getInterests();
    final accuracy = StorageService.getAccuracy();

    return Stack(
      children: [
        const AmbientGlow(),
        SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good ${_timeGreeting()},',
                                style: GoogleFonts.manrope(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                username,
                                style: GoogleFonts.spaceGrotesk(
                                  color: AppColors.onSurface,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          XPChip(xp: xp),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Level card
                      GlassCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'NEURAL RANK',
                                      style: GoogleFonts.manrope(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 10,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Level $level',
                                      style: GoogleFonts.spaceGrotesk(
                                        color: AppColors.primary,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primaryDim
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryDim
                                            .withOpacity(0.4),
                                        blurRadius: 16,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.psychology_rounded,
                                    color: AppColors.onPrimaryFixed,
                                    size: 26,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$xp XP',
                                  style: GoogleFonts.manrope(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '$xpToNext XP to Level ${level + 1}',
                                  style: GoogleFonts.manrope(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: LinearProgressIndicator(
                                value: xpProgress,
                                backgroundColor:
                                    AppColors.outlineVariant.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation(
                                    AppColors.primaryDim),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats row
                      Row(
                        children: [
                          Expanded(
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('🔥',
                                      style: TextStyle(fontSize: 22)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'STREAK',
                                    style: GoogleFonts.manrope(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 9,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${StorageService.getBestStreak()}',
                                    style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.onSurface,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.quiz_rounded,
                                      color: AppColors.secondary, size: 22),
                                  const SizedBox(height: 8),
                                  Text(
                                    'QUIZZES',
                                    style: GoogleFonts.manrope(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 9,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$quizzesTaken',
                                    style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.onSurface,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.track_changes_rounded,
                                      color: AppColors.tertiary, size: 22),
                                  const SizedBox(height: 8),
                                  Text(
                                    'ACCURACY',
                                    style: GoogleFonts.manrope(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 9,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${accuracy.round()}%',
                                    style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.onSurface,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Start Training button
                      Text(
                        'TODAY\'S MISSION',
                        style: GoogleFonts.manrope(
                          color: AppColors.primary,
                          fontSize: 10,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      NeuralButton(
                        label: '⚡  Start Training',
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      const QuizScreen(),
                                  transitionsBuilder: (_, anim, __, child) =>
                                      SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                        parent: anim,
                                        curve: Curves.easeOutCubic)),
                                    child: child,
                                  ),
                                ),
                              )
                              .then((_) => setState(() {}));
                        },
                      ),
                      const SizedBox(height: 24),

                      // Topics
                      Text(
                        'YOUR DOMAINS',
                        style: GoogleFonts.manrope(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.35,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final topic = interests[i];
                      final topicIcons = {
                        'Riddles': '🧩',
                        'Memory': '🧠',
                        'Logic': '🔗',
                        'Lateral Thinking': '💡',
                      };
                      final topicScores = StorageService.getTopicScores();
                      final score = topicScores[topic];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      QuizScreen(forcedTopic: topic),
                                  transitionsBuilder: (_, anim, __, child) =>
                                      SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                        parent: anim,
                                        curve: Curves.easeOutCubic)),
                                    child: child,
                                  ),
                                ),
                              )
                              .then((_) => setState(() {}));
                        },
                        child: GlassCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(topicIcons[topic] ?? '🧩',
                                  style: const TextStyle(fontSize: 28)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic,
                                    style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.onSurface,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (score != null)
                                    Text(
                                      'Best: $score%',
                                      style: GoogleFonts.manrope(
                                        color: AppColors.primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: interests.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _timeGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Morning';
    if (h < 17) return 'Afternoon';
    return 'Evening';
  }
}
