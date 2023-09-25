class Coin {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double priceVsUsd;
  final double priceChange24Percentaje;

  Coin(
      {required this.id,
      required this.name,
      required this.symbol,
      required this.imageUrl,
      required this.priceVsUsd,
      required this.priceChange24Percentaje});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        imageUrl: json['image']['large'],
        priceVsUsd: json['market_data']['current_price']['usd'].toDouble(),
        priceChange24Percentaje:
            json['market_data']['price_change_percentage_24h'].toDouble());
  }
}
