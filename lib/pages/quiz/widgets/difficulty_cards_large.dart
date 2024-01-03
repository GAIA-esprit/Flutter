import 'package:flutter/material.dart';
import 'package:quiz_backoffice/pages/overview/widgets/info_card.dart';
import 'package:quiz_backoffice/model/quiz.dart';
import 'package:quiz_backoffice/api/quizapi.dart';

class DifficultyCardsLargeScreen extends StatefulWidget {
  const DifficultyCardsLargeScreen({Key? key}) : super(key: key);

  @override
  _DifficultyCardsLargeScreenState createState() =>
      _DifficultyCardsLargeScreenState();
}

class _DifficultyCardsLargeScreenState
    extends State<DifficultyCardsLargeScreen> {
  late Future<int> easy;
  late Future<int> medium;
  late Future<int> hard;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    easy = ApiService.fetchQuizzesByDifficulty('easy').then((quizzes) {
      return quizzes.length;
    });

    medium = ApiService.fetchQuizzesByDifficulty('medium').then((quizzes1) {
      return quizzes1.length;
    });

    hard = ApiService.fetchQuizzesByDifficulty('hard').then((quizzes2) {
      return quizzes2.length;
    });

    // Refresh UI after fetching data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        buildInfoCard("Easy Quizzes", easy, Colors.lightGreen),
        SizedBox(
          width: width / 64,
        ),
        buildInfoCard("Medium Quizzes", medium, Colors.yellow),
        SizedBox(
          width: width / 64,
        ),
        buildInfoCard("Hard Quizzes", hard, Colors.redAccent),
      ],
    );
  }

  Widget buildInfoCard(String title, Future<int> value, Color topColor) {
    return FutureBuilder<int>(
      future: value,
      builder: (context, snapshot) {
        return InfoCard(
          title: title,
          value: snapshot.hasData ? snapshot.data!.toString() : 'Loading...',
          onTap: () {
            // Handle onTap event if needed
          },
          topColor: topColor,
        );
      },
    );
  }
}
