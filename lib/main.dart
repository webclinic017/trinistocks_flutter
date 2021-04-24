// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'screens/fundamental_analysis_screen.dart';
import 'screens/listed_stocks_screen.dart';
import 'screens/technical_analysis_screen.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'screens/stock_price_history_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
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
        primaryColor: Colors.grey[400],
        accentColor: Colors.grey[900],
        cardColor: Colors.grey[400],
        shadowColor: Colors.grey[300],
        backgroundColor: Colors.grey[50],
        secondaryHeaderColor: Colors.black,
        splashColor: Colors.red,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        accentColor: Colors.grey[50],
        cardColor: Colors.grey[900],
        shadowColor: Colors.grey[850],
        backgroundColor: Colors.grey[800],
        secondaryHeaderColor: Colors.white,
        splashColor: Colors.red,
      ),
      routes: {
        '/': (context) => HomePage(),
        '/listed_stocks': (context) => ListedStocksPage(),
        '/technical_analysis': (context) => TechnicalAnalysisPage(),
        '/fundamental_analysis': (context) => FundamentalAnalysisPage(),
        '/stock_price_history': (context) => StockPriceHistoryPage(),
      },
    );
  }
}
