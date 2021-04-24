import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_color/random_color.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/apis/technical_analysis_api.dart';
import 'package:trinistocks_flutter/widgets/listed_stocks_datatable.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
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
    List<Color> generatedColors = <Color>[];
    return Scaffold(
      appBar: AppBar(
        title: Text('Technical Analysis'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: ListView(padding: const EdgeInsets.all(10.0), children: [
        FutureBuilder<Map>(
          //make the API call
          future: TechnicalAnalysisAPI.fetchLatestTechnicalAnalysisData(),
          initialData: Map(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              Color? headerColor;
              Color? leftHandColor;
              while (generatedColors.length < snapshot.data!.keys.length * 2) {
                ColorHue colorHue = ColorHue.red;
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
                double height = 80 + dataLength * 50;
                tables.add(
                  SizedBox(
                    height: height,
                    child: new TechnicalAnalysisDataTable(
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
                  loadingText: 'Now loading technical analysis data.');
          },
        ),
      ]),
    );
  }
}
