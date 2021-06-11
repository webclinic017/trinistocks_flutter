/// Horizontal bar chart example
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class DailyTradesHorizontalBarChart extends StatelessWidget {
  final List inputData;
  final bool? animate;

  DailyTradesHorizontalBarChart(this.inputData, {this.animate});

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new SfCartesianChart(
      series: _createSeriesFromData(),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
        title: AxisTitle(
          text: "Value Traded (TT\$)",
        ),
      ),
    );
  }

  List<BarSeries<DailyTrades, String>> _createSeriesFromData() {
    List<DailyTrades> parsedData = <DailyTrades>[];
    for (int i = 0; i < inputData.length; i++) {
      final valueTraded =
          new DailyTrades(inputData[i]['symbol'], inputData[i]['value_traded']);
      parsedData.add(valueTraded);
    }
    parsedData = new List.from(parsedData.reversed);
    return <BarSeries<DailyTrades, String>>[
      BarSeries<DailyTrades, String>(
        dataSource: parsedData,
        xValueMapper: (DailyTrades trade, _) => trade.symbol,
        yValueMapper: (DailyTrades trade, _) => trade.valueTraded,
        color: Colors.teal,
      )
    ];
  }
}

//class for daily trade data returned by the api
class DailyTrades {
  final String symbol;
  final double valueTraded;

  DailyTrades(this.symbol, this.valueTraded);
}
