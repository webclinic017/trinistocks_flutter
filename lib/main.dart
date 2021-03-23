import 'package:flutter/material.dart';
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
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red[900],
        accentColor: Colors.red[900],
      ),
      home: HomePage(title: 'Home'),
    );
  }
}
