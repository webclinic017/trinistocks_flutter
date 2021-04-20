/// Example of a simple line chart.
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class MarketIndexesLineChart extends StatelessWidget {
  final bool? animate;
  final List<Series<MarketIndexData, DateTime>>? seriesList;

  MarketIndexesLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new TimeSeriesChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: NumericAxisSpec(
        tickProviderSpec: BasicNumericTickProviderSpec(
            desiredTickCount: 10, zeroBound: false),
      ),
      behaviors: [
        new ChartTitle('Date',
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.middleDrawArea),
        new ChartTitle('Index Value',
            behaviorPosition: BehaviorPosition.start,
            titleOutsideJustification: OutsideJustification.middleDrawArea),
      ],
    );
  }

  static List<Series<MarketIndexData, DateTime>>? _createSeriesFromData(
      List indexDataPoints) {
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
    List<Series<MarketIndexData, DateTime>> returnSeries = [
      new Series<MarketIndexData, DateTime>(
        id: 'Composite Index',
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
        domainFn: (MarketIndexData data, _) => data.dateTime,
        measureFn: (MarketIndexData data, _) => data.indexValue,
        data: compositeIndexData,
      ),
    ];
    return returnSeries;
  }

  /// Setup the data for the latest daily trades bar chart
  static Widget withData(List indexData) {
    return new MarketIndexesLineChart(
      _createSeriesFromData(indexData),
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
