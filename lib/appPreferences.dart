import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {

  final String _prefFollowedCoins = 'followed_coins';

  void saveFollowedCoin(String coinId){
    SharedPreferences.getInstance().then((prefs) {
      var coins = prefs.getStringList(_prefFollowedCoins) ?? [];
      coins.add(coinId);
      prefs.setStringList(_prefFollowedCoins, coins);
    });
  }

  void deleteFollowedCoin(String coinId){
    SharedPreferences.getInstance().then((prefs) {
      var coins = prefs.getStringList(_prefFollowedCoins) ?? [];
      coins.remove(coinId);
      prefs.setStringList(_prefFollowedCoins, coins);
    });
  }

  Future<List<String>> retrieveAllCoins() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_prefFollowedCoins) ?? [];
  }

}