/// Horizontal bar chart example
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PortfolioGainLossHorizontalBarChart extends StatelessWidget {
  final List inputData;
  final bool? animate;

  PortfolioGainLossHorizontalBarChart(this.inputData, {this.animate});

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new SfCartesianChart(
      title: ChartTitle(text: "Gain/Loss Per Symbol"),
      series: _createSeriesFromData(),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
        title: AxisTitle(
          text: "Gain/Loss(%)",
        ),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<BarSeries<ChartDataPoints, String>> _createSeriesFromData() {
    List<ChartDataPoints> gains = <ChartDataPoints>[];
    List<ChartDataPoints> losses = <ChartDataPoints>[];
    for (int i = 0; i < inputData.length; i++) {
      final dataPoint = new ChartDataPoints(
        inputData[i]['symbol'],
        inputData[i]['gain_loss_percent'],
      );
      if (dataPoint.gainLossPercent > 0) {
        gains.add(dataPoint);
      } else {
        losses.add(dataPoint);
      }
    }
    gains.sort((a, b) => (a.gainLossPercent).compareTo(b.gainLossPercent));
    losses.sort((a, b) => (a.gainLossPercent).compareTo(b.gainLossPercent));
    return <BarSeries<ChartDataPoints, String>>[
      BarSeries<ChartDataPoints, String>(
        animationDuration: 0,
        name: 'Gain/Loss %',
        dataSource: losses,
        xValueMapper: (ChartDataPoints trade, _) => trade.symbol,
        yValueMapper: (ChartDataPoints trade, _) => trade.gainLossPercent,
        color: Colors.red,
      ),
      BarSeries<ChartDataPoints, String>(
        name: 'Total Gains/Losses',
        dataSource: gains,
        xValueMapper: (ChartDataPoints trade, _) => trade.symbol,
        yValueMapper: (ChartDataPoints trade, _) => trade.gainLossPercent,
        color: Colors.green,
      ),
    ];
  }
}

class ChartDataPoints {
  final String symbol;
  final double gainLossPercent;

  ChartDataPoints(this.symbol, this.gainLossPercent);
}
