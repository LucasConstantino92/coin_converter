class ConversionResult {
  final String baseCode;
  final Map<String, double> rates;

  ConversionResult({
    required this.baseCode,
    required this.rates,
  });

  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    return ConversionResult(
      baseCode: json['base_code'] as String,
      rates: Map<String, double>.from(json['conversion_rates']),
    );
  }
}