import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FundamentalsLineChart extends StatefulWidget {
  final bool? animate;
  final List chartData;
  final String selectedRatio;
  final String title;

  FundamentalsLineChart(this.chartData, this.selectedRatio, this.title,
      {this.animate});

  @override
  _FundamentalsLineChartState createState() => _FundamentalsLineChartState();
}

class _FundamentalsLineChartState extends State<FundamentalsLineChart> {
  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
      title: ChartTitle(text: widget.title),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Date'),
        dateFormat: DateFormat('MMM y'),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        maximumLabels: 4,
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}',
      ),
      series: _buildChartSeries(context),
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
    );
    return chart;
  }

  List<LineSeries<FundamentalAnalysisData, DateTime>> _buildChartSeries(
      BuildContext context) {
    final List<FundamentalAnalysisData> indexData = [];
    for (Map chartData in widget.chartData) {
      indexData.add(
        FundamentalAnalysisData(
          chartData['date'],
          chartData['RoE'],
          chartData['EPS'],
          chartData['RoIC'],
          chartData['current_ratio'],
          chartData['price_to_earnings_ratio'],
          chartData['dividend_yield'],
          chartData['price_to_book_ratio'],
          chartData['dividend_payout_ratio'],
          chartData['cash_per_share'],
        ),
      );
    }
    switch (widget.selectedRatio) {
      case "earningsPerShare":
        {
          List<LineSeries<FundamentalAnalysisData, DateTime>> lineSeries = [
            LineSeries<FundamentalAnalysisData, DateTime>(
              animationDuration: 0,
              dataSource: indexData,
              xValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.date,
              yValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.earningsPerShare,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Theme.of(context).accentColor,
              ),
              name: "Earnings Per Share",
              color: Colors.teal,
            ),
          ];
          return lineSeries;
        }
      case "returnOnInvestedCapital":
        {
          List<LineSeries<FundamentalAnalysisData, DateTime>> lineSeries = [
            LineSeries<FundamentalAnalysisData, DateTime>(
              animationDuration: 0,
              dataSource: indexData,
              xValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.date,
              yValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.returnOnInvestedCapital,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Theme.of(context).accentColor,
              ),
              name: "RoIC",
              color: Colors.teal,
            ),
          ];
          return lineSeries;
        }
      case "currentRatio":
        {
          List<LineSeries<FundamentalAnalysisData, DateTime>> lineSeries = [
            LineSeries<FundamentalAnalysisData, DateTime>(
              animationDuration: 0,
              dataSource: indexData,
              xValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.date,
              yValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.currentRatio,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Theme.of(context).accentColor,
              ),
              name: "Current Ratio",
              color: Colors.teal,
            ),
          ];
          return lineSeries;
        }
      case "priceToEarningsRatio":
        {
          List<LineSeries<FundamentalAnalysisData, DateTime>> lineSeries = [
            LineSeries<FundamentalAnalysisData, DateTime>(
              animationDuration: 0,
              dataSource: indexData,
              xValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.date,
              yValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.priceToEarningsRatio,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Theme.of(context).accentColor,
              ),
              name: "P/E",
              color: Colors.teal,
            ),
          ];
          return lineSeries;
        }
      case "dividendYield":
        {
          List<LineSeries<FundamentalAnalysisData, DateTime>> lineSeries = [
            LineSeries<FundamentalAnalysisData, DateTime>(
              animationDuration: 0,
              dataSource: indexData,
              xValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.date,
              yValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.dividendYield,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Theme.of(context).accentColor,
              ),
              name: "Dividend Yield",
              color: Colors.teal,
            ),
          ];
          return lineSeries;
        }
      case "priceToBookRatio":
        {
          List<LineSeries<FundamentalAnalysisData, DateTime>> lineSeries = [
            LineSeries<FundamentalAnalysisData, DateTime>(
              animationDuration: 0,
              dataSource: indexData,
              xValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.date,
              yValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.priceToBookRatio,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Theme.of(context).accentColor,
              ),
              name: "P/B",
              color: Colors.teal,
            ),
          ];
          return lineSeries;
        }
      case "dividendPayoutRatio":
        {
          List<LineSeries<FundamentalAnalysisData, DateTime>> lineSeries = [
            LineSeries<FundamentalAnalysisData, DateTime>(
              animationDuration: 0,
              dataSource: indexData,
              xValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.date,
              yValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.dividendPayoutRatio,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Theme.of(context).accentColor,
              ),
              name: "Dividend Payout",
              color: Colors.teal,
            ),
          ];
          return lineSeries;
        }
      case "cashPerShare":
        {
          List<LineSeries<FundamentalAnalysisData, DateTime>> lineSeries = [
            LineSeries<FundamentalAnalysisData, DateTime>(
              animationDuration: 0,
              dataSource: indexData,
              xValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.date,
              yValueMapper: (FundamentalAnalysisData stockData, _) =>
                  stockData.cashPerShare,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Theme.of(context).accentColor,
              ),
              name: "Cash Per Share",
              color: Colors.teal,
            ),
          ];
          return lineSeries;
        }
      default:
        {
          return [];
        }
    }
  }
}

class FundamentalAnalysisData {
  final DateTime date;
  final double returnOnEquity;
  final double earningsPerShare;
  final double returnOnInvestedCapital;
  final double currentRatio;
  final double priceToEarningsRatio;
  final double dividendYield;
  final double priceToBookRatio;
  final double dividendPayoutRatio;
  final double cashPerShare;
  FundamentalAnalysisData(
      this.date,
      this.returnOnEquity,
      this.earningsPerShare,
      this.returnOnInvestedCapital,
      this.currentRatio,
      this.priceToEarningsRatio,
      this.dividendYield,
      this.priceToBookRatio,
      this.dividendPayoutRatio,
      this.cashPerShare);
}
