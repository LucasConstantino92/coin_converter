
class CoinModel {
  final String result;
  final String lastUpdated;
  final String baseCoin;
  final Map<String, double> conversionRates;

  CoinModel({
    required this.result,
    required this.lastUpdated,
    required this.baseCoin,
    required this.conversionRates,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      result: json['result'] as String,
      lastUpdated: json['time_last_update_utc'] as String,
      baseCoin: json['base_code'] as String,
      conversionRates: Map<String, double>.from(json['conversion_rates']),
    );
  }

  @override
  String toString() {
    return 'CoinModel{result: $result, lastUpdated: $lastUpdated, baseCoin: $baseCoin, conversionRates: ${conversionRates.length} currencies}';
  }
}

class ApiError {
  final String result;
  final String errorType;

  ApiError({
    required this.result,
    required this.errorType,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      result: json['result'],
      errorType: json['error-type'],
    );
  }
}