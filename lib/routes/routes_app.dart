
import 'package:coincov/ui/pages/home_page.dart';
import 'package:coincov/ui/pages/initial_page.dart';
import 'package:flutter/material.dart';

class RoutesApp {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      initial: (context) => const InitialPage(),
      home: (context) => const HomePage(),
    };
  }

  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}