import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:trinistocks_flutter/widgets/stock_news_datatable.dart';
import '../apis/dailytrades.dart';
import '../apis/stocknews.dart';
import '../apis/marketindexes.dart';
import '../widgets/daily_trades_horizontal_barchart.dart';
import '../widgets/market_indexes_linechart.dart';
import '../widgets/daily_trades_datatable.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 120,
              child: DrawerHeader(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white),
                ),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
              ),
            ),
            Card(
              color: Theme.of(context).cardColor,
              child: ListTile(
                leading: Icon(
                  Icons.house,
                  color: Theme.of(context).accentColor,
                  size: 30.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                title: Text('Home'),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
            ),
            Container(
              color: Colors.grey[300],
              child: ExpansionTile(
                title: Text("Hello"),
              ), /*or any other widget you want to apply the theme to.*/
            ),
          ],
        ),
      ),
      //setup futurebuilders to wait on the API data
      body: ListView(padding: const EdgeInsets.all(10.0), children: [
        FutureBuilder<List>(
          //make the API call
          future: MarketIndexes.fetchLast30Days(),
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return new Column(children: <Widget>[
                Text(
                  "TTSE Trailing 30-Day Composite Index",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 200.0,
                  child: MarketIndexesLineChart.withData(snapshot.data!),
                ),
              ]);
            } //while the data is loading, return a progress indicator
            else
              return Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.redAccent),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Now loading latest market indexes.',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
        FutureBuilder<Map>(
          //make the API call
          future: FetchDailyTrades.fetchLatestTrades(),
          initialData: Map(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.containsKey('date')) {
              return new Column(
                children: <Widget>[
                  Text(
                    "Stocks Traded on the TTSE on ${snapshot.data!['date']}",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 400.0,
                    child: DailyTradesHorizontalBarChart.withData(
                        snapshot.data!['chartData']),
                  ),
                  DailyTradesDataTable(tableData: snapshot.data!['tableData']),
                ],
              );
            } //while the data is loading, return a progress indicator
            else
              return Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.redAccent),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Now loading daily trade data.',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
        FutureBuilder<List<Map>>(
          //make the API call
          future: StockNews.fetch10LatestNews(),
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
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  StockNewsDataTable(tableData: snapshot.data!),
                ]),
              );
            } else
              return Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.redAccent),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Now loading stock news data.',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
      ]),
    );
  }
}
