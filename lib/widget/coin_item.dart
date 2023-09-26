import 'package:cryptotracker/models.dart';
import 'package:cryptotracker/screens/coin_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinItem extends StatelessWidget {
  final Coin coin;
  const CoinItem({super.key, required this.coin});


  @override
  Widget build(BuildContext context) {
    bool up = coin.priceChange24Percentaje > 0;
    return Card(
      elevation: 2,
      child: DefaultTextStyle(
        style: const TextStyle(
            fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w400),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CoinDetailScreen(coin: coin)));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.network(
                  coin.imageUrl,
                  width: 60,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(coin.name), Text(coin.symbol.toUpperCase())],
                ),
                //el spacer ocupa todo el espacio posible
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(NumberFormat.simpleCurrency().format(coin.priceVsUsd)),
                    Text(NumberFormat("####.##").format(coin.priceChange24Percentaje),
                        style: TextStyle(
                            color: up ? Colors.lightGreen : Colors.redAccent))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
