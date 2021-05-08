import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/apis/market_indexes_api.dart';
import 'package:trinistocks_flutter/apis/stock_price_api.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:trinistocks_flutter/widgets/market_index_line_chart.dart';
import 'package:trinistocks_flutter/widgets/market_trades_line_chart.dart';
import 'package:trinistocks_flutter/widgets/stock_price_candlestick_chart.dart';
import 'package:loading_overlay/loading_overlay.dart';

class MarketIndexHistoryPage extends StatefulWidget {
  MarketIndexHistoryPage({Key? key}) : super(key: key);

  @override
  _MarketIndexHistoryPageState createState() => _MarketIndexHistoryPageState();
}

class _MarketIndexHistoryPageState extends State<MarketIndexHistoryPage> {
  List<Color> generatedColors = <Color>[];
  String selectedIndexName = 'Composite Totals';
  String dateRange = MarketIndexDateRange.oneYear;
  double buttonBarLabelSize = 14;
  bool symbolDropdownButtonBuilt = false;
  List<DropdownMenuItem<String>> marketIndexName = [];
  bool _loading = true;
  Widget marketIndexChart = Text("");
  Widget marketTradesChart = Text("");

  @override
  void initState() {
    updateMarketIndexChart(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Index History'),
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
                buildIndexNameDropdownButton(context),
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
            marketIndexChart,
            marketTradesChart,
          ],
        ),
        isLoading: _loading,
      ),
    );
  }

  void updateMarketIndexChart(BuildContext context) {
    MarketIndexesAPI.fetchMarketIndexData(dateRange, selectedIndexName)
        .then((List indexData) {
      marketIndexChart = MarketIndexLineChart(
        indexData,
        animate: true,
      );
      marketTradesChart = MarketTradesLineChart(
        indexData,
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
          value: StockPriceDateRange.oneMonth,
          child: Text(
            StockPriceDateRange.oneMonth,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: StockPriceDateRange.oneYear,
          child: Text(
            StockPriceDateRange.oneYear,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: StockPriceDateRange.fiveYears,
          child: Text(
            StockPriceDateRange.fiveYears,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: StockPriceDateRange.tenYears,
          child: Text(
            StockPriceDateRange.tenYears,
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
          updateMarketIndexChart(context);
        });
      },
    );
  }

  Widget buildIndexNameDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: selectedIndexName,
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
          selectedIndexName = newValue!;
          updateMarketIndexChart(context);
        });
      },
    );
  }
}
