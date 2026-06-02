import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) throw Exception('StorageService not initialized');
    return _prefs!;
  }

  // ───── USER ─────
  static String? getUsername() => prefs.getString('mf_user');
  static Future<void> setUsername(String name) =>
      prefs.setString('mf_user', name);

  static String? getEmail() => prefs.getString('mf_email');
  static Future<void> setEmail(String email) =>
      prefs.setString('mf_email', email);

  static List<String> getInterests() =>
      List<String>.from(jsonDecode(prefs.getString('mf_interests') ?? '[]'));

  static Future<void> setInterests(List<String> interests) =>
      prefs.setString('mf_interests', jsonEncode(interests));

  // ───── XP ─────
  static int getXP() => prefs.getInt('mf_xp') ?? 0;

  static Future<void> addXP(int amount) async {
    int newXp = getXP() + amount;
    await prefs.setInt('mf_xp', newXp);
  }

  static int getLevel() => ((getXP()) ~/ 100) + 1;

  // ───── STREAK ─────
  static int getBestStreak() => prefs.getInt('mf_best_streak') ?? 0;

  static Future<void> setBestStreak(int streak) =>
      prefs.setInt('mf_best_streak', streak);

  // ───── QUIZ STATS ─────
  static int getQuizzesTaken() => prefs.getInt('mf_quizzes_taken') ?? 0;

  static Future<void> incrementQuizzesTaken() =>
      prefs.setInt('mf_quizzes_taken', getQuizzesTaken() + 1);

  static int getCorrectTotal() => prefs.getInt('mf_correct_total') ?? 0;

  static Future<void> addCorrect(int count) =>
      prefs.setInt('mf_correct_total', getCorrectTotal() + count);

  static int getQuestionsTotal() => prefs.getInt('mf_questions_total') ?? 0;

  static Future<void> addQuestions(int count) =>
      prefs.setInt('mf_questions_total', getQuestionsTotal() + count);

  // ───── TOPIC ─────
  static Map<String, dynamic> getTopicScores() => Map<String, dynamic>.from(
      jsonDecode(prefs.getString('mf_topic_scores') ?? '{}'));

  static Future<void> setTopicScores(Map<String, dynamic> scores) =>
      prefs.setString('mf_topic_scores', jsonEncode(scores));

  // ───── WEEKLY ACTIVITY ─────

  static List<int> getWeeklyActivity() => List<int>.from(
        jsonDecode(
          prefs.getString('mf_weekly_activity') ?? '[0,0,0,0,0,0,0]',
        ),
      );

  static String? getLastActivityWeek() =>
      prefs.getString('mf_last_activity_week');

  static int getDayOfYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays + 1;
  }

  static Future<void> checkAndResetWeeklyActivity() async {
    final now = DateTime.now();

    final currentWeek =
        '${now.year}-${((getDayOfYear(now) - now.weekday + 10) ~/ 7)}';

    final savedWeek = getLastActivityWeek();

    // NEW WEEK STARTED
    if (savedWeek != currentWeek) {
      await prefs.setString(
        'mf_weekly_activity',
        jsonEncode([0, 0, 0, 0, 0, 0, 0]),
      );

      await prefs.setString(
        'mf_last_activity_week',
        currentWeek,
      );
    }
  }

  static Future<void> recordActivity() async {
    await checkAndResetWeeklyActivity();

    final activity = getWeeklyActivity();

    final dayIndex = DateTime.now().weekday - 1;

    activity[dayIndex]++;

    await prefs.setString(
      'mf_weekly_activity',
      jsonEncode(activity),
    );
  }

