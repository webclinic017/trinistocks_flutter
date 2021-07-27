// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trinistocks_flutter/screens/dividend_history_screen.dart';
import 'package:trinistocks_flutter/screens/portfolio_summary_screen.dart';
import 'package:trinistocks_flutter/screens/portfolio_transactions_screen.dart';
import 'package:trinistocks_flutter/screens/simulator_create_game_screen.dart';
import 'package:trinistocks_flutter/screens/simulator_game_rankings_screen.dart';
import 'package:trinistocks_flutter/screens/simulator_games_summary_screen.dart';
import 'package:trinistocks_flutter/screens/simulator_join_game_screen.dart';
import 'package:trinistocks_flutter/screens/simulator_portfolio_summary_screen.dart';
import 'package:trinistocks_flutter/screens/simulator_transactions_screen.dart';
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
    TriniStocks(),
  );
}

class TriniStocks extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'trinistocks',
      theme: FlexColorScheme.light(scheme: FlexScheme.green).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.green).toTheme,
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
        '/portfolio_summary': (context) => PortfolioSummaryPage(),
        '/portfolio_transactions': (context) => PortfolioTransactionsPage(),
        '/simulator_games': (context) => SimulatorGamesPage(),
        '/simulator_game_create': (context) => SimulatorGameCreatePage(),
        '/simulator_game_join': (context) => SimulatorJoinGamePage(),
        '/simulator_portfolio_summary': (context) =>
            SimulatorPortfolioSummaryPage(),
        '/simulator_transactions': (context) => SimulatorTransactionsPage(),
        '/simulator_games_rankings': (context) => SimulatorGamesRankingsPage(),
      },
    );
  }
}
