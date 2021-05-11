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
        text: 'Bid-Offer Spread',
        textStyle: TextStyle(fontSize: 14),
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat('dd/MM/yyyy'),
        labelRotation: 90,
      ),
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
      palette: <Color>[
        Theme.of(context).splashColor,
        Theme.of(context).buttonColor
      ],
    );
    return Container(
      child: chart,
      height: 250,
    );
  }

  List<RangeAreaSeries<OutstandingPriceChartData, DateTime>>
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
    //now build the chart series from this list
    List<RangeAreaSeries<OutstandingPriceChartData, DateTime>> areaSeries = [
      RangeAreaSeries<OutstandingPriceChartData, DateTime>(
        dataSource: outstandingTradeData,
        borderDrawMode: RangeAreaBorderMode.excludeSides,
        borderColor: Theme.of(context).accentColor,
        borderWidth: 2,
        xValueMapper: (OutstandingPriceChartData tradeData, _) =>
            tradeData.date,
        lowValueMapper: (OutstandingPriceChartData tradeData, _) =>
            tradeData.outstandingBidPrice,
        highValueMapper: (OutstandingPriceChartData tradeData, _) =>
            tradeData.outstandingOfferPrice,
      ),
    ];
    //and return the line series
    return areaSeries;
  }
}

class OutstandingPriceChartData {
  final DateTime date;
  final double outstandingBidPrice;
  final double outstandingOfferPrice;
  OutstandingPriceChartData(
      this.date, this.outstandingBidPrice, this.outstandingOfferPrice);
}
