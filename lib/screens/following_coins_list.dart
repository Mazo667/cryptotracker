import 'package:cryptotracker/api_client.dart';
import 'package:cryptotracker/app_state.dart';
import 'package:cryptotracker/models.dart';
import 'package:cryptotracker/widget/coin_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowingCoinsScreen extends StatefulWidget {
  const FollowingCoinsScreen({super.key});

  @override
  State<FollowingCoinsScreen> createState() => _FollowingCoinsScreenState();
}

class _FollowingCoinsScreenState extends State<FollowingCoinsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, appState, Widget? child){
        return FutureBuilder<List<Coin>>(
          future: getFollowedCoins(appState),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            List<Coin>? coins = snapshot.data;
            if (coins == null) {
              throw Exception("Error getting Coin");
            } else {
              if(coins.isEmpty){
                return const Center(child: Text("Aun no estas siguiendo ninguna moneda",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20)));
              }
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
      },
    );
  }

  Future<List<Coin>> getFollowedCoins(AppState appState) async {
    var coinsIds = appState.followedCoinsIds;
    
   return ApiClient().getCoins(coinsIds);
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
                onUnFollowingCoin(context,coin.id);
              },
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white70,
              icon: Icons.favorite,
              label: 'No seguir',
              borderRadius: BorderRadius.circular(25),
            )
          ],
        ),
        child: CoinItem(coin: coin)
    );
  }

  void onUnFollowingCoin(BuildContext context, String coinId) async {
    var appState = Provider.of<AppState>(context,listen: false);
    appState.remove(coinId);
  }
}
