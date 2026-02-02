import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart'; // To access TestResult and CEFRLevel

class StorageService {
  static const String _testResultsKey = 'test_results';
  static const String _statisticsKey = 'statistics';

  // Save a test result
  static Future<void> saveTestResult(TestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final existingResults = await getTestResults();
    
    // Add new result to the list
    existingResults.add(result);
    
    // Convert to JSON and save
    final jsonList = existingResults.map((r) => _resultToJson(r)).toList();
    await prefs.setString(_testResultsKey, json.encode(jsonList));
    
    // Update statistics
    await _updateStatistics(existingResults);
  }

  // Get all test results
  static Future<List<TestResult>> getTestResults() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_testResultsKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    
    try {
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => _resultFromJson(json)).toList();
    } catch (e) {
      print('Error parsing test results: $e');
      return [];
    }
  }

  // Get statistics
  static Future<Map<String, dynamic>> getStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    final results = await getTestResults();
    
    if (results.isEmpty) {
      return {
        'totalTests': 0,
        'averageAccuracy': 0.0,
        'bestLevel': 'N/A',
        'totalQuestions': 0,
        'correctAnswers': 0,
        'overallAccuracy': 0.0,
        'lastTestDate': 'Never',
      };
    }
    
    // Calculate statistics
    int totalTests = results.length;
    int totalQuestions = 0;
    int correctAnswers = 0;
    double totalAccuracy = 0.0;
    CEFRLevel? bestLevel;
    DateTime? latestDate;
    
    for (final result in results) {
      totalQuestions += result.questionsAnswered;
      correctAnswers += result.correctAnswers;
      totalAccuracy += result.accuracy;
      
      // Track best level (highest CEFR level)
      if (bestLevel == null || result.estimatedLevel.index > bestLevel.index) {
        bestLevel = result.estimatedLevel;
      }
      
      // Track latest test date
      if (latestDate == null || result.completedAt.isAfter(latestDate)) {
        latestDate = result.completedAt;
      }
    }
    
    final averageAccuracy = totalTests > 0 ? totalAccuracy / totalTests : 0.0;
    final overallAccuracy = totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
    
    return {
      'totalTests': totalTests,
      'averageAccuracy': averageAccuracy,
      'bestLevel': bestLevel != null ? AppExtensions.getCEFRShortName(bestLevel) : 'N/A',
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'overallAccuracy': overallAccuracy,
      'lastTestDate': latestDate != null ? _formatDate(latestDate!) : 'Never',
    };
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_testResultsKey);
    await prefs.remove(_statisticsKey);
  }

  // Update statistics
  static Future<void> _updateStatistics(List<TestResult> results) async {
    final stats = await getStatistics();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statisticsKey, json.encode(stats));
  }

  // Helper methods for JSON conversion
  static Map<String, dynamic> _resultToJson(TestResult result) {
    return {
      'testId': result.testId,
      'completedAt': result.completedAt.toIso8601String(),
      'estimatedLevel': result.estimatedLevel.index,
      'questionsAnswered': result.questionsAnswered,
      'correctAnswers': result.correctAnswers,
      'totalTime': result.totalTime.inMilliseconds,
      'responses': result.responses.map((r) => _responseToJson(r)).toList(),
    };
  }

  static TestResult _resultFromJson(Map<String, dynamic> json) {
    return TestResult(
      testId: json['testId'],
      completedAt: DateTime.parse(json['completedAt']),
      estimatedLevel: CEFRLevel.values[json['estimatedLevel']],
      questionsAnswered: json['questionsAnswered'],
      correctAnswers: json['correctAnswers'],
      totalTime: Duration(milliseconds: json['totalTime']),
      responses: (json['responses'] as List)
          .map((r) => _responseFromJson(r))
          .toList(),
    );
  }

  static Map<String, dynamic> _responseToJson(QuestionResponse response) {
    return {
      'questionId': response.question.id,
      'selectedAnswerIndex': response.selectedAnswerIndex,
      'isCorrect': response.isCorrect,
      'timeTaken': response.timeTaken.inMilliseconds,
    };
  }

  static QuestionResponse _responseFromJson(Map<String, dynamic> json) {
    // Find the question by ID
    final question = QuestionService.allQuestions
        .firstWhere((q) => q.id == json['questionId']);
    
    return QuestionResponse(
      question: question,
      selectedAnswerIndex: json['selectedAnswerIndex'],
      isCorrect: json['isCorrect'],
      timeTaken: Duration(milliseconds: json['timeTaken']),
    );
  }

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final testDay = DateTime(date.year, date.month, date.day);
    
    if (testDay == today) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (testDay == yesterday) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year.toString().substring(2)}';
    }
  }
}