// ───── DAILY STREAK ─────

  static int getDailyAnswers() => prefs.getInt('mf_daily_answers') ?? 0;

  static String? getLastAnswerDate() => prefs.getString('mf_last_answer_date');

  static int getDailyStreak() => prefs.getInt('mf_daily_streak') ?? 0;

  static Future<void> checkAndResetStreak() async {
    final lastDate = getLastAnswerDate();

    if (lastDate == null) return;

    final last = DateTime.parse(lastDate);
    final now = DateTime.now();

    final difference = now.difference(last).inDays;

    // missed more than 1 day
    if (difference > 1) {
      // LOCAL RESET
      await prefs.setInt('mf_daily_streak', 0);
      await prefs.setBool('mf_streak_given_today', false);
      await prefs.setInt('mf_daily_answers', 0);

      // SUPABASE RESET
      try {
        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;

        if (user != null) {
          await supabase.from('users').update({
            'daily_streak': 0,
          }).eq('id', user.id);
        }
      } catch (e) {
        print("Streak reset sync error: $e");
      }
    }
  }

  static const int streakThreshold = 10;

  static Future<void> recordDailyAnswer(int questionsAnswered) async {
    if (questionsAnswered <= 0) return;

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = getLastAnswerDate();

    bool alreadyGiven = prefs.getBool('mf_streak_given_today') ?? false;

    int current = getDailyAnswers();

    // NEW DAY RESET
    if (lastDate != today) {
      current = 0;
      alreadyGiven = false;
      await prefs.setBool('mf_streak_given_today', false);
    }

    // UPDATE TOTAL ATTEMPTS
    current += questionsAnswered;

    await prefs.setInt('mf_daily_answers', current);
    await prefs.setString('mf_last_answer_date', today);

    // GIVE STREAK ONLY ONCE PER DAY
    if (!alreadyGiven && current >= streakThreshold) {
      int newStreak = getDailyStreak() + 1;
      await prefs.setInt('mf_daily_streak', newStreak);
      await prefs.setBool('mf_streak_given_today', true);

      // optional: track best streak
      int best = getBestStreak();
      if (newStreak > best) {
        await setBestStreak(newStreak);
      }
    }
  }

  // ───── JOIN DATE ─────
  static String? getJoinDate() => prefs.getString('mf_joined');

  static Future<void> setJoinDateIfNew() async {
    if (getJoinDate() == null) {
      await prefs.setString('mf_joined', DateTime.now().toIso8601String());
    }
  }

  // ───── SAVE QUIZ (MAIN) ─────
  static Future<void> saveQuizResult({
    required String topic,
    required int earnedXP,
    required int correctCount,
    required int totalQuestions,
    required int sessionBestStreak,
  }) async {
    // LOCAL (UI uses this)
    await addXP(earnedXP);
    await incrementQuizzesTaken();
    await addCorrect(correctCount);
    await addQuestions(totalQuestions);
    await recordActivity();
    await setJoinDateIfNew();

    await recordDailyAnswer(totalQuestions); // ✅ ADD HERE

    final prevBest = getBestStreak();
    if (sessionBestStreak > prevBest) {
      await setBestStreak(sessionBestStreak);
    }

    final topicScores = getTopicScores();
    topicScores[topic] = ((correctCount / totalQuestions) * 100).round();
    topicScores['${topic}_played'] = (topicScores['${topic}_played'] ?? 0) + 1;
    await setTopicScores(topicScores);

    // SUPABASE SAVE
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null) {
        await supabase.from('users').update({
          'xp': getXP(),
          'level': getLevel(), // ✅ ADD THIS
          'quizzes_taken': getQuizzesTaken(),
          'correct_total': getCorrectTotal(),
          'questions_total': getQuestionsTotal(),
          'best_streak': getBestStreak(),
          'daily_streak': getDailyStreak(),
          'last_active': DateTime.now().toIso8601String(),
        }).eq('id', user.id);
      }
    } catch (e) {
      print("Supabase save error 👉 $e");
    }
  }

  // ───── LOAD FROM SUPABASE ─────
  static Future<void> syncFromSupabase() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final data =
        await supabase.from('users').select().eq('id', user.id).single();

    await prefs.setInt('mf_xp', data['xp'] ?? 0);
    await prefs.setInt('mf_level', data['level'] ?? 1);
    await prefs.setInt('mf_best_streak', data['best_streak'] ?? 0);
    await prefs.setInt('mf_quizzes_taken', data['quizzes_taken'] ?? 0);
    await prefs.setInt('mf_correct_total', data['correct_total'] ?? 0);
    await prefs.setInt('mf_questions_total', data['questions_total'] ?? 0);
    await prefs.setInt('mf_daily_streak', data['daily_streak'] ?? 0);
  }

  // ───── EXTRA ─────
  static double getAccuracy() {
    final total = getQuestionsTotal();
    final correct = getCorrectTotal();
    if (total == 0) return 0;
    return (correct / total) * 100;
  }

  static bool isLoggedIn() => getUsername() != null;

  static bool hasInterests() => getInterests().isNotEmpty;
}
