import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/currency_info.dart';
import '../models/conversion_result.dart';
import 'package:http/http.dart' as http;

class CurrencyService {
  static Future<Map<String, CurrencyInfo>> loadCurrencyData() async {
    final String response = await rootBundle.loadString('assets/currencies.json');
    final data = await json.decode(response);

    final List<CurrencyInfo> currencies = (data['currencies'] as List)
        .map((item) => CurrencyInfo.fromJson(item))
        .toList();

    return {for (var currency in currencies) currency.code: currency};
  }

  static Future<ConversionResult> fetchConversionRates(String baseCurrency) async {
    final response = await http.get(
      Uri.parse('https://v6.exchangerate-api.com/v6/SEU_API_KEY/latest/$baseCurrency'),
    );

    if (response.statusCode == 200) {
      return ConversionResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load rates');
    }
  }
}