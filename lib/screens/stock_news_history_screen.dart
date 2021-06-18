import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/apis/stock_news_api.dart';
import 'package:trinistocks_flutter/apis/stock_price_api.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:trinistocks_flutter/widgets/stock_news_paginated_datatable.dart';
import 'package:trinistocks_flutter/widgets/stock_price_candlestick_chart.dart';
import 'package:loading_overlay/loading_overlay.dart';

class StockNewsHistoryPage extends StatefulWidget {
  StockNewsHistoryPage({Key? key}) : super(key: key);

  @override
  _StockNewsHistoryPageState createState() => _StockNewsHistoryPageState();
}

class _StockNewsHistoryPageState extends State<StockNewsHistoryPage> {
  List<Color> generatedColors = <Color>[];
  String selectedSymbol = 'AGL';
  String dateRange = StockNewsDateRange.oneYear;
  double buttonBarLabelSize = 16;
  bool symbolDropdownButtonBuilt = false;
  List<DropdownMenuItem<String>> listedSymbols = [];
  bool _loading = true;
  Widget stockNewsTable = Text("");

  @override
  void initState() {
    ListedStocksAPI.fetchListedStockSymbols().then((List<String> symbols) {
      for (String symbol in symbols) {
        listedSymbols.add(
          new DropdownMenuItem<String>(
            value: symbol,
            child: Text(
              symbol,
              style: TextStyle(fontSize: buttonBarLabelSize),
            ),
          ),
        );
      }
      updateStockNewsTable(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock News'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        children: [
                          Text(
                            "Symbol",
                            style: TextStyle(
                              fontSize: buttonBarLabelSize,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 5, bottom: 5, left: 5, right: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              height: 30,
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: buildSymbolDropdownButton(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        children: [
                          Text(
                            "Range",
                            style: TextStyle(
                              fontSize: buttonBarLabelSize,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 5, bottom: 5, left: 5, right: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              height: 30,
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: startDateDropdownButton(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            stockNewsTable,
          ],
        ),
        isLoading: _loading,
      ),
    );
  }

  void updateStockNewsTable(BuildContext context) {
    StockNewsAPI.fetchStockNews(selectedSymbol, dateRange)
        .then((List<Map> stockData) {
      stockNewsTable = new StockNewsPaginatedDataTable(
        stockData,
      );
      setState(() {
        _loading = false;
      });
    });
  }

  Widget buildSymbolDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: this.selectedSymbol,
      icon: FaIcon(
        FontAwesomeIcons.chevronDown,
      ),
      items: listedSymbols,
      underline: Text(""),
      onChanged: (String? newValue) {
        setState(() {
          _loading = true;
          selectedSymbol = newValue!;
          updateStockNewsTable(context);
        });
      },
    );
  }

  Widget startDateDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: dateRange,
      icon: FaIcon(
        FontAwesomeIcons.chevronDown,
      ),
      items: [
        new DropdownMenuItem<String>(
          value: StockNewsDateRange.oneYear,
          child: Text(
            StockNewsDateRange.oneYear,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: StockNewsDateRange.fiveYears,
          child: Text(
            StockNewsDateRange.fiveYears,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: StockNewsDateRange.tenYears,
          child: Text(
            StockNewsDateRange.tenYears,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
      ],
      underline: Text(""),
      onChanged: (String? newValue) {
        setState(() {
          _loading = true;
          dateRange = newValue!;
          updateStockNewsTable(context);
        });
      },
    );
  }
}
