import 'package:flutter/material.dart';
import 'package:quiz_backoffice/pages/overview/widgets/info_card.dart';


class OverviewCardsLargeScreen extends StatelessWidget {
  const OverviewCardsLargeScreen({super.key});


  @override
  Widget build(BuildContext context) {
   double width = MediaQuery.of(context).size.width;

    return  Row(
              children: [
                InfoCard(
                  title: "Users",
                  value: "7",
                  onTap: () {},
                  topColor: Colors.orange,
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: "Quizzes",
                  value: "17",
                  topColor: Colors.lightGreen,
                  onTap: () {},
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: "Quizzes with 100%",
                  value: "3",
                  topColor: Colors.redAccent,
                  onTap: () {},
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: "Test",
                  value: "32",
                  onTap: () {},
                ),
              ],
            );
  }
}