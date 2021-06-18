import 'package:a_colors/a_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OutstandingVolumeChart extends StatefulWidget {
  final bool? animate;
  final List outstandingTradeData;
  TextStyle axisTitleStyle = new TextStyle(fontSize: 12);

  OutstandingVolumeChart(this.outstandingTradeData, {this.animate});

  @override
  _OutstandingVolumeChartState createState() => _OutstandingVolumeChartState();
}

class _OutstandingVolumeChartState extends State<OutstandingVolumeChart> {
  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
      title: ChartTitle(
        text: 'Bid/Offer Volumes',
        textStyle: TextStyle(fontSize: 14),
      ),
      legend: Legend(isVisible: true),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(labelFormat: '{value}'),
      // adding multiple axis
      axes: <ChartAxis>[
        NumericAxis(
            name: 'yAxis',
            opposedPosition: true,
            title: AxisTitle(
                text: 'Outstanding Offer Price',
                textStyle: widget.axisTitleStyle))
      ],
      series: _getOutstandingVolumeSeries(
        context,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
    return Container(
      child: chart,
      height: 250,
    );
  }

  List<SplineSeries<OutstandingVolumeChartData, DateTime>>
      _getOutstandingVolumeSeries(
    BuildContext context,
  ) {
    //set up a list to hold the chart datapoints
    final List<OutstandingVolumeChartData> outstandingTradeData = [];
    for (Map chartData in widget.outstandingTradeData) {
      outstandingTradeData.add(
        OutstandingVolumeChartData(
          chartData['date'],
          chartData['os_bid_vol'],
          chartData['os_offer_vol'],
        ),
      );
    }
    //now build the chart series from this list
    List<SplineSeries<OutstandingVolumeChartData, DateTime>> chartSeries = [
      SplineSeries<OutstandingVolumeChartData, DateTime>(
        animationDuration: 0,
        dataSource: outstandingTradeData,
        xValueMapper: (OutstandingVolumeChartData tradeData, _) =>
            tradeData.date,
        yValueMapper: (OutstandingVolumeChartData tradeData, _) =>
            tradeData.outstandingBidVolume,
        name: "Bid Vol.",
        color: Colors.teal,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 4,
            width: 4,
            shape: DataMarkerType.diamond,
            borderWidth: 3,
            borderColor: Colors.tealAccent),
      ),
      SplineSeries<OutstandingVolumeChartData, DateTime>(
        animationDuration: 0,
        dataSource: outstandingTradeData,
        xValueMapper: (OutstandingVolumeChartData tradeData, _) =>
            tradeData.date,
        yValueMapper: (OutstandingVolumeChartData tradeData, _) =>
            tradeData.outstandingOfferVolume,
        name: "Offer Vol.",
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

class OutstandingVolumeChartData {
  final DateTime date;
  final int outstandingBidVolume;
  final int outstandingOfferVolume;
  OutstandingVolumeChartData(
      this.date, this.outstandingBidVolume, this.outstandingOfferVolume);
}
