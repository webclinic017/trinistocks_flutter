/// Example of a simple line chart.
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class MarketIndexesLineChart extends StatelessWidget {
  final bool? animate;
  final List chartData;
  String name;
  ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enableMouseWheelZooming: true,
    enablePanning: true,
    enableDoubleTapZooming: true,
    enableSelectionZooming: true,
  );
  Color? chartColor = Colors.purple;

  MarketIndexesLineChart(this.chartData, this.name,
      {this.animate, this.chartColor});
  void resetZoom() {
    zoomPanBehavior.reset();
  }

  @override
  Widget build(BuildContext context) {
    return new SfCartesianChart(
      series: _createSeriesFromData(chartData, context),
      zoomPanBehavior: zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat('dd/MM/yyyy'),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}',
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<LineSeries<MarketIndexData, DateTime>> _createSeriesFromData(
      List indexDataPoints, BuildContext context) {
    //rename if necessary
    if (name == 'All T%26T Totals') {
      name = 'All T&T Totals';
    }
    List<MarketIndexData> indexData = [];
    for (int i = 0; i < indexDataPoints.length; i++) {
      if (indexDataPoints[i]['index_name'] == name) {
        final dataPoint = new MarketIndexData(
            DateTime.parse(indexDataPoints[i]['date']),
            double.parse(indexDataPoints[i]['index_value']));
        indexData.add(dataPoint);
      }
    }
    List<LineSeries<MarketIndexData, DateTime>> returnSeries = [
      new LineSeries<MarketIndexData, DateTime>(
        animationDuration: 0,
        name: "Index value",
        xValueMapper: (MarketIndexData data, _) => data.dateTime,
        yValueMapper: (MarketIndexData data, _) => data.indexValue,
        dataSource: indexData,
        color: chartColor,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.triangle,
            borderWidth: 3,
            borderColor: chartColor),
      )
    ];
    return returnSeries;
  }
}

//class for market index data returned by the api
class MarketIndexData {
  final DateTime dateTime;
  final double indexValue;

  MarketIndexData(this.dateTime, this.indexValue);
}
