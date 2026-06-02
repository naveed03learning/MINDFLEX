import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static final supabase = Supabase.instance.client;

  /// 🔥 Get current logged-in user ID
  static String? get userId => supabase.auth.currentUser?.id;

  /// 🔥 Fetch full user data
  static Future<Map<String, dynamic>?> getUserData() async {
    if (userId == null) return null;

    final data =
        await supabase.from('users').select().eq('id', userId!).single();

    return data;
  }

  /// 🔥 Save quiz result (MAIN FUNCTION)
  static Future<void> saveQuizResult({
    required String topic,
    required int earnedXP,
    required int correctCount,
    required int totalQuestions,
    required int sessionBestStreak,
  }) async {
    if (userId == null) return;

    try {
      final data = await getUserData();

      int newXP = (data?['xp'] ?? 0) + earnedXP;
      int newCorrect = (data?['correct_total'] ?? 0) + correctCount;
      int newQuestions = (data?['questions_total'] ?? 0) + totalQuestions;
      int newQuizzes = (data?['quizzes_taken'] ?? 0) + 1;

      int prevBest = data?['best_streak'] ?? 0;
      int newBest = sessionBestStreak > prevBest ? sessionBestStreak : prevBest;

      int newLevel = (newXP ~/ 100) + 1;

      await supabase.from('users').update({
        'xp': newXP,
        'level': newLevel,
        'correct_total': newCorrect,
        'questions_total': newQuestions,
        'quizzes_taken': newQuizzes,
        'best_streak': newBest,
        'last_active': DateTime.now().toIso8601String(),
      }).eq('id', userId!);
    } catch (e) {
      print("SAVE ERROR 👉 $e");
    }
  }

  /// 🔥 Daily streak update
  static Future<void> updateDailyStreak() async {
    if (userId == null) return;

    try {
      final data = await getUserData();

      final lastActive = data?['last_active'];
      int currentStreak = data?['daily_streak'] ?? 0;

      DateTime today = DateTime.now();
      DateTime? lastDate =
          lastActive != null ? DateTime.parse(lastActive) : null;

      int newStreak = 1;

      if (lastDate != null) {
        int diff = today.difference(lastDate).inDays;

        if (diff == 1) {
          newStreak = currentStreak + 1; // continue streak
        } else if (diff == 0) {
          newStreak = currentStreak; // same day
        } else {
          newStreak = 1; // reset
        }
      }

      await supabase.from('users').update({
        'daily_streak': newStreak,
      }).eq('id', userId!);
    } catch (e) {
      print("STREAK ERROR 👉 $e");
    }
  }

  /// 🔥 Get accuracy %
  static Future<double> getAccuracy() async {
    final data = await getUserData();

    int correct = data?['correct_total'] ?? 0;
    int total = data?['questions_total'] ?? 0;

    if (total == 0) return 0;

    return (correct / total) * 100;
  }
}
