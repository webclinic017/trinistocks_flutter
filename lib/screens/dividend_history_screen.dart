import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/dividend_api.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/widgets/dividend_payments_linechart.dart';
import 'package:trinistocks_flutter/widgets/dividend_yield_linechart.dart';
import 'package:trinistocks_flutter/widgets/loading_widget.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:loading_overlay/loading_overlay.dart';

class DividendHistoryPage extends StatefulWidget {
  DividendHistoryPage({Key? key}) : super(key: key);

  @override
  _DividendHistoryPageState createState() => _DividendHistoryPageState();
}

class _DividendHistoryPageState extends State<DividendHistoryPage> {
  List<Color> generatedColors = <Color>[];
  String selectedSymbol = 'AGL';
  String dateRange = DividendDateRange.fiveYears;
  double buttonBarLabelSize = 16;
  List<DropdownMenuItem<String>> listedSymbols = [];
  late Widget symbolDropdown;
  late Widget dateDropdown;
  bool _loading = true;
  bool dividendPaymentsLineChartLoading = true;
  bool dividendYieldLineChartLoading = true;
  Widget dividendPaymentsLineChart = Text("");
  Widget dividendYieldLineChart = Text("");

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
      updateDividendPaymentsLineChart(context);
      updateDividendYieldsLineChart(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //build the dropdown that lists the choices for dates
    dateDropdown = buildDateDropdownButton(context);
    symbolDropdown = buildSymbolDropdownButton();
    updateLoading();
    return Scaffold(
      appBar: AppBar(
        title: Text('Dividend History'),
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
                symbolDropdown,
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "Range:",
                    style: TextStyle(fontSize: buttonBarLabelSize),
                  ),
                ),
                dateDropdown,
              ],
            ),
            Text("Dividend Yields",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1),
            dividendYieldLineChart,
            Text("Dividend Payments",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1),
            dividendPaymentsLineChart,
          ],
        ),
        isLoading: _loading,
      ),
    );
  }

  Widget buildDateDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: dateRange,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).accentColor,
      ),
      items: [
        new DropdownMenuItem<String>(
          value: DividendDateRange.threeYears,
          child: Text(
            DividendDateRange.threeYears,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: DividendDateRange.fiveYears,
          child: Text(
            DividendDateRange.fiveYears,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: DividendDateRange.tenYears,
          child: Text(
            DividendDateRange.tenYears,
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
          dividendPaymentsLineChartLoading = true;
          dividendYieldLineChartLoading = true;
          dateRange = newValue!;
          updateDividendPaymentsLineChart(context);
          updateDividendYieldsLineChart(context);
        });
      },
    );
  }

  Widget buildSymbolDropdownButton() {
    return DropdownButton<String>(
        value: selectedSymbol,
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
            dividendPaymentsLineChartLoading = true;
            dividendYieldLineChartLoading = true;
            selectedSymbol = newValue!;
            updateDividendPaymentsLineChart(context);
            updateDividendYieldsLineChart(context);
          });
        });
  }

  void updateLoading() {
    if (dividendPaymentsLineChartLoading || dividendYieldLineChartLoading) {
      _loading = true;
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void updateDividendPaymentsLineChart(BuildContext context) {
    DividendAPI.fetchDividendPaymentData(selectedSymbol, dateRange)
        .then((List dividendPayments) {
      dividendPaymentsLineChart = DividendPaymentsLineChart(
        dividendPayments,
        animate: true,
      );
      setState(() {
        dividendPaymentsLineChartLoading = false;
      });
    });
  }

  void updateDividendYieldsLineChart(BuildContext context) {
    DividendAPI.fetchDividendYieldData(selectedSymbol, dateRange)
        .then((List dividendYields) {
      dividendYieldLineChart = DividendYieldLineChart(
        dividendYields,
        animate: true,
      );
      setState(() {
        dividendYieldLineChartLoading = false;
      });
    });
  }
}
