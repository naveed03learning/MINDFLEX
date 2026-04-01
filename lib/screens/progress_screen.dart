import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/storage_service.dart';
import '../widgets/common_widgets.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final xp = StorageService.getXP();
    final level = StorageService.getLevel();
    final xpInLevel = xp % 100;
    final quizzesTaken = StorageService.getQuizzesTaken();
    final correctTotal = StorageService.getCorrectTotal();
    final questionsTotal = StorageService.getQuestionsTotal();
    final bestStreak = StorageService.getBestStreak();
    final topicScores = StorageService.getTopicScores();
    final weeklyActivity = StorageService.getWeeklyActivity();
    final accuracy = StorageService.getAccuracy();

    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxActivity = weeklyActivity.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient glows
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.05),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
                                  'NEURAL ANALYTICS',
                                  style: GoogleFonts.manrope(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your Progress',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.onSurface,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            XPChip(xp: xp),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Level XP bar
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Text(
                                    'Level $level',
                                    style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: LinearProgressIndicator(
                                  value: xpInLevel / 100.0,
                                  backgroundColor:
                                      AppColors.outlineVariant.withOpacity(0.3),
                                  valueColor: const AlwaysStoppedAnimation(
                                      AppColors.primaryDim),
                                  minHeight: 8,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$xpInLevel / 100 XP',
                                    style: GoogleFonts.manrope(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    '${100 - xpInLevel} XP to Level ${level + 1}',
                                    style: GoogleFonts.manrope(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Stats grid
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.55,
                          children: [
                            _StatCard(
                              icon: '🔥',
                              label: 'BEST STREAK',
                              value: '$bestStreak',
                            ),
                            _StatCard(
                              icon: '🎯',
                              label: 'ACCURACY',
                              value: '${accuracy.round()}%',
                              iconWidget: const Icon(
                                  Icons.track_changes_rounded,
                                  color: AppColors.tertiary,
                                  size: 24),
                            ),
                            _StatCard(
                              label: 'QUIZZES DONE',
                              value: '$quizzesTaken',
                              iconWidget: const Icon(Icons.quiz_rounded,
                                  color: AppColors.secondary, size: 24),
                            ),
                            _StatCard(
                              label: 'CORRECT',
                              value: '$correctTotal/$questionsTotal',
                              iconWidget: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: AppColors.correct,
                                  size: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Weekly activity
                        Text(
                          'WEEKLY ACTIVITY',
                          style: GoogleFonts.manrope(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                            letterSpacing: 2.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(7, (i) {
                              final val = weeklyActivity[i];
                              final ratio = maxActivity > 0
                                  ? val / maxActivity
                                  : 0.0;
                              Color dotColor;
                              if (val == 0) {
                                dotColor = AppColors.outlineVariant.withOpacity(0.3);
                              } else if (ratio < 0.5) {
                                dotColor = AppColors.primary.withOpacity(0.4);
                              } else {
                                dotColor = AppColors.primary;
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (val > 0)
                                    Text(
                                      '$val',
                                      style: GoogleFonts.manrope(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 600),
                                    width: 28,
                                    height: maxActivity > 0
                                        ? 8.0 + 48.0 * ratio
                                        : 8,
                                    decoration: BoxDecoration(
                                      color: dotColor,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: val > 0
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withOpacity(0.4),
                                                blurRadius: 6,
                                              )
                                            ]
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    dayLabels[i],
                                    style: GoogleFonts.manrope(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Topic performance
                        if (topicScores.isNotEmpty) ...[
                          Text(
                            'TOPIC PERFORMANCE',
                            style: GoogleFonts.manrope(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 10,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GlassCard(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                'Riddles', 'Memory', 'Logic', 'Lateral Thinking'
                              ].where((t) => topicScores[t] != null).map((t) {
                                final score = (topicScores[t] as num).toDouble();
                                final icons = {
                                  'Riddles': '🧩',
                                  'Memory': '🧠',
                                  'Logic': '🔗',
                                  'Lateral Thinking': '💡',
                                };
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(icons[t] ?? '🧩',
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                              const SizedBox(width: 8),
                                              Text(
                                                t,
                                                style: GoogleFonts.manrope(
                                                  color: AppColors.onSurface,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${score.round()}%',
                                            style: GoogleFonts.spaceGrotesk(
                                              color: AppColors.primary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: LinearProgressIndicator(
                                          value: score / 100,
                                          backgroundColor: AppColors
                                              .outlineVariant
                                              .withOpacity(0.3),
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                  AppColors.primaryDim),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Achievements
                        Text(
                          'ACHIEVEMENTS',
                          style: GoogleFonts.manrope(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                            letterSpacing: 2.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                          children: [
                            _BadgeCard(
                              icon: '🎯',
                              label: 'First Quiz',
                              earned: quizzesTaken >= 1,
                            ),
                            _BadgeCard(
                              icon: '🔥',
                              label: '3x Streak',
                              earned: bestStreak >= 3,
                            ),
                            _BadgeCard(
                              icon: '🧠',
                              label: '100 XP',
                              earned: xp >= 100,
                            ),
                            _BadgeCard(
                              icon: '⚡',
                              label: '5 Quizzes',
                              earned: quizzesTaken >= 5,
                            ),
                            _BadgeCard(
                              icon: '🏆',
                              label: 'Perfect Score',
                              earned: topicScores.values
                                  .any((v) => (v as num) == 100),
                            ),
                            _BadgeCard(
                              icon: '💡',
                              label: 'Level 5',
                              earned: level >= 5,
                            ),
                          ],
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
}

class _StatCard extends StatelessWidget {
  final String? icon;
  final Widget? iconWidget;
  final String label;
  final String value;

  const _StatCard({
    this.icon,
    this.iconWidget,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon != null
              ? Text(icon!, style: const TextStyle(fontSize: 22))
              : iconWidget ?? const SizedBox(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 9,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final String icon;
  final String label;
  final bool earned;

  const _BadgeCard(
      {required this.icon, required this.label, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: earned ? 1.0 : 0.35,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: earned
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: earned
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.outlineVariant.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: earned ? AppColors.onSurface : AppColors.onSurfaceVariant,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
