import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';

import 'loading_widget.dart';

class StockPriceCandlestickChart extends StatefulWidget {
  final bool? animate;
  final List<Map> chartData;

  StockPriceCandlestickChart(this.chartData, {this.animate});

  @override
  _StockPriceCandlestickChartState createState() =>
      _StockPriceCandlestickChartState();
}

class _StockPriceCandlestickChartState
    extends State<StockPriceCandlestickChart> {
  late double minValue;
  late SfCartesianChart chart;

  @override
  Widget build(BuildContext context) {
    chart = SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'AAPL - 2016'),
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Date'),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '\${value}',
        minimum: 10.0,
      ),
      series: _getCandleSeries(),
    );
    return chart;
  }

  /// It returns the candle series to the chart.
  List<CandleSeries<ChartSampleData, DateTime>> _getCandleSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2016, 01, 11),
          open: 98.97,
          high: 101.19,
          low: 95.36,
          close: 97.13),
      ChartSampleData(
          x: DateTime(2016, 01, 18),
          open: 98.41,
          high: 101.46,
          low: 93.42,
          close: 101.42),
      ChartSampleData(
          x: DateTime(2016, 01, 25),
          open: 101.52,
          high: 101.53,
          low: 92.39,
          close: 97.34),
      ChartSampleData(
          x: DateTime(2016, 02, 01),
          open: 96.47,
          high: 97.33,
          low: 93.69,
          close: 94.02),
      ChartSampleData(
          x: DateTime(2016, 02, 08),
          open: 93.13,
          high: 96.35,
          low: 92.59,
          close: 93.99),
      ChartSampleData(
          x: DateTime(2016, 02, 15),
          open: 95.02,
          high: 98.89,
          low: 94.61,
          close: 96.04),
      ChartSampleData(
          x: DateTime(2016, 02, 22),
          open: 96.31,
          high: 98.0237,
          low: 93.32,
          close: 96.91),
      ChartSampleData(
          x: DateTime(2016, 02, 29),
          open: 96.86,
          high: 103.75,
          low: 96.65,
          close: 103.01),
      ChartSampleData(
          x: DateTime(2016, 03, 07),
          open: 102.39,
          high: 102.83,
          low: 100.15,
          close: 102.26),
      ChartSampleData(
          x: DateTime(2016, 03, 14),
          open: 106.5,
          high: 106.5,
          low: 106.5,
          close: 106.5),
      ChartSampleData(
          x: DateTime(2016, 03, 21),
          open: 105.93,
          high: 107.65,
          low: 104.89,
          close: 105.67),
      ChartSampleData(
          x: DateTime(2016, 03, 28),
          open: 106,
          high: 110.42,
          low: 104.88,
          close: 109.99),
      ChartSampleData(
          x: DateTime(2016, 04, 04),
          open: 110.42,
          high: 112.19,
          low: 108.121,
          close: 108.66),
      ChartSampleData(
          x: DateTime(2016, 04, 11),
          open: 108.97,
          high: 112.39,
          low: 108.66,
          close: 109.85),
      ChartSampleData(
          x: DateTime(2016, 04, 18),
          open: 108.89,
          high: 108.95,
          low: 104.62,
          close: 105.68),
      ChartSampleData(
          x: DateTime(2016, 04, 25),
          open: 105,
          high: 105.65,
          low: 92.51,
          close: 93.74),
      ChartSampleData(
          x: DateTime(2016, 05, 02),
          open: 93.965,
          high: 95.9,
          low: 91.85,
          close: 92.72),
      ChartSampleData(
          x: DateTime(2016, 05, 09),
          open: 93,
          high: 93.77,
          low: 89.47,
          close: 90.52),
      ChartSampleData(
          x: DateTime(2016, 05, 16),
          open: 92.39,
          high: 95.43,
          low: 91.65,
          close: 95.22),
      ChartSampleData(
          x: DateTime(2016, 05, 23),
          open: 95.87,
          high: 100.73,
          low: 95.67,
          close: 100.35),
      ChartSampleData(
          x: DateTime(2016, 05, 30),
          open: 99.6,
          high: 100.4,
          low: 96.63,
          close: 97.92),
      ChartSampleData(
          x: DateTime(2016, 06, 06),
          open: 97.99,
          high: 101.89,
          low: 97.55,
          close: 98.83),
      ChartSampleData(
          x: DateTime(2016, 06, 13),
          open: 98.69,
          high: 99.12,
          low: 95.3,
          close: 95.33),
      ChartSampleData(
          x: DateTime(2016, 06, 20),
          open: 96,
          high: 96.89,
          low: 92.65,
          close: 93.4),
      ChartSampleData(
          x: DateTime(2016, 06, 27),
          open: 93,
          high: 96.465,
          low: 91.5,
          close: 95.89),
      ChartSampleData(
          x: DateTime(2016, 07, 04),
          open: 95.39,
          high: 96.89,
          low: 94.37,
          close: 96.68),
      ChartSampleData(
          x: DateTime(2016, 07, 11),
          open: 96.75,
          high: 99.3,
          low: 96.73,
          close: 98.78),
      ChartSampleData(
          x: DateTime(2016, 07, 18),
          open: 98.7,
          high: 101,
          low: 98.31,
          close: 98.66),
      ChartSampleData(
          x: DateTime(2016, 07, 25),
          open: 98.25,
          high: 104.55,
          low: 96.42,
          close: 104.21),
      ChartSampleData(
          x: DateTime(2016, 08, 01),
          open: 104.41,
          high: 107.65,
          low: 104,
          close: 107.48),
      ChartSampleData(
          x: DateTime(2016, 08, 08),
          open: 107.52,
          high: 108.94,
          low: 107.16,
          close: 108.18),
      ChartSampleData(
          x: DateTime(2016, 08, 15),
          open: 108.14,
          high: 110.23,
          low: 108.08,
          close: 109.36),
      ChartSampleData(
          x: DateTime(2016, 08, 22),
          open: 108.86,
          high: 109.32,
          low: 106.31,
          close: 106.94),
      ChartSampleData(
          x: DateTime(2016, 08, 29),
          open: 109.74,
          high: 109.74,
          low: 109.74,
          close: 109.74),
      ChartSampleData(
          x: DateTime(2016, 09, 05),
          open: 107.9,
          high: 108.76,
          low: 103.13,
          close: 103.13),
      ChartSampleData(
          x: DateTime(2016, 09, 12),
          open: 102.65,
          high: 116.13,
          low: 102.53,
          close: 114.92),
      ChartSampleData(
          x: DateTime(2016, 09, 19),
          open: 115.19,
          high: 116.18,
          low: 111.55,
          close: 112.71),
      ChartSampleData(
          x: DateTime(2016, 09, 26),
          open: 111.64,
          high: 114.64,
          low: 111.55,
          close: 113.05),
    ];
    return <CandleSeries<ChartSampleData, DateTime>>[
      CandleSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          name: 'AAPL',
          xValueMapper: (ChartSampleData sales, _) => sales.x,

          /// High, low, open and close values used to render the candle series.
          lowValueMapper: (ChartSampleData sales, _) => sales.low,
          highValueMapper: (ChartSampleData sales, _) => sales.high,
          openValueMapper: (ChartSampleData sales, _) => sales.open,
          closeValueMapper: (ChartSampleData sales, _) => sales.close)
    ];
  }
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic? x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic? xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color? color;

  /// Date time value of the data point
  final DateTime? date;
}

class StockPriceChartData {
  final DateTime date;
  final double open;
  final double low;
  final double high;
  final double close;
  StockPriceChartData(
      {required this.date,
      required this.open,
      required this.low,
      required this.high,
      required this.close});
}
