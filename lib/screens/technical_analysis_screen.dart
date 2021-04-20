import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/apis/technical_analysis_api.dart';
import 'package:trinistocks_flutter/widgets/listed_stocks_datatable.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:trinistocks_flutter/widgets/technical_analysis_datatable.dart';

class TechnicalAnalysisPage extends StatefulWidget {
  TechnicalAnalysisPage({Key? key}) : super(key: key);

  @override
  _TechnicalAnalysisPageState createState() => _TechnicalAnalysisPageState();
}

class _TechnicalAnalysisPageState extends State<TechnicalAnalysisPage> {
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
        title: Text('Technical Analysis'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: ListView(padding: const EdgeInsets.all(10.0), children: [
        FutureBuilder<List<Map>>(
          //make the API call
          future: TechnicalAnalysisAPI.fetchLatestTechnicalAnalysisData(),
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return new Column(children: <Widget>[
                Text(
                  "Technical Analysis Summary",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  height: 1000.0,
                  child: TechnicalAnalysisDataTable(
                    tableData: snapshot.data!,
                  ),
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
                        'Now loading latest listed stock data.',
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
