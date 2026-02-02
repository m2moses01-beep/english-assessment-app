// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use
import 'package:flutter/material.dart';

// ============ MAIN APP ============
void main() {
  runApp(EnglishAssessmentApp());
}

class EnglishAssessmentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Assessment Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ============ ENUMS ============
enum CEFRLevel { a1, a2, b1, b2, c1, c2 }
enum QuestionCategory { grammar, vocabulary, reading }

// ============ MODELS ============
class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final CEFRLevel difficulty;
  final QuestionCategory category;
  final List<String> tags;
  final int timesUsed;
  final double successRate;
  
  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.difficulty,
    required this.category,
    this.tags = const [],
    this.timesUsed = 0,
    this.successRate = 0.5,
  });
}

class QuestionResponse {
  final Question question;
  final int? selectedAnswerIndex;
  final bool isCorrect;
  final Duration timeTaken;
  
  QuestionResponse({
    required this.question,
    required this.selectedAnswerIndex,
    required this.isCorrect,
    required this.timeTaken,
  });
}

class TestResult {
  final String testId;
  final DateTime completedAt;
  final CEFRLevel estimatedLevel;
  final int questionsAnswered;
  final int correctAnswers;
  final Duration totalTime;
  final List<QuestionResponse> responses;
  
  TestResult({
    required this.testId,
    required this.completedAt,
    required this.estimatedLevel,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.totalTime,
    required this.responses,
  });
  
  double get accuracy => questionsAnswered > 0 
      ? correctAnswers / questionsAnswered 
      : 0.0;
}

// ============ UTILITIES ============
class AppExtensions {
  // CEFRLevel Extensions
  static String getCEFRName(CEFRLevel level) {
    switch (level) {
      case CEFRLevel.a1: return 'A1 Beginner';
      case CEFRLevel.a2: return 'A2 Elementary';
      case CEFRLevel.b1: return 'B1 Intermediate';
      case CEFRLevel.b2: return 'B2 Upper Intermediate';
      case CEFRLevel.c1: return 'C1 Advanced';
      case CEFRLevel.c2: return 'C2 Proficient';
    }
  }
  
  static String getCEFRShortName(CEFRLevel level) {
    switch (level) {
      case CEFRLevel.a1: return 'A1';
      case CEFRLevel.a2: return 'A2';
      case CEFRLevel.b1: return 'B1';
      case CEFRLevel.b2: return 'B2';
      case CEFRLevel.c1: return 'C1';
      case CEFRLevel.c2: return 'C2';
    }
  }
  
  static Color getCEFRColor(CEFRLevel level) {
    switch (level) {
      case CEFRLevel.a1: return Colors.green;
      case CEFRLevel.a2: return Colors.lightGreen;
      case CEFRLevel.b1: return Colors.blue;
      case CEFRLevel.b2: return Colors.orange;
      case CEFRLevel.c1: return Colors.purple;
      case CEFRLevel.c2: return Colors.red;
    }
  }
  
  static Color getCEFRLightColor(CEFRLevel level) {
    switch (level) {
      case CEFRLevel.a1: return Colors.green.shade50;
      case CEFRLevel.a2: return Colors.lightGreen.shade50;
      case CEFRLevel.b1: return Colors.blue.shade50;
      case CEFRLevel.b2: return Colors.orange.shade50;
      case CEFRLevel.c1: return Colors.purple.shade50;
      case CEFRLevel.c2: return Colors.red.shade50;
    }
  }
  
  // QuestionCategory Extensions
  static String getCategoryName(QuestionCategory category) {
    switch (category) {
      case QuestionCategory.grammar: return 'Grammar';
      case QuestionCategory.vocabulary: return 'Vocabulary';
      case QuestionCategory.reading: return 'Reading';
    }
  }
  
  static IconData getCategoryIcon(QuestionCategory category) {
    switch (category) {
      case QuestionCategory.grammar: return Icons.g_translate;
      case QuestionCategory.vocabulary: return Icons.wordpress;
      case QuestionCategory.reading: return Icons.menu_book;
    }
  }
}

