import 'package:bhukk/pages/get_started_screen.dart';
import 'package:bhukk/pages/home_screen.dart';
import 'package:bhukk/pages/spalsh_screen.dart';
import 'package:bhukk/route/routes.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget widgetScreen;

    switch (settings.name) {
      case Routes.splash:
        widgetScreen = SplashScreen();
        break;
      case Routes.getstarted:
        widgetScreen = GetStartedScreen();
        break;
      case Routes.home:
        widgetScreen = HomeScreen();
        break;

      default:
        widgetScreen = _errorRoute();
    }

    return PageRouteBuilder(
        settings: settings, pageBuilder: (_, __, ___) => widgetScreen);
  }

  static Widget _errorRoute() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text(
          'No such screen found in route generator',
        ),
      ),
    );
  }
}
