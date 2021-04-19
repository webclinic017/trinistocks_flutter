// @dart=2.9
import 'package:flutter/material.dart';
import 'package:trinistocks_flutter/screens/listed_stocks.dart';
import 'screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(TriniStocks());
}

class TriniStocks extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'trinistocks',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red[900],
        accentColor: Colors.red[900],
        cardColor: Colors.grey[400],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red[900],
        accentColor: Colors.red[900],
      ),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => HomePage(),
        '/listed_stocks': (context) => ListedStocksPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
    );
  }
}
