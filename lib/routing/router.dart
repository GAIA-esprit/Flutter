import 'package:flutter/material.dart';
import 'package:quiz_backoffice/pages/clients/clients.dart';
import 'package:quiz_backoffice/pages/quiz/quiz.dart';
import 'package:quiz_backoffice/pages/overview/overview.dart';
import 'package:quiz_backoffice/pages/post/widgets/forum.dart';
import 'package:quiz_backoffice/pages/404/error.dart';
import 'package:quiz_backoffice/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(const OverviewPage());
    case quizsPageRoute:
      return _getPageRoute(QuizDetailPage());
      case postPageRoute:
      return _getPageRoute(Forum());
    case clientsPageRoute:
      return _getPageRoute(const ClientsPage());
    default:
      return _getPageRoute(const PageNotFound());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
