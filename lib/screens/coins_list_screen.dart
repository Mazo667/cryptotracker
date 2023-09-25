import 'package:cryptotracker/api_client.dart';
import 'package:cryptotracker/models.dart';
import 'package:flutter/material.dart';

class CoinsListScreen extends StatefulWidget {
  const CoinsListScreen({super.key});

  @override
  State<CoinsListScreen> createState() => _CoinsListScreenState();
}

class _CoinsListScreenState extends State<CoinsListScreen> {
  List<String> _defaultCoins = ['bitcoin', 'ethereum', 'dogecoin'];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Coin>>(
      future: ApiClient().getCoins(_defaultCoins),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Coin>? coins = snapshot.data;
        if (coins == null) {
          throw Exception("Error getting Coin");
        } else {
          return ListView.builder(
              itemCount: coins.length,
              itemBuilder: (context, index) {
                return CoinItem(
                  coin: coins[index],
                );
              });
        }
      },
    );
  }
}

class CoinItem extends StatelessWidget {
  final Coin coin;
  CoinItem({super.key, required this.coin});

  bool up = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: DefaultTextStyle(
        style: const TextStyle(
            fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w400),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                coin.imageUrl,
                width: 60,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(coin.name), Text(coin.symbol)],
              ),
              //el spacer ocupa todo el espacio posible
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${coin.priceVsUsd}"),
                  Text("%${coin.priceChange24Percentaje}",
                      style: TextStyle(
                          color: up ? Colors.lightGreen : Colors.redAccent))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
