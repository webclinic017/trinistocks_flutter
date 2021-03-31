/// Horizontal bar chart example
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class DailyTradesHorizontalBarChart extends StatelessWidget {
  final List<Series<dynamic, String>>? seriesList;
  final bool? animate;

  DailyTradesHorizontalBarChart(this.seriesList, {this.animate});

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

  static List<Series<DailyTrades, String>>? _createSeriesFromData(
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
  static Widget withData(valuesTraded) {
    return new DailyTradesHorizontalBarChart(
      _createSeriesFromData(valuesTraded),
      // Disable animations for image tests.
      animate: true,
    );
  }
}

//class for daily trade data returned by the api
class DailyTrades {
  final String symbol;
  final double valueTraded;

  DailyTrades(this.symbol, this.valueTraded);
}
