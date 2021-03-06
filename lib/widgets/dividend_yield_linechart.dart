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
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
      ),
      series: _getDividendPaymentSeries(),
      palette: <Color>[Colors.teal],
      tooltipBehavior: TooltipBehavior(enable: true),
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
        name: "Dividend Yield",
        dataSource: stockData,
        xValueMapper: (DividendYieldChartData stockData, _) => stockData.date,
        yValueMapper: (DividendYieldChartData stockData, _) =>
            stockData.dividendYield,
        color: Colors.teal,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.triangle,
            borderWidth: 3,
            borderColor: Colors.tealAccent),
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
