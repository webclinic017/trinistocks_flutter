import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../apis/dailytrades.dart';
import '../widgets/daily_trades_horizontal_barchart.dart';
import '../widgets/daily_trades_datatable.dart';

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
      //setup a futurebuilder to wait on the API data
      body: FutureBuilder<Map>(
        //make the API call
        future: FetchDailyTrades.fetchLatestTrades(),
        initialData: Map(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.containsKey('date')) {
            return new ListView(
                padding: const EdgeInsets.all(10.0),
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
                  DailyTradesDataTable(),
                ]);
          } else
            return Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Please wait while we load the latest data from our backend.',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
        },
      ),
    );
  }
}
