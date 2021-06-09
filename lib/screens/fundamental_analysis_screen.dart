import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:trinistocks_flutter/apis/fundamental_analysis_api.dart';
import 'package:trinistocks_flutter/widgets/fundamental_analysis_datatable.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:random_color/random_color.dart';

class FundamentalAnalysisPage extends StatefulWidget {
  FundamentalAnalysisPage({Key? key}) : super(key: key);

  @override
  _FundamentalAnalysisPageState createState() =>
      _FundamentalAnalysisPageState();
}

class _FundamentalAnalysisPageState extends State<FundamentalAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    List<Color> generatedColors = <Color>[];
    return Scaffold(
      appBar: AppBar(
        title: Text('Fundamental Analysis'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: ListView(padding: const EdgeInsets.all(10.0), children: [
        FutureBuilder<Map>(
          //make the API call
          future: FundamentalAnalysisAPI
              .fetchLatestAuditedFundamentalAnalysisData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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
                double height = 80 + dataLength * 50;
                tables.add(
                  SizedBox(
                    height: height,
                    child: new FundamentalAnalysisDataTable(
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
                  loadingText: 'Loading fundamental analysis data.');
          },
        ),
      ]),
    );
  }
}
