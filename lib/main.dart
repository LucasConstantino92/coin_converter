import 'package:coincov/config/app_config.dart';
import 'package:coincov/providers/currency_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CurrencyProvider()..initialize(),
      child: const Coinconv(),
    ),
  );
}