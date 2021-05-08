import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MarketTradesLineChart extends StatefulWidget {
  final bool? animate;
  final List chartData;

  MarketTradesLineChart(this.chartData, {this.animate});

  @override
  _MarketTradesLineChartState createState() => _MarketTradesLineChartState();
}

class _MarketTradesLineChartState extends State<MarketTradesLineChart> {
  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
      title: ChartTitle(text: "Number of Trades"),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
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
        dataSource: indexData,
        xValueMapper: (MarketTradesChartData stockData, _) => stockData.date,
        yValueMapper: (MarketTradesChartData stockData, _) =>
            stockData.numTrades,
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
