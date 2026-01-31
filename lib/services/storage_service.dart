import 'package:shared_preferences/shared_preferences.dart';
import '../models/test_result.dart';

class StorageService {
  static const String _resultsKey = 'test_results';
  static const String _settingsKey = 'app_settings';
  
  // ... other methods ...
  
  // Get statistics - UPDATED VERSION
  static Future<Map<String, dynamic>> getStatistics() async {
    try {
      final results = await getTestResults();
      
      print('📊 Calculating statistics for ${results.length} test(s)');
      
      if (results.isEmpty) {
        print('📭 No test results found');
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
      
      final totalTests = results.length;
      final totalAccuracy = results.map((r) => r.accuracy).reduce((a, b) => a + b);
      final averageAccuracy = totalAccuracy / totalTests;
      
      // Find highest level achieved
      final highestLevelIndex = results
          .map((r) => r.estimatedLevel.index)
          .reduce((a, b) => a > b ? a : b);
      
      final totalQuestions = results.fold(0, (sum, result) => sum + result.questionsAnswered);
      final totalCorrect = results.fold(0, (sum, result) => sum + result.correctAnswers);
      final overallAccuracy = totalQuestions > 0 ? totalCorrect / totalQuestions : 0.0;
      
      // Get most recent test date
      String lastTestDate = 'Never';
      if (results.isNotEmpty) {
        final lastTest = results.reduce((a, b) => 
            a.completedAt.isAfter(b.completedAt) ? a : b);
        lastTestDate = _formatDateForDisplay(lastTest.completedAt);
      }
      
      final stats = {
        'totalTests': totalTests,
        'averageAccuracy': averageAccuracy,
        'bestLevel': _getLevelName(highestLevelIndex),
        'totalQuestions': totalQuestions,
        'correctAnswers': totalCorrect,
        'overallAccuracy': overallAccuracy,
        'lastTestDate': lastTestDate,
      };
      
      print('✅ Statistics calculated:');
      print('   Total Tests: $totalTests');
      print('   Average Accuracy: ${(averageAccuracy * 100).toStringAsFixed(1)}%');
      print('   Best Level: ${_getLevelName(highestLevelIndex)}');
      print('   Overall Accuracy: ${(overallAccuracy * 100).toStringAsFixed(1)}%');
      print('   Last Test: $lastTestDate');
      
      return stats;
    } catch (e) {
      print('❌ Error calculating statistics: $e');
      return {
        'totalTests': 0,
        'averageAccuracy': 0.0,
        'bestLevel': 'N/A',
        'totalQuestions': 0,
        'correctAnswers': 0,
        'overallAccuracy': 0.0,
        'lastTestDate': 'Error',
      };
    }
  }
  
  // ... other methods ...
  
  // Helper: Format date for display
  static String _formatDateForDisplay(DateTime date) {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final testDay = DateTime(date.year, date.month, date.day);
      
      if (testDay == today) {
        return 'Today';
      } else if (testDay == yesterday) {
        return 'Yesterday';
      } else {
        return '${date.day}/${date.month}/${date.year.toString().substring(2)}';
      }
    } catch (e) {
      return '${date.day}/${date.month}/${date.year.toString().substring(2)}';
    }
  }
  
  // Helper: Get level name
  static String _getLevelName(int levelIndex) {
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    return levels[levelIndex];
  }
}
