import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quiz_backoffice/model/quiz.dart';

class ApiService {
  static const String apiUrl = 'http://127.0.0.1:3000/api/quiz';

  static Future<List<Quiz>> fetchQuizzes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> quizJsonList = jsonDecode(response.body);
      return quizJsonList.map((quizJson) => Quiz.fromJson(quizJson)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  static Future<List<Quiz>> fetchQuizzesByDifficulty(String difficulty) async {
    final response = await http.get(Uri.parse('$apiUrl/$difficulty'));

    if (response.statusCode == 200) {
      final List<dynamic> quizJsonList = jsonDecode(response.body);
      return quizJsonList.map((quizJson) => Quiz.fromJson(quizJson)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  static Future<List<Quiz>> fetchHiddenQuizzes() async {
    final response = await http.get(Uri.parse('$apiUrl/quizzes/hidden'));

    if (response.statusCode == 200) {
      final List<dynamic> quizJsonList = jsonDecode(response.body);
      return quizJsonList.map((quizJson) => Quiz.fromJson(quizJson)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  static Future<bool> createQuiz(Map<String, dynamic> quizData) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(quizData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      final quiz = jsonDecode(response.body);
      print('Quiz created: $quiz');
      return true; // Indicate success
    } else {
      print('Failed to create quiz. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false; // Indicate failure
    }
  } catch (error, stackTrace) {
    print('Error creating quiz: $error');
    print('Stack trace: $stackTrace');
    return false; // Indicate failure
  }
}

  static Future<void> hideQuiz(String quizId) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/$quizId/hide'),
      );

      if (response.statusCode == 200) {
        print('Quiz with ID $quizId has been hidden.');
      } else {
        print(
            'Failed to hide quiz with ID $quizId. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  static Future<void> unhideQuiz(String quizId) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/$quizId/unhide'),
      );

      if (response.statusCode == 200) {
        print('Quiz with ID $quizId has been unhidden.');
      } else {
        print(
            'Failed to unhide quiz with ID $quizId. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  static Future<Quiz> updateQuizById(
      String quizId, Map<String, dynamic> updates) async {
    final String url =
        '$apiUrl/$quizId'; // Replace with your actual endpoint

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Add any additional headers if needed
        },
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200) {
        // Successful update
        return Quiz.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // Quiz not found
        throw Exception('Quiz not found');
      } else {
        // Handle other errors
        throw Exception('Failed to update quiz');
      }
    } catch (error) {
      // Handle network or other errors
      throw Exception('Failed to update quiz: $error');
    }
  }
}