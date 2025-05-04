import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/currency_info.dart';
import '../models/conversion_result.dart';
import 'package:http/http.dart' as http;

class CurrencyService {
  static Future<Map<String, CurrencyInfo>> loadCurrencyData() async {
    try {
      final String response = await rootBundle.loadString('assets/currencies.json');
      final data = json.decode(response);

      return {
        for (var item in data['currencies'])
          item['code']: CurrencyInfo.fromJson(item)
      };
    } catch (e) {
      throw Exception('Falha ao carregar dados das moedas: $e');
    }
  }

  static Future<ConversionResult> fetchConversionRates(String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('https://v6.exchangerate-api.com/v6/1aac20827995a2f516bcea5c/latest/$baseCurrency'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return ConversionResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na requisição: $e');
    }
  }
}