/// Example of a simple line chart.
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class MarketIndexesLineChart extends StatelessWidget {
  final bool? animate;
  final List<Series<dynamic, String>>? seriesList;

  MarketIndexesLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new LineChart(seriesList, animate: animate);
  }

  static List<Series<MarketIndexData, String>>? _createSeriesFromData(
      List indexDataPoints) {
    List<MarketIndexData> parsedData = [];
    for (int i = 0; i < indexDataPoints.length; i++) {
      final dataPoint = new MarketIndexData(
          indexDataPoints[i]['indexName'], indexDataPoints[i]['indexValue']);
      parsedData.add(dataPoint);
    }
    List<Series<MarketIndexData, String>> returnSeries = [
      new Series<MarketIndexData, String>(
        id: 'Daily Trades',
        domainFn: (MarketIndexData trade, _) => trade.indexName,
        measureFn: (MarketIndexData trade, _) => trade.indexValue,
        data: parsedData,
      )
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
  final String indexName;
  final double indexValue;

  MarketIndexData(this.indexName, this.indexValue);
}
