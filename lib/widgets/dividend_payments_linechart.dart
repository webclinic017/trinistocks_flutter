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
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(
        labelFormat: '\${value}',
      ),
      series: _getDividendPaymentSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
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
        animationDuration: 0,
        name: "Dividend Payments",
        dataSource: stockData,
        xValueMapper: (DividendPaymentChartData stockData, _) => stockData.date,
        yValueMapper: (DividendPaymentChartData stockData, _) =>
            stockData.dividendPayment,
        color: Colors.purple,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.triangle,
            borderWidth: 3,
            borderColor: Colors.purpleAccent),
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
