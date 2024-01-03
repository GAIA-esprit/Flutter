import 'package:flutter/material.dart';
import 'package:quiz_backoffice/pages/overview/widgets/info_card.dart';
import 'package:quiz_backoffice/model/quiz.dart'; // Import your Quiz class
import 'package:quiz_backoffice/api/quizapi.dart';

class OverviewCardsLargeScreen extends StatefulWidget {
  const OverviewCardsLargeScreen({Key? key}) : super(key: key);

  @override
  _OverviewCardsLargeScreenState createState() => _OverviewCardsLargeScreenState();
}

class _OverviewCardsLargeScreenState extends State<OverviewCardsLargeScreen> {
  int quizzesCount = 0; // Initialize quizzes count
  int hiddenquizzesCount = 0;

  @override
  void initState() {
    super.initState();
    // Fetch quizzes when the widget is initialized
    ApiService.fetchQuizzes().then((quizzes) {
      setState(() {
        quizzesCount = quizzes.length;
      });
    });
    ApiService.fetchHiddenQuizzes().then((quizzes2) {
      setState(() {
        hiddenquizzesCount = quizzes2.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        InfoCard(
          title: "Available Quizzes",
          value: (quizzesCount-hiddenquizzesCount).toString(),
          onTap: () {},
          topColor: Colors.orange,
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: "Total Quizzes",
          value: quizzesCount.toString(),
          topColor: Colors.lightGreen,
          onTap: () {},
        ),
        SizedBox(
          width: width / 64,
        ),
      ],
    );
  }
}
