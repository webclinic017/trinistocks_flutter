import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/fundamental_analysis_api.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/apis/stock_price_api.dart';
import 'package:trinistocks_flutter/widgets/fundamentals_line_chart.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:trinistocks_flutter/widgets/stock_price_candlestick_chart.dart';
import 'package:loading_overlay/loading_overlay.dart';

class FundamentalAnalysisHistoryPage extends StatefulWidget {
  FundamentalAnalysisHistoryPage({Key? key}) : super(key: key);

  @override
  _FundamentalAnalysisHistoryPageState createState() =>
      _FundamentalAnalysisHistoryPageState();
}

class _FundamentalAnalysisHistoryPageState
    extends State<FundamentalAnalysisHistoryPage> {
  List<Color> generatedColors = <Color>[];
  String selectedSymbol = 'AGL';
  String selectedRatio = "priceToEarningsRatio";
  String dateRange = FundamentalDateRange.tenYears;
  double buttonBarLabelSize = 16;
  bool symbolDropdownButtonBuilt = false;
  List<DropdownMenuItem<String>> listedSymbols = [];
  bool _loading = true;
  Widget fundamentalAnnualHistoryChart = Text("");
  Widget fundamentalQuarterlyHistoryChart = Text("");

  @override
  void initState() {
    ListedStocksAPI.fetchListedStockSymbols().then((List<String> symbols) {
      for (String symbol in symbols) {
        listedSymbols.add(
          new DropdownMenuItem<String>(
            value: symbol,
            child: Text(
              symbol,
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: buttonBarLabelSize),
            ),
          ),
        );
      }
      updateFundamentalCharts(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fundamental History'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "Symbol:",
                    style: TextStyle(fontSize: buttonBarLabelSize),
                  ),
                ),
                buildSymbolDropdownButton(context),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "Range:",
                    style: TextStyle(fontSize: buttonBarLabelSize),
                  ),
                ),
                startDateDropdownButton(context),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "Ratio:",
                    style: TextStyle(fontSize: buttonBarLabelSize),
                  ),
                ),
                buildFundamentalRatioChoiceDropdownButton(context),
              ],
            ),
            fundamentalAnnualHistoryChart,
            fundamentalQuarterlyHistoryChart,
          ],
        ),
        isLoading: _loading,
      ),
    );
  }

  void updateFundamentalCharts(BuildContext context) {
    FundamentalAnalysisAPI.fetchAuditedFundamentalAnalysisData(
            selectedSymbol, dateRange)
        .then((List stockData) {
      fundamentalAnnualHistoryChart = FundamentalsLineChart(
        stockData,
        selectedRatio,
        "Annual Ratios",
        animate: true,
      );
      setState(() {});
    });
    FundamentalAnalysisAPI.fetchQuarterlyFundamentalAnalysisData(
            selectedSymbol, dateRange)
        .then((List stockData) {
      fundamentalQuarterlyHistoryChart = FundamentalsLineChart(
        stockData,
        selectedRatio,
        "Quarterly Ratios",
        animate: true,
      );
      setState(() {
        _loading = false;
      });
    });
  }

  Widget buildSymbolDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: this.selectedSymbol,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).accentColor,
      ),
      items: listedSymbols,
      underline: Container(
        height: 2,
        color: Theme.of(context).splashColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _loading = true;
          selectedSymbol = newValue!;
          updateFundamentalCharts(context);
        });
      },
    );
  }

  Widget buildFundamentalRatioChoiceDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: this.selectedRatio,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).accentColor,
      ),
      items: [
        new DropdownMenuItem<String>(
          value: "earningsPerShare",
          child: Text(
            "EPS",
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: "returnOnInvestedCapital",
          child: Text(
            "RoIC",
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: "currentRatio",
          child: Text(
            "Current Ratio",
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: "priceToEarningsRatio",
          child: Text(
            "P/E",
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: "dividendYield",
          child: Text(
            "Dividend Yield",
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: "priceToBookRatio",
          child: Text(
            "P/B",
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: "dividendPayoutRatio",
          child: Text(
            "Dividend Payout",
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: "cashPerShare",
          child: Text(
            "Cash Per Share",
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
      ],
      underline: Container(
        height: 2,
        color: Theme.of(context).splashColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _loading = true;
          selectedRatio = newValue!;
          updateFundamentalCharts(context);
        });
      },
    );
  }

  Widget startDateDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: dateRange,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).accentColor,
      ),
      items: [
        new DropdownMenuItem<String>(
          value: FundamentalDateRange.threeYears,
          child: Text(
            FundamentalDateRange.threeYears,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: FundamentalDateRange.fiveYears,
          child: Text(
            FundamentalDateRange.fiveYears,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: FundamentalDateRange.tenYears,
          child: Text(
            FundamentalDateRange.tenYears,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
      ],
      underline: Container(
        height: 2,
        color: Theme.of(context).splashColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _loading = true;
          dateRange = newValue!;
          updateFundamentalCharts(context);
        });
      },
    );
  }
}
