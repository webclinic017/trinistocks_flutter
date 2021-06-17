/// Horizontal bar chart example
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PortfolioSectorGainLossHorizontalBarChart extends StatelessWidget {
  final List inputData;
  final bool? animate;

  PortfolioSectorGainLossHorizontalBarChart(this.inputData, {this.animate});

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new SfCartesianChart(
      title: ChartTitle(text: "Gain/Loss Per Sector"),
      series: _createSeriesFromData(),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
        title: AxisTitle(
          text: "Gain/Loss (TT\$)",
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
        inputData[i]['sector'],
        inputData[i]['total_gain_loss'],
      );
      if (dataPoint.totalGainLoss > 0) {
        gains.add(dataPoint);
      } else {
        losses.add(dataPoint);
      }
    }
    gains.sort((a, b) => (a.totalGainLoss).compareTo(b.totalGainLoss));
    losses.sort((a, b) => (a.totalGainLoss).compareTo(b.totalGainLoss));
    return <BarSeries<ChartDataPoints, String>>[
      BarSeries<ChartDataPoints, String>(
        name: 'Total Gains/Losses',
        dataSource: losses,
        xValueMapper: (ChartDataPoints trade, _) => trade.sector,
        yValueMapper: (ChartDataPoints trade, _) => trade.totalGainLoss,
        color: Colors.red,
      ),
      BarSeries<ChartDataPoints, String>(
        name: 'Total Gains/Losses',
        dataSource: gains,
        xValueMapper: (ChartDataPoints trade, _) => trade.sector,
        yValueMapper: (ChartDataPoints trade, _) => trade.totalGainLoss,
        color: Colors.green,
      ),
    ];
  }
}

class ChartDataPoints {
  final String sector;
  final double totalGainLoss;

  ChartDataPoints(this.sector, this.totalGainLoss);
}
