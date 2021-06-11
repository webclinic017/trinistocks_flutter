import 'package:a_colors/a_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OutstandingPricesAreaChart extends StatefulWidget {
  final bool? animate;
  final List outstandingTradeData;
  TextStyle axisTitleStyle = new TextStyle(fontSize: 12);

  OutstandingPricesAreaChart(this.outstandingTradeData, {this.animate});

  @override
  _OutstandingPricesAreaChartState createState() =>
      _OutstandingPricesAreaChartState();
}

class _OutstandingPricesAreaChartState
    extends State<OutstandingPricesAreaChart> {
  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
      title: ChartTitle(
        text: 'Bid/Offer Prices',
        textStyle: TextStyle(fontSize: 14),
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
      legend: Legend(isVisible: true),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(labelFormat: '\${value}'),
      // adding multiple axis
      axes: <ChartAxis>[
        NumericAxis(
            name: 'yAxis',
            opposedPosition: true,
            title: AxisTitle(
                text: 'Outstanding Offer Price',
                textStyle: widget.axisTitleStyle))
      ],
      series: _getOutstandingPriceSeries(
        context,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
    return Container(
      child: chart,
      height: 250,
    );
  }

  List<SplineSeries<OutstandingPriceChartData, DateTime>>
      _getOutstandingPriceSeries(
    BuildContext context,
  ) {
    //set up a list to hold the chart datapoints
    final List<OutstandingPriceChartData> outstandingTradeData = [];
    for (Map chartData in widget.outstandingTradeData) {
      outstandingTradeData.add(
        OutstandingPriceChartData(
          chartData['date'],
          chartData['os_bid'],
          chartData['os_offer'],
        ),
      );
    }
    List<SplineSeries<OutstandingPriceChartData, DateTime>> chartSeries = [
      SplineSeries<OutstandingPriceChartData, DateTime>(
        dataSource: outstandingTradeData,
        xValueMapper: (OutstandingPriceChartData tradeData, _) =>
            tradeData.date,
        yValueMapper: (OutstandingPriceChartData tradeData, _) =>
            tradeData.outstandingBidPrice,
        name: "Bid Price",
        color: Colors.teal,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.diamond,
            borderWidth: 3,
            borderColor: Colors.tealAccent),
      ),
      SplineSeries<OutstandingPriceChartData, DateTime>(
        dataSource: outstandingTradeData,
        xValueMapper: (OutstandingPriceChartData tradeData, _) =>
            tradeData.date,
        yValueMapper: (OutstandingPriceChartData tradeData, _) =>
            tradeData.outstandingOfferPrice,
        name: "Offer Price",
        color: Colors.purple,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.verticalLine,
            borderWidth: 3,
            borderColor: Colors.purpleAccent),
      ),
    ];
    //and return the line series
    return chartSeries;
  }
}

class OutstandingPriceChartData {
  final DateTime date;
  final double outstandingBidPrice;
  final double outstandingOfferPrice;
  OutstandingPriceChartData(
      this.date, this.outstandingBidPrice, this.outstandingOfferPrice);
}
