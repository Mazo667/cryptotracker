import 'package:cryptotracker/appPreferences.dart';
import 'package:cryptotracker/app_state.dart';
import 'package:cryptotracker/screens/coins_list_screen.dart';
import 'package:cryptotracker/screens/following_coins_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crypto Tracker',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  void initState() {
    loadFollowedCoin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/images/ic_cryptotr.png',width: 30),
            const Padding(padding: EdgeInsets.only(right: 3,left: 3)),
            const Text("Crypto Tracker"),
            const SizedBox(width: 40),
            Row(
              children: [
                Image.asset('assets/images/coingecko_logo.png',width: 30),
                const Text("Powered by CoinGecko",style: TextStyle(fontSize: 11))
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: _currentIndex == 0 ? const CoinsListScreen() : const FollowingCoinsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.currency_bitcoin), label: "Coins"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Following"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void loadFollowedCoin() {
    AppPreferences().retrieveAllCoins().then((coinsList) {
      var appState = Provider.of<AppState>(context,listen: false);
      appState.followedCoinsIds = coinsList;
    });
  }
}
