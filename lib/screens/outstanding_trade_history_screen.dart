import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/apis/market_indexes_api.dart';
import 'package:trinistocks_flutter/apis/outstanding_trades_api.dart';
import 'package:trinistocks_flutter/apis/stock_price_api.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:trinistocks_flutter/widgets/market_index_line_chart.dart';
import 'package:trinistocks_flutter/widgets/market_trades_line_chart.dart';
import 'package:trinistocks_flutter/widgets/outstanding_prices_chart.dart';
import 'package:trinistocks_flutter/widgets/outstanding_volume_chart.dart';
import 'package:trinistocks_flutter/widgets/stock_price_candlestick_chart.dart';
import 'package:loading_overlay/loading_overlay.dart';

class OutstandingTradesHistoryPage extends StatefulWidget {
  OutstandingTradesHistoryPage({Key? key}) : super(key: key);

  @override
  _OutstandingTradesHistoryPageState createState() =>
      _OutstandingTradesHistoryPageState();
}

class _OutstandingTradesHistoryPageState
    extends State<OutstandingTradesHistoryPage> {
  List<Color> generatedColors = <Color>[];
  String selectedSymbol = 'AGL';
  String dateRange = MarketIndexDateRange.oneYear;
  double buttonBarLabelSize = 14;
  bool symbolDropdownButtonBuilt = false;
  List<DropdownMenuItem<String>> listedSymbols = [];
  bool _loading = true;
  Widget outstandingPriceChart = Text("");
  Widget outstandingVolumeChart = Text("");

  @override
  void initState() {
    ListedStocksAPI.fetchListedStockSymbols().then((List<String> symbols) {
      for (String symbol in symbols) {
        listedSymbols.add(
          new DropdownMenuItem<String>(
            value: symbol,
            child: Text(
              symbol,
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: buttonBarLabelSize),
            ),
          ),
        );
      }
      updateOutstandingTradeDataCharts(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outstanding Trades'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "Index:",
                    style: TextStyle(fontSize: buttonBarLabelSize),
                  ),
                ),
                buildSymbolDropdownButton(context),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "Range:",
                    style: TextStyle(fontSize: buttonBarLabelSize),
                  ),
                ),
                startDateDropdownButton(context),
              ],
            ),
            outstandingPriceChart,
            outstandingVolumeChart,
          ],
        ),
        isLoading: _loading,
      ),
    );
  }

  Widget buildSymbolDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: this.selectedSymbol,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).accentColor,
      ),
      items: listedSymbols,
      underline: Container(
        height: 2,
        color: Theme.of(context).splashColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _loading = true;
          selectedSymbol = newValue!;
          updateOutstandingTradeDataCharts(context);
        });
      },
    );
  }

  void updateOutstandingTradeDataCharts(BuildContext context) {
    OutstandingTradesAPI.fetchOutstandingTradeData(selectedSymbol, dateRange)
        .then((List outstandingTradeData) {
      outstandingPriceChart = OutstandingPricesAreaChart(
        outstandingTradeData,
        animate: true,
      );
      outstandingVolumeChart = OutstandingVolumeChart(
        outstandingTradeData,
        animate: true,
      );
      setState(() {
        _loading = false;
      });
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
          value: OutstandingTradesRange.oneWeek,
          child: Text(
            OutstandingTradesRange.oneWeek,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: OutstandingTradesRange.oneMonth,
          child: Text(
            OutstandingTradesRange.oneMonth,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: OutstandingTradesRange.oneYear,
          child: Text(
            OutstandingTradesRange.oneYear,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
      ],
      underline: Container(
        height: 2,
        color: Theme.of(context).splashColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _loading = true;
          dateRange = newValue!;
          updateOutstandingTradeDataCharts(context);
        });
      },
    );
  }

  Widget buildIndexNameDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: selectedSymbol,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).accentColor,
      ),
      items: [
        new DropdownMenuItem<String>(
          value: 'Composite Totals',
          child: Text(
            'Composite Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'All T%26T Totals',
          child: Text(
            'All T&T Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Cross-Listed Totals',
          child: Text(
            'Cross-Listed Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Mutual Funds Totals',
          child: Text(
            'Mutual Funds Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Second Tier Totals',
          child: Text(
            'Second Tier Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Non Sector Totals',
          child: Text(
            'Non Sector Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Usd Equity Totals',
          child: Text(
            'USD Equity Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
      ],
      underline: Container(
        height: 2,
        color: Theme.of(context).splashColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _loading = true;
          selectedSymbol = newValue!;
          updateOutstandingTradeDataCharts(context);
        });
      },
    );
  }
}
