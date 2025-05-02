class CurrencyInfo {
  final String code;
  final String name;
  final String symbol;

  CurrencyInfo({
    required this.code,
    required this.name,
    required this.symbol,
  });

  factory CurrencyInfo.fromJson(Map<String, dynamic> json) {
    return CurrencyInfo(
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
    );
  }
}