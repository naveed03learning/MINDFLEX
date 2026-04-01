import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) throw Exception('StorageService not initialized');
    return _prefs!;
  }

  // User
  static String? getUsername() => prefs.getString('mf_user');
  static Future<void> setUsername(String name) => prefs.setString('mf_user', name);

  // Interests
  static List<String> getInterests() =>
      List<String>.from(jsonDecode(prefs.getString('mf_interests') ?? '[]'));
  static Future<void> setInterests(List<String> interests) =>
      prefs.setString('mf_interests', jsonEncode(interests));

  // XP
  static int getXP() => prefs.getInt('mf_xp') ?? 0;
  static Future<void> addXP(int amount) =>
      prefs.setInt('mf_xp', getXP() + amount);

  // Level
  static int getLevel() => (getXP() ~/ 100) + 1;

  // Streak
  static int getBestStreak() => prefs.getInt('mf_streak') ?? 0;
  static Future<void> setBestStreak(int streak) =>
      prefs.setInt('mf_streak', streak);

  // Quizzes taken
  static int getQuizzesTaken() => prefs.getInt('mf_quizzes_taken') ?? 0;
  static Future<void> incrementQuizzesTaken() =>
      prefs.setInt('mf_quizzes_taken', getQuizzesTaken() + 1);

  // Correct answers
  static int getCorrectTotal() => prefs.getInt('mf_correct_total') ?? 0;
  static Future<void> addCorrect(int count) =>
      prefs.setInt('mf_correct_total', getCorrectTotal() + count);

  // Total questions
  static int getQuestionsTotal() => prefs.getInt('mf_questions_total') ?? 0;
  static Future<void> addQuestions(int count) =>
      prefs.setInt('mf_questions_total', getQuestionsTotal() + count);

  // Topic scores
  static Map<String, dynamic> getTopicScores() =>
      Map<String, dynamic>.from(
          jsonDecode(prefs.getString('mf_topic_scores') ?? '{}'));
  static Future<void> setTopicScores(Map<String, dynamic> scores) =>
      prefs.setString('mf_topic_scores', jsonEncode(scores));

  // Weekly activity [Mon..Sun]
  static List<int> getWeeklyActivity() =>
      List<int>.from(jsonDecode(prefs.getString('mf_weekly_activity') ?? '[0,0,0,0,0,0,0]'));
  static Future<void> recordActivity() async {
    final activity = getWeeklyActivity();
    final dayIndex = (DateTime.now().weekday - 1) % 7; // Mon=0..Sun=6
    activity[dayIndex]++;
    await prefs.setString('mf_weekly_activity', jsonEncode(activity));
  }

  // Join date
  static String? getJoinDate() => prefs.getString('mf_joined');
  static Future<void> setJoinDateIfNew() async {
    if (getJoinDate() == null) {
      await prefs.setString('mf_joined', DateTime.now().toIso8601String());
    }
  }

  // Save entire quiz session
  static Future<void> saveQuizResult({
    required String topic,
    required int earnedXP,
    required int correctCount,
    required int totalQuestions,
    required int sessionBestStreak,
  }) async {
    await addXP(earnedXP);
    await incrementQuizzesTaken();
    await addCorrect(correctCount);
    await addQuestions(totalQuestions);
    await recordActivity();
    await setJoinDateIfNew();

    final prevBest = getBestStreak();
    if (sessionBestStreak > prevBest) {
      await setBestStreak(sessionBestStreak);
    }

    final topicScores = getTopicScores();
    topicScores[topic] = ((correctCount / totalQuestions) * 100).round();
    topicScores['${topic}_played'] = (topicScores['${topic}_played'] ?? 0) + 1;
    await setTopicScores(topicScores);
  }

  static double getAccuracy() {
    final total = getQuestionsTotal();
    final correct = getCorrectTotal();
    if (total == 0) return 0;
    return (correct / total) * 100;
  }

  static bool isLoggedIn() => getUsername() != null;
  static bool hasInterests() => getInterests().isNotEmpty;
}