// ============ SERVICES ============
class QuestionService {
  static final List<Question> allQuestions = [
    // A1 Questions
    Question(
      id: 'A1_001',
      text: 'I ___ a student.',
      options: ['am', 'is', 'are', 'be'],
      correctAnswerIndex: 0,
      explanation: 'Use "am" with "I".',
      difficulty: CEFRLevel.a1,
      category: QuestionCategory.grammar,
      tags: ['to_be', 'present_simple'],
    ),
    Question(
      id: 'A1_002',
      text: 'She ___ to school every day.',
      options: ['go', 'goes', 'going', 'went'],
      correctAnswerIndex: 1,
      explanation: 'Use present simple "goes" for daily habits.',
      difficulty: CEFRLevel.a1,
      category: QuestionCategory.grammar,
      tags: ['present_simple', 'third_person'],
    ),
    Question(
      id: 'A1_003',
      text: 'What is the opposite of "hot"?',
      options: ['cold', 'warm', 'big', 'small'],
      correctAnswerIndex: 0,
      explanation: 'Hot ↔ Cold are opposites.',
      difficulty: CEFRLevel.a1,
      category: QuestionCategory.vocabulary,
      tags: ['antonyms', 'adjectives'],
    ),
    
    // A2 Questions
    Question(
      id: 'A2_001',
      text: 'Yesterday, I ___ to the market.',
      options: ['go', 'goes', 'went', 'going'],
      correctAnswerIndex: 2,
      explanation: 'Use past simple "went" with "yesterday".',
      difficulty: CEFRLevel.a2,
      category: QuestionCategory.grammar,
      tags: ['past_simple', 'time_expressions'],
    ),
    Question(
      id: 'A2_002',
      text: 'You ___ see a doctor if you feel sick.',
      options: ['should', 'must', 'will', 'can'],
      correctAnswerIndex: 0,
      explanation: '"Should" is used for advice.',
      difficulty: CEFRLevel.a2,
      category: QuestionCategory.grammar,
      tags: ['modals', 'advice'],
    ),
    
    // B1 Questions
    Question(
      id: 'B1_001',
      text: 'I have ___ this movie three times.',
      options: ['see', 'saw', 'seen', 'seeing'],
      correctAnswerIndex: 2,
      explanation: 'Use past participle "seen" with present perfect.',
      difficulty: CEFRLevel.b1,
      category: QuestionCategory.grammar,
      tags: ['present_perfect', 'irregular_verbs'],
    ),
    Question(
      id: 'B1_002',
      text: 'If it rains, we ___ cancel the picnic.',
      options: ['will', 'would', 'might', 'could'],
      correctAnswerIndex: 0,
      explanation: 'First conditional: if + present, will + base verb.',
      difficulty: CEFRLevel.b1,
      category: QuestionCategory.grammar,
      tags: ['conditionals', 'first_conditional'],
    ),
    
    // B2 Questions
    Question(
      id: 'B2_001',
      text: 'The report ___ by the team right now.',
      options: ['is being prepared', 'is prepared', 'prepares', 'preparing'],
      correctAnswerIndex: 0,
      explanation: 'Present continuous passive for actions happening now.',
      difficulty: CEFRLevel.b2,
      category: QuestionCategory.grammar,
      tags: ['passive_voice', 'present_continuous'],
    ),
    
    // C1 Questions
    Question(
      id: 'C1_001',
      text: '___ had I arrived than the phone rang.',
      options: ['No sooner', 'Hardly', 'Scarcely', 'Only'],
      correctAnswerIndex: 0,
      explanation: '"No sooner...than" is a fixed structure.',
      difficulty: CEFRLevel.c1,
      category: QuestionCategory.grammar,
      tags: ['inversion', 'fixed_expressions'],
    ),
  ];
  
  static Map<CEFRLevel, List<Question>> getQuestionsByLevel() {
    final map = <CEFRLevel, List<Question>>{};
    for (final level in CEFRLevel.values) {
      map[level] = allQuestions.where((q) => q.difficulty == level).toList();
    }
    return map;
  }
  
