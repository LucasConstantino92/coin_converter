import 'package:coincov/data/api/request_conversion.dart';
import 'package:coincov/data/models/conversion_result.dart';
import 'package:coincov/data/models/currency_info.dart';
import 'package:flutter/material.dart';

class CurrencyProvider extends ChangeNotifier {

  Map<String, CurrencyInfo>? _currencyData;
  ConversionResult? _conversionResult;
  bool _isLoading = false;
  String? _errorMessage;
  String _baseCurrency = 'USD';

  bool get isLoading => _isLoading;
  Map<String, CurrencyInfo>? get currencyData => _currencyData;
  ConversionResult? get conversionResult => _conversionResult;
  String? get errorMessage => _errorMessage;
  String get baseCurrency => _baseCurrency;

  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      _currencyData = await CurrencyService.loadCurrencyData();
      await fetchRates(_baseCurrency);

    } catch (e) {
      _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRates(String baseCurrency) async {
    try {
      _isLoading = true;
      _baseCurrency = baseCurrency;
      notifyListeners();

      _conversionResult = await CurrencyService.fetchConversionRates(baseCurrency);
      _errorMessage = null;

    } catch (e) {
      _errorMessage = 'Erro ao carregar taxas: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}