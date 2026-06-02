import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/quiz_data.dart';
import '../data/storage_service.dart';
import '../widgets/common_widgets.dart';

class QuizScreen extends StatefulWidget {
  final String? forcedTopic;
  const QuizScreen({super.key, this.forcedTopic});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  bool _quizSaved = false; // ✅ ADD HERE

  // Data
  late String _topic;
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _bestStreak = 0;
  // State
  int _xp = 0;
  int _correctCount = 0;
  bool _answered = false;
  bool _hintUsed = false;
  bool _showHint = false;
  int? _selectedOption;
  bool _showResults = false;

  // Timer
  static const _timerMax = 20;
  int _timeLeft = _timerMax;
  Timer? _timer;

  // Animations
  late AnimationController _cardAnimCtrl;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
//ignore: unused_field
  static const _motivations = [
    "Keep the momentum going!",
    "Your neural pathways are firing!",
    "Excellent deduction.",
    "Mind like a razor.",
    "Flawless logic.",
    "You're in the zone.",
  ];

  @override
  void initState() {
    super.initState();
    _cardAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardAnimCtrl, curve: Curves.easeOut),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _cardAnimCtrl, curve: Curves.easeOutCubic),
    );
    _initTopic();
    _loadQuestion();
  }

  void _initTopic() {
    if (widget.forcedTopic != null) {
      _topic = widget.forcedTopic!;
    } else {
      final interests = StorageService.getInterests();
      final valid =
          interests.where((i) => QuizData.allQuestions.containsKey(i)).toList();
      if (valid.isNotEmpty) {
        valid.shuffle();
        _topic = valid.first;
      } else {
        final keys = QuizData.allQuestions.keys.toList()..shuffle();
        _topic = keys.first;
      }
    }
    _questions = QuizData.allQuestions[_topic]!;
  }

  void _loadQuestion() {
    _answered = false;
    _hintUsed = false;
    _showHint = false;
    _selectedOption = null;
    _startTimer();
    _cardAnimCtrl.forward(from: 0);
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timeLeft = _timerMax);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft <= 0) {
        t.cancel();
        _timeExpired();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _timeExpired() {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedOption = -1; // indicates timeout
    });
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    _timer?.cancel();
    final q = _questions[_currentIndex];
    final isCorrect = index == q.answerIndex;
    setState(() {
      _answered = true;
      _selectedOption = index;

      if (isCorrect) {
        _xp += 2;
        _correctCount++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex >= _questions.length - 1) {
      _finishQuiz();
    } else {
      setState(() {
        _currentIndex++;
      });
      _loadQuestion();
    }
  }

  void _finishQuiz() async {
    if (_quizSaved) return; // ✅ STOP DUPLICATE CALLS
    _quizSaved = true;

    _timer?.cancel();

    await StorageService.saveQuizResult(
      topic: _topic,
      earnedXP: _xp,
      correctCount: _correctCount,
      totalQuestions: _questions.length,
      sessionBestStreak: _bestStreak,
    );
    if (mounted) {
      setState(() {});
      _showResults = true;
    }

    if (mounted) setState(() => _showResults = true);
  }

  void _useHint() {
    if (_hintUsed || _answered) return;
    setState(() {
      _hintUsed = true;
      _showHint = true;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cardAnimCtrl.dispose();
    super.dispose();
  }

  // ─── Build ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_showResults) return _buildResultsScreen();
    return _buildQuizScreen();
  }

  Widget _buildQuizScreen() {
    final q = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;
    final timerColor = _timeLeft <= 5
        ? AppColors.error
        : _timeLeft <= 10
            ? AppColors.orange
            : AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const AmbientGlow(),
          SafeArea(
            child: Column(
              children: [
                // ── Header ──────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.onSurfaceVariant),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      // Daily streak (days with 20+ answers)
                      StreakChip(streak: StorageService.getDailyStreak()),
                      const SizedBox(width: 8),
                      XPChip(xp: _xp),
                      const SizedBox(width: 8),
                      Text(
                        'MINDFLEX',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Progress bar ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _TopicBadge(topic: _topic),
                          Text(
                            'Q ${_currentIndex + 1} / ${_questions.length}',
                            style: GoogleFonts.manrope(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 11,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.surfaceContainerHighest,
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.primaryDim),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Scrollable body ──────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FadeTransition(
                      opacity: _cardFade,
                      child: SlideTransition(
                        position: _cardSlide,
                        child: Column(
                          children: [
                            // Question card
                            GlassCard(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DifficultyBadge(
                                          difficulty: q.difficulty, xp: q.xp),
                                      _TimerRing(
                                        timeLeft: _timeLeft,
                                        max: _timerMax,
                                        color: timerColor,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    q.question,
                                    style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.onSurface,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      height: 1.35,
                                    ),
                                  ),
                                  if (_showHint) ...[
                                    const SizedBox(height: 14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.tertiary
                                            .withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.tertiary
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      child: Text(
                                        '💡 Hint: ${q.hint}',
                                        style: GoogleFonts.manrope(
                                          color: AppColors.tertiary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Options
                            ...List.generate(q.options.length, (i) {
                              return _OptionButton(
                                letter: ['A', 'B', 'C', 'D'][i],
                                text: q.options[i],
                                state: _getOptionState(i, q.answerIndex),
                                onTap: () => _selectAnswer(i),
                                disabled: _answered,
                              );
                            }),

                            // Hint button
                            if (!_hintUsed && !_answered) ...[
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _useHint,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.lightbulb_outline_rounded,
                                        color: AppColors.tertiary, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Use Hint',
                                      style: GoogleFonts.manrope(
                                        color:
                                            AppColors.tertiary.withOpacity(0.7),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(-5 XP)',
                                      style: GoogleFonts.manrope(
                                        color:
                                            AppColors.tertiary.withOpacity(0.4),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // Feedback banner
                            if (_answered) ...[
                              const SizedBox(height: 16),
                              _FeedbackBanner(
                                isCorrect: _selectedOption == q.answerIndex,
                                correctAnswer: q.options[q.answerIndex],
                                timedOut: _selectedOption == -1,
                              ),
                            ],
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _answered
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: NeuralButton(
                  label: _currentIndex == _questions.length - 1
                      ? 'See Results'
                      : 'Next Question',
                  trailing: Icon(
                    _currentIndex == _questions.length - 1
                        ? Icons.emoji_events_rounded
                        : Icons.arrow_forward_rounded,
                    color: AppColors.onPrimaryFixed,
                    size: 18,
                  ),
                  onTap: _nextQuestion,
                ),
              ),
            )
          : null,
    );
  }

  _OptionState _getOptionState(int index, int correct) {
    if (!_answered) return _OptionState.idle;
    if (index == correct) return _OptionState.correct;
    if (index == _selectedOption && index != correct) return _OptionState.wrong;
    return _OptionState.idle;
  }

  // ─── Results ─────────────────────────────────────────────

  Widget _buildResultsScreen() {
    final total = _questions.length;
    final accuracy = total > 0 ? (_correctCount / total * 100).round() : 0;
    final emoji = accuracy == 100
        ? '🏆'
        : accuracy >= 60
            ? '🧠'
            : '💪';
    final title = accuracy == 100
        ? 'Neural Mastery!'
        : accuracy >= 60
            ? 'Strong Mind!'
            : 'Keep Training!';
    final subtitle = accuracy == 100
        ? 'Perfect score — your brain is on fire.'
        : accuracy >= 60
            ? 'Great performance. Push for perfection.'
            : 'Every rep makes you sharper. Try again!';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const AmbientGlow(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Emoji
                  Text(emoji, style: const TextStyle(fontSize: 72)),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.onSurface,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Score card
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _ResultStat(
                                label: 'SCORE', value: '$_correctCount/$total'),
                            Container(
                              width: 1,
                              height: 48,
                              color: AppColors.outlineVariant.withOpacity(0.3),
                            ),
                            _ResultStat(label: 'ACCURACY', value: '$accuracy%'),
                            Container(
                              width: 1,
                              height: 48,
                              color: AppColors.outlineVariant.withOpacity(0.3),
                            ),
                            _ResultStat(
                                label: 'XP EARNED',
                                value: '+$_xp',
                                color: AppColors.primary),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _ResultStat(label: 'TOPIC', value: _topic),
                            Container(
                              width: 1,
                              height: 48,
                              color: AppColors.outlineVariant.withOpacity(0.3),
                            ),
                            _ResultStat(
                                label: 'BEST STREAK', value: '🔥 $_bestStreak'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Answer breakdown
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'BREAKDOWN',
                      style: GoogleFonts.manrope(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 10,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: LinearProgressIndicator(
                      value: total > 0 ? _correctCount / total : 0,
                      backgroundColor: AppColors.wrong.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.correct),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_correctCount Correct',
                        style: GoogleFonts.manrope(
                            color: AppColors.correct,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${total - _correctCount} Wrong',
                        style: GoogleFonts.manrope(
                            color: AppColors.wrong,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Buttons
                  NeuralButton(
                    label: '⚡  Train Again',
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              QuizScreen(forcedTopic: widget.forcedTopic),
                          transitionsBuilder: (_, anim, __, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'BACK TO HOME',
                      style: GoogleFonts.manrope(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub widgets ─────────────────────────────────────────────

enum _OptionState { idle, correct, wrong }

class _OptionButton extends StatelessWidget {
  final String letter;
  final String text;
  final _OptionState state;
  final VoidCallback onTap;
  final bool disabled;

  const _OptionButton({
    required this.letter,
    required this.text,
    required this.state,
    required this.onTap,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;
    Color letterBg;
    Color letterColor;

    switch (state) {
      case _OptionState.correct:
        borderColor = AppColors.correct.withOpacity(0.6);
        bgColor = AppColors.correct.withOpacity(0.1);
        letterBg = AppColors.correct.withOpacity(0.3);
        letterColor = AppColors.correct;
        break;
      case _OptionState.wrong:
        borderColor = AppColors.wrong.withOpacity(0.6);
        bgColor = AppColors.wrong.withOpacity(0.1);
        letterBg = AppColors.wrong.withOpacity(0.3);
        letterColor = AppColors.wrong;
        break;
      default:
        borderColor = AppColors.outlineVariant.withOpacity(0.3);
        bgColor = AppColors.surfaceContainerHighest.withOpacity(0.5);
        letterBg = AppColors.outlineVariant.withOpacity(0.3);
        letterColor = AppColors.onSurface;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: letterBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: GoogleFonts.spaceGrotesk(
                      color: letterColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.manrope(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerRing extends StatelessWidget {
  final int timeLeft;
  final int max;
  final Color color;

  const _TimerRing(
      {required this.timeLeft, required this.max, required this.color});

  @override
  Widget build(BuildContext context) {
    const size = 48.0;
    const r = 20.0;
    const circumference = 2 * 3.14159 * r;
    final offset = circumference * (1 - timeLeft / max);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(size, size),
            painter: _RingPainter(
              offset: offset,
              circumference: circumference,
              color: color,
            ),
          ),
          Text(
            '$timeLeft',
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double offset;
  final double circumference;
  final Color color;

  _RingPainter(
      {required this.offset, required this.circumference, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 20.0;

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFF48474B).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      (circumference - offset) / radius,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.offset != offset || old.color != color;
}

class _FeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final bool timedOut;

  const _FeedbackBanner({
    required this.isCorrect,
    required this.correctAnswer,
    required this.timedOut,
  });

  @override
  Widget build(BuildContext context) {
    final msgs = [
      "Keep the momentum going!",
      "Your neural pathways are firing!",
      "Excellent deduction.",
      "Mind like a razor.",
      "Flawless logic.",
      "You're in the zone.",
    ];
    msgs.shuffle();

    final title = timedOut
        ? "Time's Up!"
        : isCorrect
            ? '✓ Correct!'
            : '✗ Incorrect';
    final desc =
        timedOut || !isCorrect ? 'Correct answer: $correctAnswer' : msgs.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: (timedOut || !isCorrect)
            ? AppColors.wrong.withOpacity(0.1)
            : AppColors.correct.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (timedOut || !isCorrect)
              ? AppColors.wrong.withOpacity(0.3)
              : AppColors.correct.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            (timedOut || !isCorrect)
                ? Icons.cancel_rounded
                : Icons.check_circle_rounded,
            color:
                (timedOut || !isCorrect) ? AppColors.wrong : AppColors.correct,
            size: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    color: (timedOut || !isCorrect)
                        ? AppColors.wrong
                        : AppColors.correct,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.manrope(
                    color: (timedOut || !isCorrect)
                        ? AppColors.wrong.withOpacity(0.8)
                        : AppColors.correct.withOpacity(0.8),
                    fontSize: 12,
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

class _TopicBadge extends StatelessWidget {
  final String topic;
  const _TopicBadge({required this.topic});

  static const _icons = {
    'Riddles': '🧩',
    'Memory': '🧠',
    'Logic': '🔗',
    'Lateral Thinking': '💡',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_icons[topic] ?? '🧩', style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(
            topic.toUpperCase(),
            style: GoogleFonts.manrope(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _ResultStat({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            color: color ?? AppColors.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
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
    );
  }
}
