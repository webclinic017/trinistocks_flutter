/// Horizontal bar chart example
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import '../apis/dailytrades.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<Series<dynamic, String>>? seriesList;
  final bool? animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChart.withSampleData() {
    return new HorizontalBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      behaviors: [
        new ChartTitle('Price Volume (TTD\$)',
            titleStyleSpec: TextStyleSpec(
                color: MaterialPalette.black,
                fontFamily: 'Roboto',
                fontSize: 12),
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.middleDrawArea,
            innerPadding: 15),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  static List<Series<DailyTrades, String>>? _createDailyTradesData(
      List valuesTraded) {
    List<DailyTrades> parsedData = [];
    for (int i = 0; i < valuesTraded.length; i++) {
      final valueTraded = new DailyTrades(
          valuesTraded[i]['symbol'], valuesTraded[i]['value_traded']);
      parsedData.add(valueTraded);
    }
    List<Series<DailyTrades, String>> returnSeries = [
      new Series<DailyTrades, String>(
        id: 'Daily Trades',
        domainFn: (DailyTrades trade, _) => trade.symbol,
        measureFn: (DailyTrades trade, _) => trade.valueTraded,
        data: parsedData,
      )
    ];
    return returnSeries;
  }

  /// Setup the data for the latest daily trades bar chart
  static Widget withLatestDailyTradesData() {
    return new FutureBuilder<Map>(
      future: FetchDailyTrades.fetchLatestTrades(),
      initialData: Map(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.containsKey('date')) {
          return new Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(children: <Widget>[
              Text(
                "Stocks Traded on the TTSE on ${snapshot.data!['date']}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 400.0,
                child: HorizontalBarChart(
                  _createDailyTradesData(snapshot.data!['valuesTraded']),
                  // Disable animations for image tests.
                  animate: true,
                ),
              ),
            ]),
          );
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
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

//class for daily trade data returned by the api
class DailyTrades {
  final String symbol;
  final double valueTraded;

  DailyTrades(this.symbol, this.valueTraded);
}
