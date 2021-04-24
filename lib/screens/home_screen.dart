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

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ColorHue colorHue = ColorHue.red;
    Color headerColor = RandomColor().randomColor(
        colorHue: colorHue,
        colorSaturation: ColorSaturation.lowSaturation,
        colorBrightness: ColorBrightness.dark);
    Color leftHandColor = RandomColor().randomColor(
        colorHue: colorHue,
        colorSaturation: ColorSaturation.lowSaturation,
        colorBrightness: ColorBrightness.light);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: ListView(padding: const EdgeInsets.all(10.0), children: [
        FutureBuilder<List>(
          //make the API call
          future: MarketIndexesAPI.fetchLast30Days(),
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return new Column(children: <Widget>[
                Text(
                  "TTSE Trailing 30-Day Composite Index",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 200.0,
                  child: MarketIndexesLineChart.withData(snapshot.data!),
                ),
              ]);
            } //while the data is loading, return a progress indicator
            else
              return LoadingWidget(
                  loadingText: 'Now loading market index data');
          },
        ),
        FutureBuilder<Map>(
          //make the API call
          future: FetchDailyTradesAPI.fetchLatestTrades(),
          initialData: Map(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.containsKey('date')) {
              return new Column(
                children: <Widget>[
                  Text(
                    "Stocks Traded on the TTSE on ${snapshot.data!['date']}",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 400.0,
                    child: DailyTradesHorizontalBarChart.withData(
                        snapshot.data!['chartData']),
                  ),
                  DailyTradesDataTable(
                    tableData: snapshot.data!['tableData'],
                    headerColor: headerColor,
                    leftHandColor: leftHandColor,
                  ),
                ],
              );
            } //while the data is loading, return a progress indicator
            else
              return LoadingWidget(
                  loadingText: 'Now loading daily trades data');
          },
        ),
        FutureBuilder<List<Map>>(
          //make the API call
          future: StockNewsAPI.fetch10LatestNews(),
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return new Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(children: <Widget>[
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
                    tableData: snapshot.data!,
                    headerColor: headerColor,
                    leftHandColor: leftHandColor,
                  ),
                ]),
              );
            } else
              return LoadingWidget(loadingText: 'Now loading stock news data');
          },
        ),
      ]),
    );
  }
}