  static List<Question> getQuestionsForAdaptiveTest(CEFRLevel startingLevel) {
    final allQuestionsByLevel = getQuestionsByLevel();
    final selectedQuestions = <Question>[];
    
    final centerIndex = startingLevel.index;
    final levels = [
      startingLevel,
      if (centerIndex > 0) CEFRLevel.values[centerIndex - 1],
      if (centerIndex < CEFRLevel.values.length - 1) CEFRLevel.values[centerIndex + 1],
    ].whereType<CEFRLevel>().toList();
    
    final questionsPerLevel = 2;
    
    for (final level in levels) {
      final levelQuestions = allQuestionsByLevel[level] ?? [];
      if (levelQuestions.isNotEmpty) {
        final shuffled = List.of(levelQuestions)..shuffle();
        selectedQuestions.addAll(shuffled.take(questionsPerLevel));
      }
    }
    
    return selectedQuestions;
  }
}

class AdaptiveTestEngine {
  final List<Question> testQuestions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool testCompleted = false;
  final List<QuestionResponse> responses = [];
  DateTime? testStartTime;
  DateTime? questionStartTime;
  
  int currentDifficulty = 3;
  int correctInRow = 0;
  int wrongInRow = 0;
  
  AdaptiveTestEngine(this.testQuestions) {
    testStartTime = DateTime.now();
    questionStartTime = DateTime.now();
  }
  
  Question getCurrentQuestion() {
    return testQuestions[currentQuestionIndex];
  }
  
  void submitAnswer(int selectedIndex) {
    final question = getCurrentQuestion();
    final isCorrect = selectedIndex == question.correctAnswerIndex;
    final timeTaken = DateTime.now().difference(questionStartTime!);
    
    responses.add(QuestionResponse(
      question: question,
      selectedAnswerIndex: selectedIndex,
      isCorrect: isCorrect,
      timeTaken: timeTaken,
    ));
    
    if (isCorrect) {
      score++;
      correctInRow++;
      wrongInRow = 0;
      
      if (correctInRow >= 2 && currentDifficulty < 6) {
        currentDifficulty++;
        correctInRow = 0;
      }
    } else {
      wrongInRow++;
      correctInRow = 0;
      
      if (wrongInRow >= 2 && currentDifficulty > 1) {
        currentDifficulty--;
        wrongInRow = 0;
      }
    }
    
    if (currentQuestionIndex < testQuestions.length - 1) {
      currentQuestionIndex++;
      questionStartTime = DateTime.now();
    } else {
      testCompleted = true;
    }
  }
  
  CEFRLevel getEstimatedLevel() {
    return CEFRLevel.values[currentDifficulty - 1];
  }
  
  TestResult getResults() {
    final totalTime = DateTime.now().difference(testStartTime!);
    
    return TestResult(
      testId: 'test_${DateTime.now().millisecondsSinceEpoch}',
      completedAt: DateTime.now(),
      estimatedLevel: getEstimatedLevel(),
      questionsAnswered: responses.length,
      correctAnswers: score,
      totalTime: totalTime,
      responses: responses,
    );
  }
}

// ============ WIDGETS ============
class DifficultyBadge extends StatelessWidget {
  final CEFRLevel level;
  final bool compact;
  
  const DifficultyBadge({
    Key? key,
    required this.level,
    this.compact = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppExtensions.getCEFRColor(level).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppExtensions.getCEFRColor(level), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppExtensions.getCEFRColor(level),
              shape: BoxShape.circle,
            ),
          ),
          if (!compact) SizedBox(width: 6),
          if (!compact)
            Text(
              AppExtensions.getCEFRShortName(level),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppExtensions.getCEFRColor(level),
              ),
            ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final bool showDetails;
  
