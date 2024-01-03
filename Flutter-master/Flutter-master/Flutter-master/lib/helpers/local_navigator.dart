import 'package:flutter/cupertino.dart';
import 'package:quiz_backoffice/constants/controllers.dart';
import 'package:quiz_backoffice/routing/router.dart';
import 'package:quiz_backoffice/routing/routes.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: overviewPageRoute,
    );
