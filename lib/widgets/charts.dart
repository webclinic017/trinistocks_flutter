/// Horizontal bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../apis/latestdailytrades.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChart.withSampleData() {
    return new HorizontalBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  /// Setup the data for the latest daily trades bar chart
  static Widget withLatestDailyTradesData() {
    return new FutureBuilder<Map>(
      future: fetchLatestTrades(),
      initialData: Map(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(children: <Widget>[
              Text(
                "Stocks Traded on the TTSE on ${snapshot.data['date']}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 400.0,
                child: HorizontalBarChart(
                  _createSampleData(),
                  // Disable animations for image tests.
                  animate: false,
                ),
              ),
            ]),
          );
        }
        //else
        return Padding(
            padding: EdgeInsets.only(top: 10.00),
            child:
                SizedBox(height: 400.00, child: EasyLoading.show(status: 'loading...');
));
      },
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

//class for daily trade data returned by the api
class DailyTrades {
  final String symbol;
  final double volumeTraded;

  DailyTrades(this.symbol, this.volumeTraded);
}
