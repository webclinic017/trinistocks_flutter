import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockPriceCandlestickChart extends StatefulWidget {
  final bool? animate;
  final List<Map> chartData;
  ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enableMouseWheelZooming: true,
    enablePanning: true,
    enableDoubleTapZooming: true,
    enableSelectionZooming: true,
  );

  StockPriceCandlestickChart(this.chartData, {this.animate});

  void resetZoom() {
    zoomPanBehavior.reset();
  }

  @override
  _StockPriceCandlestickChartState createState() =>
      _StockPriceCandlestickChartState();
}

class _StockPriceCandlestickChartState
    extends State<StockPriceCandlestickChart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
      zoomPanBehavior: widget.zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Date'),
        dateFormat: DateFormat('dd/MM/yyyy'),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '\${value}',
      ),
      series: _getCandleSeries(),
    );
    return chart;
  }

  List<CandleSeries<StockPriceChartData, DateTime>> _getCandleSeries() {
    final List<StockPriceChartData> stockData = [];
    for (Map chartData in widget.chartData) {
      stockData.add(StockPriceChartData(
          chartData['date'],
          chartData['openPrice'],
          chartData['low'],
          chartData['high'],
          chartData['closePrice']));
    }
    List<CandleSeries<StockPriceChartData, DateTime>> candleSeries = [
      CandleSeries<StockPriceChartData, DateTime>(
          dataSource: stockData,
          xValueMapper: (StockPriceChartData stockData, _) => stockData.date,
          lowValueMapper: (StockPriceChartData stockData, _) => stockData.low,
          highValueMapper: (StockPriceChartData stockData, _) => stockData.high,
          openValueMapper: (StockPriceChartData stockData, _) => stockData.open,
          closeValueMapper: (StockPriceChartData stockData, _) =>
              stockData.close),
    ];
    return candleSeries;
  }
}

class StockPriceChartData {
  final DateTime date;
  final double open;
  final double low;
  final double high;
  final double close;
  StockPriceChartData(this.date, this.open, this.low, this.high, this.close);
}
