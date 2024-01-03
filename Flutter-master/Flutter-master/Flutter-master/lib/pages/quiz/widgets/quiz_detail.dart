import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz_backoffice/model/quiz.dart';
import 'package:quiz_backoffice/api/quizapi.dart';
import 'package:quiz_backoffice/widgets/custom_text.dart';

class QuizDetailPage extends StatefulWidget {
  final Quiz quiz;

  const QuizDetailPage({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController difficultyController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();
  TextEditingController incorrectAnswer1Controller = TextEditingController();
  TextEditingController incorrectAnswer2Controller = TextEditingController();
  TextEditingController incorrectAnswer3Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryController.text = widget.quiz.category;
    typeController.text = widget.quiz.type;
    difficultyController.text = widget.quiz.difficulty;
    questionController.text = widget.quiz.question;
    correctAnswerController.text = widget.quiz.correctAnswer;
    if (widget.quiz.incorrectAnswers.length >= 1) {
      incorrectAnswer1Controller.text = widget.quiz.incorrectAnswers[0];
    }
    if (widget.quiz.incorrectAnswers.length >= 2) {
      incorrectAnswer2Controller.text = widget.quiz.incorrectAnswers[1];
    }
    if (widget.quiz.incorrectAnswers.length >= 3) {
      incorrectAnswer3Controller.text = widget.quiz.incorrectAnswers[2];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Quiz Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Category', categoryController),
              _buildTextField('Type', typeController),
              _buildTextField('Difficulty', difficultyController),
              _buildTextField('Question', questionController),
              _buildTextField('Correct Answer', correctAnswerController),
              _buildTextField('Incorrect Answer 1', incorrectAnswer1Controller),
              _buildTextField('Incorrect Answer 2', incorrectAnswer2Controller),
              _buildTextField('Incorrect Answer 3', incorrectAnswer3Controller),

              ElevatedButton(
                onPressed: () {
                  _saveModifications();
                },
                child: CustomText(text: 'Save Modifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  void _saveModifications() async {
    try {
      Map<String, dynamic> updates = {
        'category': categoryController.text,
        'type': typeController.text,
        'difficulty': difficultyController.text,
        'question': questionController.text,
        'correct_answer': correctAnswerController.text,
        'incorrect_answers': [
          incorrectAnswer1Controller.text,
          incorrectAnswer2Controller.text,
          incorrectAnswer3Controller.text,
        ],
      };
      String quizId = widget.quiz.id ?? '';
      await ApiService.updateQuizById(quizId, updates);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(text: 'Quiz updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(text: 'Failed to update quiz: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
