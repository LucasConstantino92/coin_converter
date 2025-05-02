import 'package:coincov/data/api/request_conversion.dart';
import 'package:coincov/data/models/conversion_result.dart';
import 'package:coincov/data/models/currency_info.dart';
import 'package:flutter/material.dart';

class CurrencyProvider extends ChangeNotifier {
  Map<String, CurrencyInfo>? _currencyData;
  ConversionResult? _conversionResult;
  bool _isLoading = false;

  Map<String, CurrencyInfo>? get currencyData => _currencyData;
  ConversionResult? get conversionResult => _conversionResult;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _currencyData = await CurrencyService.loadCurrencyData();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRates(String baseCurrency) async {
    _isLoading = true;
    notifyListeners();

    _conversionResult = await CurrencyService.fetchConversionRates(baseCurrency);

    _isLoading = false;
    notifyListeners();
  }
}