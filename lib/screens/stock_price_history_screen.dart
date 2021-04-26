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
  double buttonBarLabelSize = 16;
  bool symbolDropdownButtonBuilt = false;
  late List<DropdownMenuItem<String>> listedSymbols;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        padding: const EdgeInsets.all(0.0),
        children: [
          FutureBuilder<List<String>>(
            //make the API call
            future: ListedStocksAPI.fetchListedStockSymbols(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "Symbol:",
                        style: TextStyle(fontSize: buttonBarLabelSize),
                      ),
                    ),
                    symbolDropdownButton(context, snapshot.data!),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Range:",
                        style: TextStyle(fontSize: buttonBarLabelSize),
                      ),
                    ),
                    startDateDropdownButton(context),
                  ],
                );
              } //while the data is loading, return a progress indicator
              else
                return new LoadingWidget(
                    loadingText: 'Loading all listed symbols.');
            },
          ),
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
        ],
      ),
    );
  }

  Future<List<DropdownMenuItem<String>>> getListedSymbols(
      BuildContext context, List<String> symbols) async {
    List<DropdownMenuItem<String>> dropdownList = [];
    for (String symbol in symbols) {
      dropdownList.add(
        new DropdownMenuItem<String>(
          value: symbol,
          child: Text(
            symbol,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
      );
    }
    return dropdownList;
  }

  Widget symbolDropdownButton(BuildContext context, List<String> symbols) {
    return FutureBuilder<List<DropdownMenuItem<String>>>(
        future: getListedSymbols(context, symbols),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DropdownButton<String>(
              value: this.selectedSymbol,
              icon: FaIcon(
                FontAwesomeIcons.arrowAltCircleDown,
                color: Theme.of(context).accentColor,
              ),
              items: snapshot.data,
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
          } else {
            return DropdownButton<String>(
              value: this.selectedSymbol,
              icon: FaIcon(
                FontAwesomeIcons.arrowAltCircleDown,
                color: Theme.of(context).accentColor,
              ),
              items: [],
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
        });
  }

  Widget startDateDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: dateRange,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).accentColor,
      ),
      items: [
        new DropdownMenuItem<String>(
          value: StockPriceDateRange.oneMonth,
          child: Text(StockPriceDateRange.oneMonth),
        ),
        new DropdownMenuItem<String>(
          value: StockPriceDateRange.oneYear,
          child: Text(StockPriceDateRange.oneYear),
        ),
        new DropdownMenuItem<String>(
          value: StockPriceDateRange.fiveYears,
          child: Text(StockPriceDateRange.fiveYears),
        ),
        new DropdownMenuItem<String>(
          value: StockPriceDateRange.tenYears,
          child: Text(StockPriceDateRange.tenYears),
        ),
      ],
      underline: Container(
        height: 2,
        color: Theme.of(context).splashColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dateRange = newValue!;
        });
      },
    );
  }
}
