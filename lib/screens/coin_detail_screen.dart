import 'package:cryptotracker/api_client.dart';
import 'package:cryptotracker/models.dart';
import 'package:cryptotracker/widget/coin_market_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinDetailScreen extends StatelessWidget {
  final Coin coin;
  const CoinDetailScreen({super.key,required this.coin});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency();
    bool increased = coin.priceChange24Percentaje > 0;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(coin.imageUrl,width: 40),
            const Padding(padding: EdgeInsets.only(right: 3,left: 3)),
            Text(coin.symbol.toUpperCase(),style: const TextStyle(color: Colors.black54)),
            const Padding(padding: EdgeInsets.only(right: 60)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("USD${currencyFormatter.format(coin.priceVsUsd)}",style: const TextStyle(fontSize: 20,fontFamily: 'Ostrich')),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: increased ? Colors.green : Colors.redAccent
                      ),
                      child: Row(
                        children: [Icon(increased ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: Colors.white),
                        Text("${NumberFormat("####.##").format(coin.priceChange24Percentaje)}%",style: const TextStyle(color: Colors.white,fontFamily: 'Ostrich'))
                        ]
                      )
                    )
                ],
              ),
            )
            ),
            Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CoinMarketChart(coinId: coin.id),
            )),
            Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MarketInfoRows(coin.id, currencyFormatter),
            )),
          ],
        ),
      ),
    );

  }
}

class MarketInfoRows extends StatelessWidget {
  final String coinId;
  final NumberFormat currencyFormatter;
  const MarketInfoRows(this.coinId, this.currencyFormatter, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiClient().getCoinMarketInfo(coinId),
        builder: (context,snapshot){
          List<Widget> rows = [];
          if (snapshot.hasData) {
            CoinMarketInfo? coinInfo = snapshot.data;
            if (coinInfo != null) {
              List<MarketField> marketFields = [
                MarketField("Market cap rank", "#${coinInfo.marketCapRank}"),
                MarketField(
                    "Market cap", currencyFormatter.format(coinInfo.marketCap)),
                MarketField("Trading volume",
                    currencyFormatter.format(coinInfo.tradingVolume24H)),
                MarketField("Circulating supply",
                    currencyFormatter.format(coinInfo.circulatingSupply)),
                MarketField("Total supply",
                    currencyFormatter.format(coinInfo.totalSupply)),
                MarketField(
                    "Max supply", currencyFormatter.format(coinInfo.maxSupply)),
              ];
              marketFields.asMap().forEach((index, mf) {
                var row = Row(
                  children: [Text(mf.field), const Spacer(), Text(mf.value)],
                );
                rows.add(row);
                if (index < marketFields.length - 1) {
                  rows.add(const Divider(
                    color: Colors.black12,
                  ));
                }
              });
            }
          } else {
            rows.add(const CircularProgressIndicator());
          }
          return Column(
            children: rows,
          );
        });
  }
}

class MarketField {
  final String field;
  final String value;

  MarketField(this.field, this.value);
}