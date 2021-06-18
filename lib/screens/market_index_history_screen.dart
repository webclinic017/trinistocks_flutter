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
                            "Index",
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
                              child: buildIndexNameDropdownButton(context),
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
            marketIndexChartBuilt ? marketIndexChart : Text(""),
            marketTradesChartBuilt ? marketTradesChart : Text(""),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).buttonColor),
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
        animate: false,
      );
      marketTradesChart = MarketTradesLineChart(
        indexData,
        animate: false,
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
        FontAwesomeIcons.chevronDown,
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
      underline: Text(""),
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
        FontAwesomeIcons.chevronDown,
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
      underline: Text(""),
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
