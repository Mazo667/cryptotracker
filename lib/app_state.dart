import 'package:cryptotracker/appPreferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier{
  List<String> _followedCoindIds = [];

  List<String> get followedCoinsIds => _followedCoindIds;

  set followedCoinsIds(List<String> coinsIds){
    _followedCoindIds = coinsIds;
    notifyListeners();
  }

  void add(String coinId){
    _followedCoindIds.add(coinId);
    notifyListeners();
    AppPreferences().saveFollowedCoin(coinId);
  }

  void remove(String coinId){
    _followedCoindIds.remove(coinId);
    notifyListeners();
    AppPreferences().deleteFollowedCoin(coinId);
  }
}