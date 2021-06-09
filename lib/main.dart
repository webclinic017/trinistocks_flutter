// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trinistocks_flutter/models/login_model.dart';
import 'package:trinistocks_flutter/screens/dividend_history_screen.dart';
import 'screens/fundamental_analysis_history_screen.dart';
import 'screens/fundamental_analysis_screen.dart';
import 'screens/listed_stocks_screen.dart';
import 'screens/login_screen.dart';
import 'screens/market_index_history_screen.dart';
import 'screens/outstanding_trade_history_screen.dart';
import 'screens/stock_news_history_screen.dart';
import 'screens/technical_analysis_screen.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'screens/stock_price_history_screen.dart';
import 'screens/user_profile_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

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
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginModel(),
      child: TriniStocks(),
    ),
  );
}

class TriniStocks extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'trinistocks',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.grey[500],
        accentColor: Colors.grey[900],
        cardColor: Colors.grey[200],
        shadowColor: Colors.grey[300],
        backgroundColor: Colors.grey[50],
        secondaryHeaderColor: Colors.black,
        splashColor: Colors.green,
        highlightColor: Colors.green[800],
        hoverColor: Colors.orange[800],
        dividerColor: Colors.black,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        accentColor: Colors.grey[50],
        cardColor: Colors.grey[700],
        shadowColor: Colors.grey[850],
        backgroundColor: Colors.grey[800],
        secondaryHeaderColor: Colors.white,
        splashColor: Colors.green,
        highlightColor: Colors.green[200],
        hoverColor: Colors.orange[200],
        dividerColor: Colors.white,
        primarySwatch: Colors.green,
        textTheme: TextTheme(),
      ),
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/user_profile': (context) => UserProfilePage(),
        '/listed_stocks': (context) => ListedStocksPage(),
        '/technical_analysis': (context) => TechnicalAnalysisPage(),
        '/fundamental_analysis': (context) => FundamentalAnalysisPage(),
        '/stock_price_history': (context) => StockPriceHistoryPage(),
        '/dividend_history': (context) => DividendHistoryPage(),
        '/market_index_history': (context) => MarketIndexHistoryPage(),
        '/outstanding_trade_history': (context) =>
            OutstandingTradesHistoryPage(),
        '/stock_news_history': (context) => StockNewsHistoryPage(),
        '/fundamental_analysis_history': (context) =>
            FundamentalAnalysisHistoryPage(),
      },
    );
  }
}
