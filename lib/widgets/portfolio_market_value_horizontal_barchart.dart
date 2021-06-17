/// Horizontal bar chart example
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PortfolioMarketValueHorizontalBarChart extends StatelessWidget {
  final List inputData;
  final bool? animate;

  PortfolioMarketValueHorizontalBarChart(this.inputData, {this.animate});

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new SfCartesianChart(
      title: ChartTitle(text: "Symbols By Market Value"),
      series: _createSeriesFromData(),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
        title: AxisTitle(
          text: "Market Value (TT\$)",
        ),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<BarSeries<MarketValueData, String>> _createSeriesFromData() {
    List<MarketValueData> parsedData = <MarketValueData>[];
    for (int i = 0; i < inputData.length; i++) {
      final marketvalueData = new MarketValueData(
          inputData[i]['symbol'], inputData[i]['market_value']);
      parsedData.add(marketvalueData);
    }
    parsedData = new List.from(parsedData.reversed);
    return <BarSeries<MarketValueData, String>>[
      BarSeries<MarketValueData, String>(
        name: 'Symbol Market Values',
        dataSource: parsedData,
        xValueMapper: (MarketValueData trade, _) => trade.symbol,
        yValueMapper: (MarketValueData trade, _) => trade.marketValue,
        color: Colors.teal,
      )
    ];
  }
}

//class for daily trade data returned by the api
class MarketValueData {
  final String symbol;
  final double marketValue;

  MarketValueData(this.symbol, this.marketValue);
}
