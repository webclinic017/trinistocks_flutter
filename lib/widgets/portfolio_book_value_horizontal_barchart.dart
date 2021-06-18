/// Horizontal bar chart example
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PortfolioBookValueHorizontalBarChart extends StatelessWidget {
  final List inputData;
  final bool? animate;

  PortfolioBookValueHorizontalBarChart(this.inputData, {this.animate});

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new SfCartesianChart(
      title: ChartTitle(text: "Symbols By Book Cost"),
      series: _createSeriesFromData(),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
        title: AxisTitle(
          text: "Book Cost (TT\$)",
        ),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<BarSeries<MarketValueData, String>> _createSeriesFromData() {
    List<MarketValueData> parsedData = <MarketValueData>[];
    for (int i = 0; i < inputData.length; i++) {
      final marketvalueData = new MarketValueData(
          inputData[i]['symbol'], inputData[i]['book_cost']);
      parsedData.add(marketvalueData);
    }
    parsedData = new List.from(parsedData.reversed);
    return <BarSeries<MarketValueData, String>>[
      BarSeries<MarketValueData, String>(
        animationDuration: 0,
        name: 'Symbol Book Values',
        dataSource: parsedData,
        xValueMapper: (MarketValueData trade, _) => trade.symbol,
        yValueMapper: (MarketValueData trade, _) => trade.bookValue,
        color: Colors.amber,
      )
    ];
  }
}

//class for daily trade data returned by the api
class MarketValueData {
  final String symbol;
  final double bookValue;

  MarketValueData(this.symbol, this.bookValue);
}
