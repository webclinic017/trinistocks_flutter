import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/apis/stock_price_api.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:trinistocks_flutter/widgets/stock_price_candlestick_chart.dart';

class StockPriceHistoryPage extends StatefulWidget {
  StockPriceHistoryPage({Key? key}) : super(key: key);

  @override
  _StockPriceHistoryPageState createState() => _StockPriceHistoryPageState();
}

class _StockPriceHistoryPageState extends State<StockPriceHistoryPage> {
  List<Color> generatedColors = <Color>[];
  String selectedSymbol = 'AGL';
  String dateRange = StockPriceDateRange.oneYear;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Price History'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          FutureBuilder<List<Map>>(
            //make the API call
            future:
                StockPriceAPI.fetchStockPriceData(selectedSymbol, dateRange),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new StockPriceCandlestickChart(snapshot.data!);
              } //while the data is loading, return a progress indicator
              else
                return new LoadingWidget(
                    loadingText: 'Loading stock price data.');
            },
          ),
          FutureBuilder<List<String>>(
            //make the API call
            future: ListedStocksAPI.fetchListedStockSymbols(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Symbol:",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        symbolDropdownButton(context, snapshot.data!),
                      ],
                    )
                  ],
                );
              } //while the data is loading, return a progress indicator
              else
                return new LoadingWidget(
                    loadingText: 'Loading stock price data.');
            },
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getListedSymbols(
      BuildContext context, List<String> symbols) {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      new DropdownMenuItem<String>(
        value: 'AGL',
        child: Text(
          'AGL',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
    );
    list.add(
      new DropdownMenuItem(
        value: 'helloji2',
        child: Text(
          'helloji2',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
    );
    return list;
  }

  Widget symbolDropdownButton(BuildContext context, List<String> symbols) {
    return DropdownButton<String>(
      value: this.selectedSymbol,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).accentColor,
      ),
      items: getListedSymbols(context, symbols),
      underline: Container(
        height: 2,
        color: Theme.of(context).splashColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedSymbol = newValue!;
        });
      },
    );
  }
}
