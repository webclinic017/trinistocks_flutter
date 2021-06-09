/// Example of a simple line chart.
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class MarketIndexesLineChart extends StatelessWidget {
  final bool? animate;
  final List chartData;

  MarketIndexesLineChart(this.chartData, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new SfCartesianChart(
      series: _createSeriesFromData(chartData, context),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
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

  static List<LineSeries<MarketIndexData, DateTime>> _createSeriesFromData(
      List indexDataPoints, BuildContext context) {
    List<MarketIndexData> compositeIndexData = [];
    for (int i = 0; i < indexDataPoints.length; i++) {
      if (indexDataPoints[i]['index_name'] == "Composite Totals") {
        final dataPoint = new MarketIndexData(
            DateTime.parse(indexDataPoints[i]['date']),
            double.parse(indexDataPoints[i]['index_value']));
        compositeIndexData.add(dataPoint);
      }
    }
    List<MarketIndexData> tntIndexData = [];
    for (int i = 0; i < indexDataPoints.length; i++) {
      if (indexDataPoints[i]['index_name'] == "All T&T Totals") {
        final dataPoint = new MarketIndexData(
            DateTime.parse(indexDataPoints[i]['date']),
            double.parse(indexDataPoints[i]['index_value']));
        tntIndexData.add(dataPoint);
      }
    }
    List<LineSeries<MarketIndexData, DateTime>> returnSeries = [
      new LineSeries<MarketIndexData, DateTime>(
        xValueMapper: (MarketIndexData data, _) => data.dateTime,
        yValueMapper: (MarketIndexData data, _) => data.indexValue,
        dataSource: compositeIndexData,
        color: Theme.of(context).splashColor,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.triangle,
            borderWidth: 3,
            borderColor: Theme.of(context).highlightColor),
      )
    ];
    return returnSeries;
  }

  /// Setup the data for the latest daily trades bar chart
  static Widget withData(List indexData) {
    return new MarketIndexesLineChart(
      indexData,
      // Disable animations for image tests.
      animate: true,
    );
  }
}

//class for market index data returned by the api
class MarketIndexData {
  final DateTime dateTime;
  final double indexValue;

  MarketIndexData(this.dateTime, this.indexValue);
}
