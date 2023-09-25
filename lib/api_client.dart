import 'dart:convert';

import 'package:cryptotracker/models.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static const baseUrl = "https://api.coingecko.com/api/v3/";

  Future<Coin> getCoin(String coinId, {bool localization = false}) async {
    final response = await http.get(Uri.parse(
        "${baseUrl}coins/${coinId}?localization=$localization&tickers=false&market_data=true&community_data=false&developer_data=false"));
    if (response.statusCode == 200) {
      return Coin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error getting Coin");
    }
  }

  Future<List<Coin>> getCoins(List<String> consIds) async {
    List<Coin> coins = [];
    for (String id in consIds) {
      var coin = await getCoin(id);
      coins.add(coin);
    }
    return coins;
  }
}
