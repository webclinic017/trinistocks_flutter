import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MarketTradesLineChart extends StatefulWidget {
  final bool? animate;
  final List chartData;
  ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enableMouseWheelZooming: true,
    enablePanning: true,
    enableDoubleTapZooming: true,
    enableSelectionZooming: true,
  );

  MarketTradesLineChart(this.chartData, {this.animate});

  void resetZoom() {
    zoomPanBehavior.reset();
  }

  @override
  _MarketTradesLineChartState createState() => _MarketTradesLineChartState();
}

class _MarketTradesLineChartState extends State<MarketTradesLineChart> {
  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
      title: ChartTitle(text: "Number of Trades"),
      zoomPanBehavior: widget.zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Date'),
        dateFormat: DateFormat('dd/MM/yyyy'),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}',
      ),
      series: _buildChartSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
    return chart;
  }

  List<LineSeries<MarketTradesChartData, DateTime>> _buildChartSeries() {
    final List<MarketTradesChartData> indexData = [];
    for (Map chartData in widget.chartData) {
      indexData.add(
        MarketTradesChartData(
          DateTime.parse(chartData['date']),
          chartData['num_trades'],
        ),
      );
    }
    List<LineSeries<MarketTradesChartData, DateTime>> lineSeries = [
      LineSeries<MarketTradesChartData, DateTime>(
        name: "Number of trades",
        dataSource: indexData,
        xValueMapper: (MarketTradesChartData stockData, _) => stockData.date,
        yValueMapper: (MarketTradesChartData stockData, _) =>
            stockData.numTrades,
        color: Colors.cyan,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.triangle,
            borderWidth: 3,
            borderColor: Colors.cyanAccent),
      ),
    ];
    return lineSeries;
  }
}

class MarketTradesChartData {
  final DateTime date;
  final int numTrades;
  MarketTradesChartData(this.date, this.numTrades);
}
