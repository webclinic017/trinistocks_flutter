import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_color/random_color.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:trinistocks_flutter/widgets/stock_news_datatable.dart';
import '../apis/daily_trades_api.dart';
import '../apis/stock_news_api.dart';
import '../apis/market_indexes_api.dart';
import '../widgets/daily_trades_horizontal_barchart.dart';
import '../widgets/market_indexes_linechart.dart';
import '../widgets/daily_trades_datatable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Widget marketIndexesLineChart =
      LoadingWidget(loadingText: 'Now loading market index data');
  Widget headlineText =
      LoadingWidget(loadingText: 'Now loading daily trades data');
  Widget latestTradesBarChart = Text("");
  Widget latestTradesTable = Text("");
  Widget stockNewsTable =
      LoadingWidget(loadingText: 'Now loading stock news data');
  ColorHue colorHue = ColorHue.green;
  late Color headerColor;
  late Color leftHandColor;

  void _onRefresh() async {
    updateAllWidgets();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    headerColor = RandomColor().randomColor(
        colorHue: colorHue,
        colorSaturation: ColorSaturation.lowSaturation,
        colorBrightness: ColorBrightness.dark);
    leftHandColor = RandomColor().randomColor(
        colorHue: colorHue,
        colorSaturation: ColorSaturation.lowSaturation,
        colorBrightness: ColorBrightness.light);
    updateAllWidgets();
    new Timer.periodic(
        Duration(minutes: 15),
        (Timer t) => setState(() {
              updateAllWidgets();
            }));
  }

  void updateAllWidgets() {
    MarketIndexesAPI.fetchMarketIndexData(
            MarketIndexDateRange.oneMonth, "Composite Totals")
        .then((value) {
      setState(() {
        marketIndexesLineChart = MarketIndexesLineChart.withData(value);
      });
    });
    FetchDailyTradesAPI.fetchLatestTrades().then((value) {
      setState(() {
        headlineText = Text(
          "Stocks Traded on the TTSE on ${value['date']}",
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
          style: Theme.of(context).textTheme.headline6,
        );
        latestTradesBarChart = SizedBox(
          height: 400.0,
          child: DailyTradesHorizontalBarChart.withData(value['chartData']),
        );
        latestTradesTable = DailyTradesDataTable(
          tableData: value['tableData'],
          headerColor: headerColor,
          leftHandColor: leftHandColor,
        );
      });
    });
    StockNewsAPI.fetch10LatestNews().then((value) {
      setState(() {
        stockNewsTable = Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    "Latest Stock News",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  StockNewsDataTable(
                    tableData: value,
                    headerColor: headerColor,
                    leftHandColor: leftHandColor,
                  ),
                ],
              ),
            ),
          ],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _onRefresh,
        child: ListView(padding: const EdgeInsets.all(10.0), children: [
          Text(
            "TTSE 30-Day Composite Index",
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 200.0,
            child: marketIndexesLineChart,
          ),
          headlineText,
          latestTradesBarChart,
          latestTradesTable,
          stockNewsTable,
        ]),
      ),
    );
  }
}
