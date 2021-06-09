import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_color/random_color.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/widgets/listed_stocks_datatable.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class ListedStocksPage extends StatefulWidget {
  ListedStocksPage({Key? key}) : super(key: key);

  @override
  _ListedStocksPageState createState() => _ListedStocksPageState();
}

class _ListedStocksPageState extends State<ListedStocksPage> {
  List<Color> generatedColors = <Color>[];
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
        title: Text('Listed Stocks'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: ListView(padding: const EdgeInsets.all(10.0), children: [
        FutureBuilder<Map>(
          //make the API call
          future: ListedStocksAPI.fetchAllListedStockData(),
          initialData: Map(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              Color? headerColor;
              Color? leftHandColor;
              while (generatedColors.length < snapshot.data!.keys.length * 2) {
                ColorHue colorHue = ColorHue.green;
                headerColor = RandomColor().randomColor(
                    colorHue: colorHue,
                    colorSaturation: ColorSaturation.lowSaturation,
                    colorBrightness: ColorBrightness.dark);
                leftHandColor = RandomColor().randomColor(
                    colorHue: colorHue,
                    colorSaturation: ColorSaturation.lowSaturation,
                    colorBrightness: ColorBrightness.light);
                generatedColors.add(headerColor);
                generatedColors.add(leftHandColor);
              }
              //when we get the APi response, build the tables
              List<Widget> tables = [];
              int index = 0;
              for (MapEntry e in snapshot.data!.entries) {
                headerColor = generatedColors[index];
                Color righthandColor = generatedColors[index + 1];
                //add a title for each table
                tables.add(
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      "${e.key} Stocks",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                );
                //find the number of rows for each table, and set the width of the sizedbox according to that
                int dataLength = (e.value as List).length;
                double height = 70 + dataLength * 50;
                tables.add(
                  SizedBox(
                    height: height,
                    child: new ListedStocksDataTable(
                      tableData: e.value,
                      headerColor: headerColor,
                      leftHandColor: righthandColor,
                    ),
                  ),
                );
                index = index + 2;
              }
              return new Column(
                children: tables,
              );
            } //while the data is loading, return a progress indicator
            else
              return LoadingWidget(
                  loadingText: 'Now loading listed stocks data.');
          },
        ),
      ]),
    );
  }
}
