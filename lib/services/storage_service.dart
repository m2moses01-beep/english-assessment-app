import 'package:shared_preferences/shared_preferences.dart';
import '../models/test_result.dart';

class StorageService {
  static const String _resultsKey = 'test_results';
  static const String _settingsKey = 'app_settings';
  
  // Save a test result
  static Future<void> saveTestResult(TestResult result) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingResults = await getTestResults();
      existingResults.add(result);
      
      // Convert to JSON strings
      final resultsJson = existingResults.map((r) => _resultToJson(r)).toList();
      await prefs.setStringList(_resultsKey, resultsJson);
      
      print('✅ Test result saved: ${result.testId}');
    } catch (e) {
      print('❌ Error saving test result: $e');
    }
  }
  
  // Get all test results
  static Future<List<TestResult>> getTestResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resultsJson = prefs.getStringList(_resultsKey) ?? [];
      
      return resultsJson.map((json) => _resultFromJson(json)).toList();
    } catch (e) {
      print('❌ Error loading test results: $e');
      return [];
    }
  }
  
  // Get statistics
  static Future<Map<String, dynamic>> getStatistics() async {
    final results = await getTestResults();
    
    if (results.isEmpty) {
      return {
        'totalTests': 0,
        'averageAccuracy': 0.0,
        'bestLevel': 'N/A',
        'totalQuestions': 0,
        'correctAnswers': 0,
      };
    }
    
    final totalTests = results.length;
    final totalAccuracy = results.map((r) => r.accuracy).reduce((a, b) => a + b);
    final averageAccuracy = totalAccuracy / totalTests;
    
    // Find highest level achieved
    final highestLevelIndex = results
        .map((r) => r.estimatedLevel.index)
        .reduce((a, b) => a > b ? a : b);
    
    final totalQuestions = results.fold(0, (sum, result) => sum + result.questionsAnswered);
    final totalCorrect = results.fold(0, (sum, result) => sum + result.correctAnswers);
    
    return {
      'totalTests': totalTests,
      'averageAccuracy': averageAccuracy,
      'bestLevel': _getLevelName(highestLevelIndex),
      'totalQuestions': totalQuestions,
      'correctAnswers': totalCorrect,
      'overallAccuracy': totalQuestions > 0 ? totalCorrect / totalQuestions : 0.0,
    };
  }
  
  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('✅ All data cleared');
  }
  
  // Helper methods
  static String _resultToJson(TestResult result) {
    return '${result.testId}|${result.completedAt.toIso8601String()}|'
           '${result.estimatedLevel.index}|${result.questionsAnswered}|'
           '${result.correctAnswers}|${result.totalTime.inSeconds}';
  }
  
  static TestResult _resultFromJson(String json) {
    final parts = json.split('|');
    return TestResult(
      testId: parts[0],
      completedAt: DateTime.parse(parts[1]),
      estimatedLevel: CEFRLevel.values[int.parse(parts[2])],
      questionsAnswered: int.parse(parts[3]),
      correctAnswers: int.parse(parts[4]),
      totalTime: Duration(seconds: int.parse(parts[5])),
      responses: [], // We don't save responses for simplicity
    );
  }
  
  static String _getLevelName(int levelIndex) {
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    return levels[levelIndex];
  }
}
