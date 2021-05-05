import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DividendPaymentsLineChart extends StatefulWidget {
  final bool? animate;
  final List chartData;

  DividendPaymentsLineChart(this.chartData, {this.animate});

  @override
  _DividendPaymentsLineChartState createState() =>
      _DividendPaymentsLineChartState();
}

class _DividendPaymentsLineChartState extends State<DividendPaymentsLineChart> {
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
        labelFormat: '\${value}',
      ),
      series: _getDividendPaymentSeries(),
      palette: <Color>[Colors.purple],
    );
    return Container(
      child: chart,
      height: 250,
    );
  }

  List<LineSeries<DividendPaymentChartData, DateTime>>
      _getDividendPaymentSeries() {
    //set up a list to hold the chart datapoints
    final List<DividendPaymentChartData> stockData = [];
    //get the list of dividend payments
    List dividendPayments = widget.chartData;
    for (Map chartData in dividendPayments) {
      stockData.add(
        DividendPaymentChartData(
          chartData['date'],
          chartData['dividend_amount'],
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