  const QuestionCard({
    Key? key,
    required this.question,
    this.showDetails = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DifficultyBadge(level: question.difficulty),
                const SizedBox(width: 8),
                Chip(
                  label: Text(AppExtensions.getCategoryName(question.category)),
                  backgroundColor: Colors.grey.shade100,
                  avatar: Icon(AppExtensions.getCategoryIcon(question.category), size: 16),
                ),
                const Spacer(),
                if (question.timesUsed > 0)
                  Text(
                    'Used ${question.timesUsed}×',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              question.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            
            if (showDetails) ...[
              const SizedBox(height: 16),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Options:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isCorrect = index == question.correctAnswerIndex;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green.shade50 : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isCorrect ? Colors.green : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isCorrect ? Colors.green : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  color: isCorrect ? Colors.white : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(option)),
                          if (isCorrect)
                            const Icon(Icons.check, size: 16, color: Colors.green),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Explanation:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(question.explanation),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============ SCREENS ============
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionStats = QuestionService.allQuestions.length;
    final levelStats = QuestionService.getQuestionsByLevel();
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Icon(Icons.language, size: 70, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                'English Assessment Pro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Adaptive Testing System',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              
              const SizedBox(height: 40),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Text(
                        'Question Bank',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat('Questions', questionStats.toString()),
                          _buildStat('Levels', '6'),
                          _buildStat('Categories', '3'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: CEFRLevel.values.map((level) {
                          final count = levelStats[level]?.length ?? 0;
                          return Chip(
                            label: Text('${AppExtensions.getCEFRShortName(level)}: $count'),
                            backgroundColor: AppExtensions.getCEFRLightColor(level),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdaptiveTestScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.psychology, size: 22),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Start Adaptive Test', style: TextStyle(fontSize: 16)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuestionBankScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.library_books),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('View Question Bank', style: TextStyle(fontSize: 16)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Professional English Assessment Tool\n'
                  'Adaptive Testing • Detailed Analytics • Question Bank',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class AdaptiveTestScreen extends StatefulWidget {
  const AdaptiveTestScreen({Key? key}) : super(key: key);

  @override
  State<AdaptiveTestScreen> createState() => _AdaptiveTestScreenState();
}

class _AdaptiveTestScreenState extends State<AdaptiveTestScreen> {
  late AdaptiveTestEngine testEngine;
  int? selectedAnswer;
  bool showFeedback = false;
  bool testComplete = false;
  TestResult? testResult;
  bool? isAnswerCorrect;
  
  @override
  void initState() {
    super.initState();
    final testQuestions = QuestionService.getQuestionsForAdaptiveTest(CEFRLevel.b1);
    testEngine = AdaptiveTestEngine(testQuestions);
  }
  
  void submitAnswer(int index) {
    final question = testEngine.getCurrentQuestion();
    final isCorrect = index == question.correctAnswerIndex;
    
    setState(() {
      selectedAnswer = index;
      isAnswerCorrect = isCorrect;
      showFeedback = true;
    });
    
    testEngine.submitAnswer(index);
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (testEngine.testCompleted) {
          setState(() {
            testComplete = true;
            testResult = testEngine.getResults();
          });
        } else {
          setState(() {
            selectedAnswer = null;
            isAnswerCorrect = null;
            showFeedback = false;
          });
        }
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (testComplete && testResult != null) {
      return ResultsScreen(result: testResult!);
    }
    
    final question = testEngine.getCurrentQuestion();
    final progress = (testEngine.currentQuestionIndex + 1) / testEngine.testQuestions.length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive English Test'),
        actions: [
          Chip(
            label: Text('Level: ${testEngine.currentDifficulty}'),
            backgroundColor: AppExtensions.getCEFRLightColor(CEFRLevel.values[testEngine.currentDifficulty - 1]),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${testEngine.currentQuestionIndex + 1}/${testEngine.testQuestions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(label: Text('Score: ${testEngine.score}')),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Text(
                              'Question ${testEngine.currentQuestionIndex + 1}',
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              question.text,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DifficultyBadge(level: question.difficulty),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(AppExtensions.getCategoryName(question.category)),
                                  backgroundColor: Colors.grey.shade100,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    ...question.options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isSelected = selectedAnswer == index;
                      
                      Color backgroundColor = Colors.white;
                      Color borderColor = Colors.grey.shade300;
                      Color textColor = Colors.black;
                      Color buttonColor = Colors.grey.shade200;
                      IconData? icon;
                      Color iconColor = Colors.transparent;
                      
                      if (isSelected) {
                        if (isAnswerCorrect == true) {
                          backgroundColor = Colors.green.shade50;
                          borderColor = Colors.green;
                          textColor = Colors.green.shade900;
                          buttonColor = Colors.green;
                          icon = Icons.check;
                          iconColor = Colors.green;
                        } else if (isAnswerCorrect == false) {
                          backgroundColor = Colors.red.shade50;
                          borderColor = Colors.red;
                          textColor = Colors.red.shade900;
                          buttonColor = Colors.red;
                          icon = Icons.close;
                          iconColor = Colors.red;
                        }
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          onPressed: selectedAnswer == null ? () => submitAnswer(index) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor,
                            foregroundColor: textColor,
                            padding: const EdgeInsets.all(14),
                            alignment: Alignment.centerLeft,
                            side: BorderSide(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(option)),
                              if (icon != null)
                                Icon(icon, color: iconColor),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    
                    if (showFeedback && selectedAnswer != null && isAnswerCorrect != null)
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isAnswerCorrect!
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isAnswerCorrect!
                                    ? Colors.green
                                    : Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isAnswerCorrect!
                                          ? Icons.check_circle
                                          : Icons.error,
                                      color: isAnswerCorrect!
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isAnswerCorrect!
                                          ? 'Correct!'
                                          : 'Incorrect',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isAnswerCorrect!
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Explanation:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(question.explanation),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionBankScreen extends StatelessWidget {
  const QuestionBankScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionsByLevel = QuestionService.getQuestionsByLevel();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Question Bank')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Question Bank Statistics',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Total', QuestionService.allQuestions.length.toString()),
                        _buildStat('Grammar', '2'),
                        _buildStat('Vocabulary', '1'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Questions by Level:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...CEFRLevel.values.map((level) {
              final questions = questionsByLevel[level]!;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DifficultyBadge(level: level),
                          const SizedBox(width: 12),
                          Text(
                            '${AppExtensions.getCEFRName(level)} (${questions.length} questions)',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...questions.take(2).map((question) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('• ${question.text}'),
                        );
                      }).toList(),
                      if (questions.length > 2)
                        Text('... and ${questions.length - 2} more', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            }).toList(),
            
            const SizedBox(height: 20),
            
            const Text(
              'All Questions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...QuestionService.allQuestions.map((question) {
              return QuestionCard(question: question);
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final TestResult result;
  
  const ResultsScreen({Key? key, required this.result}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Results')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppExtensions.getCEFRColor(result.estimatedLevel).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppExtensions.getCEFRColor(result.estimatedLevel), width: 3),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppExtensions.getCEFRShortName(result.estimatedLevel),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppExtensions.getCEFRColor(result.estimatedLevel),
                              ),
                            ),
                            Text(
                              AppExtensions.getCEFRName(result.estimatedLevel).split(' ')[1],
                              style: TextStyle(color: AppExtensions.getCEFRColor(result.estimatedLevel)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMetric('Score', '${result.correctAnswers}/${result.questionsAnswered}'),
                        _buildMetric('Accuracy', '${(result.accuracy * 100).toInt()}%'),
                        _buildMetric('Time', '${result.totalTime.inMinutes}m ${result.totalTime.inSeconds % 60}s'),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getPerformanceColor(result.accuracy),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.emoji_events, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            _getPerformanceText(result.accuracy),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Question Review',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...result.responses.asMap().entries.map((entry) {
                      final index = entry.key;
                      final response = entry.value;
                      
                      return Column(
                        children: [
                          QuestionCard(question: response.question, showDetails: true),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: response.isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  response.isCorrect ? Icons.check : Icons.close,
                                  color: response.isCorrect ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    response.isCorrect
                                        ? 'Correct! You answered correctly. (Time: ${response.timeTaken.inSeconds}s)'
                                        : 'Incorrect. Your answer: ${response.selectedAnswerIndex != null ? response.question.options[response.selectedAnswerIndex!] : "No answer selected"}. '
                                          'Correct answer: ${response.question.options[response.question.correctAnswerIndex]} (Time: ${response.timeTaken.inSeconds}s)',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (index < result.responses.length - 1) const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Back to Home'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const AdaptiveTestScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Take Another Test'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
  
  Color _getPerformanceColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.blue;
    if (accuracy >= 0.4) return Colors.orange;
    return Colors.red;
  }
  
  String _getPerformanceText(double accuracy) {
    if (accuracy >= 0.8) return 'Excellent Performance!';
    if (accuracy >= 0.6) return 'Good Job!';
    if (accuracy >= 0.4) return 'Fair Performance';
    return 'Needs More Practice';
  }
}
