class QuizQuestion {
  final String question;
  final List<String> options;
  final int answerIndex;
  final String hint;
  final String difficulty;
  final int xp;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.hint,
    required this.difficulty,
    required this.xp,
  });
}

class TopicData {
  final String icon;
  final String color;
  final List<QuizQuestion> questions;

  const TopicData({
    required this.icon,
    required this.color,
    required this.questions,
  });
}

class QuizData {
  static const Map<String, String> topicIcons = {
    'Riddles': '🧩',
    'Memory': '🧠',
    'Logic': '🔗',
    'Lateral Thinking': '💡',
  };

  static const Map<String, String> topicColors = {
    'Riddles': '#FF8D8E',
    'Memory': '#FE81A3',
    'Logic': '#FF8D8E',
    'Lateral Thinking': '#C9A1FF',
  };

  static const Map<String, List<QuizQuestion>> allQuestions = {
    'Riddles': [
      QuizQuestion(
        question: "The more you take, the more you leave behind. What am I?",
        options: ["Time", "Memories", "Footsteps", "Breath"],
        answerIndex: 2,
        hint: "Think about physical movement.",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "I have cities but no houses, mountains but no trees, water but no fish. What am I?",
        options: ["A painting", "A map", "A mirror", "A dream"],
        answerIndex: 1,
        hint: "It's something you use for navigation.",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "What can run but never walks, has a mouth but never talks?",
        options: ["A river", "A clock", "A train", "The wind"],
        answerIndex: 0,
        hint: "It's found in nature and flows downhill.",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "I am not alive but I can grow. I don't have lungs but I need air. What am I?",
        options: ["A storm", "A plant", "Fire", "A wave"],
        answerIndex: 2,
        hint: "It's orange and hot.",
        difficulty: "Medium",
        xp: 15,
      ),
    ],
    'Memory': [
      QuizQuestion(
        question: "Study this sequence: 7, 3, 9, 1, 5. What is the 3rd number?",
        options: ["3", "7", "9", "1"],
        answerIndex: 2,
        hint: "Start from the first: 7 is 1st, 3 is 2nd...",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "A grocery list: Milk, Eggs, Bread, Butter, Cheese. What is the 4th item?",
        options: ["Bread", "Eggs", "Cheese", "Butter"],
        answerIndex: 3,
        hint: "Count: Milk(1), Eggs(2), Bread(3)...",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "Colors in order: Red, Blue, Green, Yellow, Purple. Which was shown 2nd?",
        options: ["Green", "Blue", "Red", "Yellow"],
        answerIndex: 1,
        hint: "Red came first in the sequence.",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "Remember: Apple, Train, Cloud, Mirror, River. How many items were in the list?",
        options: ["4", "6", "5", "3"],
        answerIndex: 2,
        hint: "Count carefully: Apple... Train... Cloud...",
        difficulty: "Medium",
        xp: 15,
      ),
      QuizQuestion(
        question: "Sequence: 4, 8, 15, 16, 23, 42 — sum of the 1st and last numbers?",
        options: ["44", "46", "48", "42"],
        answerIndex: 1,
        hint: "First is 4, last is 42.",
        difficulty: "Hard",
        xp: 25,
      ),
    ],
    'Logic': [
      QuizQuestion(
        question: "All cats are animals. All animals need water. Do cats need water?",
        options: ["No", "Maybe", "Yes", "Impossible to tell"],
        answerIndex: 2,
        hint: "Follow the chain of logic step by step.",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "Complete the sequence: 2, 4, 8, 16, __",
        options: ["24", "30", "32", "28"],
        answerIndex: 2,
        hint: "Each number is multiplied by something.",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "If A > B and B > C, which statement is definitely true?",
        options: ["C > A", "A > C", "B > A", "C = A"],
        answerIndex: 1,
        hint: "If A is bigger than B, and B is bigger than C...",
        difficulty: "Medium",
        xp: 15,
      ),
      QuizQuestion(
        question: "Find the next in the Fibonacci sequence: 1, 1, 2, 3, 5, 8, __",
        options: ["11", "12", "14", "13"],
        answerIndex: 3,
        hint: "Add the last two numbers together.",
        difficulty: "Medium",
        xp: 15,
      ),
      QuizQuestion(
        question: "If no fish are mammals and all dolphins are mammals, are dolphins fish?",
        options: ["Yes", "Maybe", "No", "Sometimes"],
        answerIndex: 2,
        hint: "Use the two given facts together.",
        difficulty: "Medium",
        xp: 15,
      ),
    ],
    'Lateral Thinking': [
      QuizQuestion(
        question: "How can you drop a raw egg onto a concrete floor without cracking it?",
        options: ["Use a soft egg", "Wrap it in cloth", "Concrete floors don't crack easily", "Drop it very slowly"],
        answerIndex: 2,
        hint: "The question says the egg won't crack — think about WHAT won't crack.",
        difficulty: "Medium",
        xp: 20,
      ),
      QuizQuestion(
        question: "How many months have 28 days?",
        options: ["1", "2", "12", "6"],
        answerIndex: 2,
        hint: "Every month has AT LEAST 28 days.",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "A woman shoots her husband. Minutes later, they dine together. How?",
        options: ["She missed", "It was a dream", "She's a photographer", "He survived"],
        answerIndex: 2,
        hint: "Think about non-lethal ways to 'shoot' someone.",
        difficulty: "Medium",
        xp: 20,
      ),
      QuizQuestion(
        question: "A rooster lays an egg on top of a barn roof. Which way does the egg roll?",
        options: ["Left", "Right", "Towards the wind", "Roosters don't lay eggs"],
        answerIndex: 3,
        hint: "Think about who is doing the laying.",
        difficulty: "Easy",
        xp: 10,
      ),
      QuizQuestion(
        question: "You have two ropes each taking 1 hour to burn. How do you measure exactly 45 minutes?",
        options: [
          "Light rope 1 from both ends + second from one end simultaneously",
          "Cut the ropes in half",
          "Burn them at different times",
          "Use a stopwatch instead"
        ],
        answerIndex: 0,
        hint: "Burning from both ends halves the time.",
        difficulty: "Hard",
        xp: 30,
      ),
    ],
  };
}
