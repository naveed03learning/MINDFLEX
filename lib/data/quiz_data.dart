// ignore_for_file: duplicate_ignore, prefer_const_constructors, unnecessary_const

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

class QuizData {
  static const Map<String, List<QuizQuestion>> allQuestions = {
    'Riddles': [
      const QuizQuestion(
        question: 'What has keys but can\'t open locks?',
        options: ['A piano', 'A map', 'A book', 'A door'],
        answerIndex: 0,
        hint: 'It\'s a musical instrument.',
        difficulty: 'Easy',
        xp: 10,
      ),
      const QuizQuestion(
        question:
            'I speak without a mouth and hear without ears. I have no body, but I come alive with wind. What am I?',
        options: ['An echo', 'A ghost', 'A shadow', 'A dream'],
        answerIndex: 0,
        hint: 'You often hear me in mountains.',
        difficulty: 'Easy',
        xp: 10,
      ),
      const QuizQuestion(
        question: 'The more you take, the more you leave behind. What am I?',
        options: ['Time', 'Footsteps', 'Money', 'Breath'],
        answerIndex: 1,
        hint: 'Think about walking on a sandy beach.',
        difficulty: 'Easy',
        xp: 10,
      ),
      const QuizQuestion(
        question:
            'I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?',
        options: ['A map', 'A globe', 'A painting', 'A dream'],
        answerIndex: 0,
        hint: 'You look at me to find your way.',
        difficulty: 'Medium',
        xp: 15,
      ),
      const QuizQuestion(
        question:
            'What can you hold in your left hand but never in your right?',
        options: ['Your elbow', 'Your right hand', 'A pen', 'Your heart'],
        answerIndex: 1,
        hint: 'Think about your own body.',
        difficulty: 'Medium',
        xp: 15,
      ),
    ],
    'Memory': [
      const QuizQuestion(
        question:
            'Which memory technique involves associating new information with vivid mental images?',
        options: [
          'Chunking',
          'Method of loci',
          'Peg system',
          'Spaced repetition'
        ],
        answerIndex: 2,
        hint: 'Uses mental "pegs" to hang information.',
        difficulty: 'Hard',
        xp: 20,
      ),
      const QuizQuestion(
        question: 'What is the average short-term memory capacity in items?',
        options: ['5 ± 2', '7 ± 2', '9 ± 2', '11 ± 2'],
        answerIndex: 1,
        hint: 'Known as Miller\'s Law.',
        difficulty: 'Medium',
        xp: 15,
      ),
      const QuizQuestion(
        question: 'Which type of memory lasts only a fraction of a second?',
        options: ['Short-term', 'Long-term', 'Sensory', 'Working'],
        answerIndex: 2,
        hint: 'Iconic and echoic are types of this.',
        difficulty: 'Medium',
        xp: 15,
      ),
      const QuizQuestion(
        question:
            'The "testing effect" shows that the best way to retain information is to:',
        options: [
          'Read repeatedly',
          'Highlight text',
          'Active recall practice',
          'Listen to recordings'
        ],
        answerIndex: 2,
        hint: 'Retrieval practice strengthens memory.',
        difficulty: 'Hard',
        xp: 20,
      ),
      const QuizQuestion(
        question: 'What is chunking in memory?',
        options: [
          'Memorizing in chunks',
          'Grouping info into meaningful units',
          'Breaking down complex info',
          'Memorizing step by step'
        ],
        answerIndex: 1,
        hint: 'Like grouping phone numbers.',
        difficulty: 'Easy',
        xp: 10,
      ),
    ],
    'Logic': [
      const QuizQuestion(
        question:
            'If all roses are flowers and some flowers fade quickly, which statement is definitely true?',
        options: [
          'All roses fade quickly',
          'Some roses fade quickly',
          'No roses fade quickly',
          'Cannot be determined'
        ],
        answerIndex: 3,
        hint: 'This is a syllogism problem.',
        difficulty: 'Hard',
        xp: 20,
      ),
      const QuizQuestion(
        question:
            'What is the next number in the sequence: 2, 6, 12, 20, 30, ?',
        options: ['40', '42', '44', '46'],
        answerIndex: 1,
        hint: 'Look at the differences between numbers.',
        difficulty: 'Medium',
        xp: 15,
      ),
      const QuizQuestion(
        question:
            'If A is taller than B, B is taller than C, and C is taller than D, who is the shortest?',
        options: ['A', 'B', 'C', 'D'],
        answerIndex: 3,
        hint: 'Work from tallest to shortest.',
        difficulty: 'Easy',
        xp: 10,
      ),
      const QuizQuestion(
        question: 'Which logical fallacy assumes what needs to be proven?',
        options: [
          'Straw man',
          'Ad hominem',
          'Begging the question',
          'False dilemma'
        ],
        answerIndex: 2,
        hint: 'Circular reasoning in disguise.',
        difficulty: 'Hard',
        xp: 20,
      ),
      const QuizQuestion(
        question:
            'If all birds can fly and a penguin is a bird, can a penguin fly?',
        options: ['Yes', 'No', 'Sometimes', 'Cannot be determined'],
        answerIndex: 1,
        hint: 'Check the validity of the premise.',
        difficulty: 'Medium',
        xp: 15,
      ),
    ],
    'Lateral Thinking': [
      const QuizQuestion(
        question:
            'A man pushes his car to a hotel and pays the owner. What happened?',
        options: [
          'He lost his money',
          'He played monopoly',
          'He was at the beach',
          'He needed a place to stay'
        ],
        answerIndex: 1,
        hint: 'Think of a popular board game.',
        difficulty: 'Medium',
        xp: 15,
      ),
      const QuizQuestion(
        question:
            'A man walks into a bar and asks for water. The bartender points a gun at him. Why does the man say "thank you" and leave?',
        options: [
          'He was scared',
          'The bartender saved his life',
          'It was a joke',
          'He got what he wanted'
        ],
        answerIndex: 1,
        hint: 'What could water from a gun mean?',
        difficulty: 'Hard',
        xp: 20,
      ),
      const QuizQuestion(
        question:
            'A woman has six daughters and each daughter has one brother. How many children does she have?',
        options: ['6', '7', '12', '13'],
        answerIndex: 1,
        hint: 'Think about shared family members.',
        difficulty: 'Medium',
        xp: 15,
      ),
      const QuizQuestion(
        question:
            'A doctor gives you 3 pills and tells you to take one every half hour. How long will they last?',
        options: ['1 hour', '1.5 hours', '2 hours', '3 hours'],
        answerIndex: 1,
        hint: 'When do you take the first one?',
        difficulty: 'Easy',
        xp: 10,
      ),
      const QuizQuestion(
        question:
            'An electric train is traveling south at 100 mph. The wind is blowing west at 50 mph. Which direction does the smoke blow?',
        options: ['South', 'West', 'East', 'There is no smoke'],
        answerIndex: 3,
        hint: 'What type of train is it?',
        difficulty: 'Medium',
        xp: 15,
      ),
    ],
  };
}
