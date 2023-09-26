import 'package:cryptotracker/api_client.dart';
import 'package:cryptotracker/app_state.dart';
import 'package:cryptotracker/models.dart';
import 'package:cryptotracker/widget/coin_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';


class CoinsListScreen extends StatefulWidget {
  const CoinsListScreen({super.key});

  @override
  State<CoinsListScreen> createState() => _CoinsListScreenState();
}

class _CoinsListScreenState extends State<CoinsListScreen> {
  final List<String> _defaultCoins = ['bitcoin', 'ethereum', 'dai'];
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
                return CoinRow(
                  coin: coins[index],
                );
              });
        }
      },
    );
  }
}

class CoinRow extends StatelessWidget {
  final Coin coin;
  const CoinRow({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
              onPressed: (context) {
                onFollowingCoin(context,coin.id);
              },
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white70,
              icon: Icons.favorite,
              label: 'Seguir',
              borderRadius: BorderRadius.circular(25),
          )
        ],
      ),
        child: CoinItem(coin: coin)
    );
  }

  void onFollowingCoin(BuildContext context, String coinId) async {
    var appState = Provider.of<AppState>(context, listen: false);
    appState.add(coinId);
    }
}


