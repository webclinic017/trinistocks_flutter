import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DividendLineChart extends StatefulWidget {
  final bool? animate;
  final Map chartData;

  DividendLineChart(this.chartData, {this.animate});

  @override
  _DividendLineChartState createState() => _DividendLineChartState();
}

class _DividendLineChartState extends State<DividendLineChart> {
  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Date'),
        dateFormat: DateFormat('dd/MM/yyyy'),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '\${value}',
      ),
      series: _getDividendPaymentSeries(),
    );
    return chart;
  }

  List<LineSeries<DividendPaymentChartData, DateTime>>
      _getDividendPaymentSeries() {
    //set up a list to hold the chart datapoints
    final List<DividendPaymentChartData> stockData = [];
    //get the list of dividend payments
    List dividendPayments = widget.chartData['dividendPayments'];
    for (Map chartData in dividendPayments) {
      stockData.add(
        DividendPaymentChartData(
          chartData['date'],
          chartData['dividendPayment'],
        ),
      );
    }
    //now build the chart series from this list
    List<LineSeries<DividendPaymentChartData, DateTime>> lineSeries = [
      LineSeries<DividendPaymentChartData, DateTime>(
        dataSource: stockData,
        xValueMapper: (DividendPaymentChartData stockData, _) => stockData.date,
        yValueMapper: (DividendPaymentChartData stockData, _) =>
            stockData.dividendPayment,
      ),
    ];
    //and return the line series
    return lineSeries;
  }
}

class DividendPaymentChartData {
  final DateTime date;
  final double dividendPayment;
  DividendPaymentChartData(this.date, this.dividendPayment);
}

class DividendYieldChartData {
  final DateTime date;
  final double dividendYield;
  DividendYieldChartData(this.date, this.dividendYield);
}
