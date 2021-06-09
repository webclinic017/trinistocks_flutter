import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/market_indexes_api.dart';
import 'package:trinistocks_flutter/apis/stock_price_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:trinistocks_flutter/widgets/market_indexes_linechart.dart';
import 'package:trinistocks_flutter/widgets/market_trades_line_chart.dart';
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
  late MarketIndexesLineChart marketIndexChart;
  bool marketIndexChartBuilt = false;
  late MarketTradesLineChart marketTradesChart;
  bool marketTradesChartBuilt = false;

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
            marketIndexChartBuilt ? marketIndexChart : Text(""),
            marketTradesChartBuilt ? marketTradesChart : Text(""),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: resetZoom,
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.searchMinus),
                      Text(" Reset Zoom")
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        isLoading: _loading,
      ),
    );
  }

  void resetZoom() {
    marketIndexChart.resetZoom();
    marketTradesChart.resetZoom();
  }

  void updateMarketIndexChart(BuildContext context) {
    MarketIndexesAPI.fetchMarketIndexData(dateRange, selectedIndexName)
        .then((List indexData) {
      marketIndexChart = MarketIndexesLineChart(
        indexData,
        selectedIndexName,
        animate: true,
      );
      marketTradesChart = MarketTradesLineChart(
        indexData,
        animate: true,
      );
      setState(() {
        marketIndexChartBuilt = true;
        marketTradesChartBuilt = true;
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
