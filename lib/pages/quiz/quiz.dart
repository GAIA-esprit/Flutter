import 'package:flutter/material.dart';
import 'package:quiz_backoffice/helpers/reponsiveness.dart';
import 'package:quiz_backoffice/constants/controllers.dart';
import 'package:quiz_backoffice/pages/quiz/widgets/quiz_table.dart';
import 'package:quiz_backoffice/pages/quiz/widgets/quiz_hidden_table.dart';
import 'package:quiz_backoffice/widgets/custom_text.dart';
import 'package:quiz_backoffice/api/quizapi.dart';
import 'package:quiz_backoffice/model/quiz.dart';
import 'package:quiz_backoffice/pages/quiz/widgets/quiz_form.dart';
import 'package:quiz_backoffice/pages/quiz/widgets/cards_large.dart';
import 'package:quiz_backoffice/pages/quiz/widgets/difficulty_cards_large.dart';
import 'package:quiz_backoffice/pages/quiz/widgets/quiz_chart.dart';
import 'package:get/get.dart';

class QuizDetailPage extends StatefulWidget {
  final ApiService quizApi = ApiService();

  QuizDetailPage({Key? key}) : super(key: key);

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  late Future<List<Quiz>> quizzes1;
  late Future<List<Quiz>> quizzes2;
  int activeTableIndex = 1;

  @override
  void initState() {
    super.initState();
    quizzes1 = ApiService.fetchQuizzes();
    quizzes2 = ApiService.fetchHiddenQuizzes(); // Fetch quizzes for the second table
  }

  void refreshTable() {
    setState(() {
      // Re-fetch the quizzes
      quizzes1 = ApiService.fetchQuizzes();
      quizzes2 = ApiService.fetchHiddenQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                child: CustomText(
                  text: menuController.activeItem.value,
                  size: 24,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    activeTableIndex = (activeTableIndex == 1) ? 2 : 1;
                  });
                },
                child: Text(
                  'Show ${activeTableIndex == 1 ? 'Hidden Quizzes' : 'All Quizzes'}',
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    OverviewCardsLargeScreen(),
                    DifficultyCardsLargeScreen(),
                    FutureBuilder<List<Quiz>>(
                      future: activeTableIndex == 1 ? quizzes1 : quizzes2,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Column(
                            children: [
                              activeTableIndex == 1
                                  ? QuizTable(quizzes: snapshot.data ?? [])
                                  : QuizHiddenTable(
                                      quizzes: snapshot.data ?? []),
                              SizedBox(
                                width: 120,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _openQuizForm(context);
                                  },
                                  child: Text('Add Quiz'),
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openQuizForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: AddQuizForm(),
        );
      },
    );
  }
}