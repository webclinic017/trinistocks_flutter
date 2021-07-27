/// Horizontal bar chart example
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SimulatorGamesRankingsHorizontalBarChart extends StatelessWidget {
  final List inputData;
  final bool? animate;
  Color? chartColor = Colors.teal;

  SimulatorGamesRankingsHorizontalBarChart(this.inputData,
      {this.animate, this.chartColor});

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new SfCartesianChart(
      margin: EdgeInsets.only(
        right: 15,
        left: 5,
      ),
      series: _createSeriesFromData(),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelRotation: 0,
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
        title: AxisTitle(
          text: "Portfolio Value (TT\$)",
        ),
      ),
    );
  }

  List<BarSeries<SimulatorPlayerData, String>> _createSeriesFromData() {
    List<SimulatorPlayerData> parsedData = <SimulatorPlayerData>[];
    for (int i = 0; i < inputData.length; i++) {
      final playerData = new SimulatorPlayerData(
        inputData[i]['username'],
        double.tryParse(inputData[i]['current_portfolio_value']),
      );
      parsedData.add(playerData);
    }
    parsedData = new List.from(parsedData.reversed);
    return <BarSeries<SimulatorPlayerData, String>>[
      BarSeries<SimulatorPlayerData, String>(
        animationDuration: 0,
        dataSource: parsedData,
        xValueMapper: (SimulatorPlayerData trade, _) => trade.username,
        yValueMapper: (SimulatorPlayerData trade, _) => trade.portfolioValue,
        color: Colors.teal,
      )
    ];
  }
}

//class for daily trade data returned by the api
class SimulatorPlayerData {
  final String username;
  final double? portfolioValue;

  SimulatorPlayerData(this.username, this.portfolioValue);
}
