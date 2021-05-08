import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MarketIndexLineChart extends StatefulWidget {
  final bool? animate;
  final List chartData;

  MarketIndexLineChart(this.chartData, {this.animate});

  @override
  _MarketIndexLineChartState createState() => _MarketIndexLineChartState();
}

class _MarketIndexLineChartState extends State<MarketIndexLineChart> {
  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
      title: ChartTitle(text: "Index Value"),
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

  List<LineSeries<MarketIndexChartData, DateTime>> _buildChartSeries() {
    final List<MarketIndexChartData> indexData = [];
    for (Map chartData in widget.chartData) {
      indexData.add(
        MarketIndexChartData(
          DateTime.parse(chartData['date']),
          double.tryParse(chartData['index_value'])!,
        ),
      );
    }
    List<LineSeries<MarketIndexChartData, DateTime>> lineSeries = [
      LineSeries<MarketIndexChartData, DateTime>(
        dataSource: indexData,
        xValueMapper: (MarketIndexChartData stockData, _) => stockData.date,
        yValueMapper: (MarketIndexChartData stockData, _) =>
            stockData.indexValue,
      ),
    ];
    return lineSeries;
  }
}

class MarketIndexChartData {
  final DateTime date;
  final double indexValue;
  MarketIndexChartData(this.date, this.indexValue);
}
