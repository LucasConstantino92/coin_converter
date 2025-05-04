
import 'package:coincov/routes/routes_app.dart';
import 'package:flutter/material.dart';

class Coinconv extends StatelessWidget {
  const Coinconv({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coinconv',
      initialRoute: RoutesApp.home,
      routes: RoutesApp.getRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
