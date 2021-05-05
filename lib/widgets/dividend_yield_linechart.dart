import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DividendYieldLineChart extends StatefulWidget {
  final bool? animate;
  final List chartData;

  DividendYieldLineChart(this.chartData, {this.animate});

  @override
  _DividendYieldLineChartState createState() => _DividendYieldLineChartState();
}

class _DividendYieldLineChartState extends State<DividendYieldLineChart> {
  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat('dd/MM/yyyy'),
        labelRotation: 90,
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
      ),
      series: _getDividendPaymentSeries(),
      palette: <Color>[Colors.pinkAccent],
    );
    return Container(
      child: chart,
      height: 250,
    );
  }

  List<LineSeries<DividendYieldChartData, DateTime>>
      _getDividendPaymentSeries() {
    //set up a list to hold the chart datapoints
    final List<DividendYieldChartData> stockData = [];
    //get the list of dividend payments
    List dividendPayments = widget.chartData;
    for (Map chartData in dividendPayments) {
      stockData.add(
        DividendYieldChartData(
          chartData['date'],
          chartData['dividend_yield'],
        ),
      );
    }
    //now build the chart series from this list
    List<LineSeries<DividendYieldChartData, DateTime>> lineSeries = [
      LineSeries<DividendYieldChartData, DateTime>(
        dataSource: stockData,
        xValueMapper: (DividendYieldChartData stockData, _) => stockData.date,
        yValueMapper: (DividendYieldChartData stockData, _) =>
            stockData.dividendYield,
      ),
    ];
    //and return the line series
    return lineSeries;
  }
}

class DividendYieldChartData {
  final DateTime date;
  final double dividendYield;
  DividendYieldChartData(this.date, this.dividendYield);
}
