import 'package:a_colors/a_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/apis/market_indexes_api.dart';
import 'package:trinistocks_flutter/apis/outstanding_trades_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:trinistocks_flutter/widgets/outstanding_prices_chart.dart';
import 'package:trinistocks_flutter/widgets/outstanding_volume_chart.dart';
import 'package:loading_overlay/loading_overlay.dart';

class OutstandingTradesHistoryPage extends StatefulWidget {
  OutstandingTradesHistoryPage({Key? key}) : super(key: key);

  @override
  _OutstandingTradesHistoryPageState createState() =>
      _OutstandingTradesHistoryPageState();
}

class _OutstandingTradesHistoryPageState
    extends State<OutstandingTradesHistoryPage> {
  List<Color> generatedColors = <Color>[];
  String selectedSymbol = 'AGL';
  String dateRange = OutstandingTradesRange.oneMonth;
  double buttonBarLabelSize = 14;
  bool symbolDropdownButtonBuilt = false;
  List<DropdownMenuItem<String>> listedSymbols = [];
  bool _loading = true;
  Widget outstandingPriceChart = Text("");
  Widget outstandingVolumeChart = Text("");
  String latestOutstandingBid = 'N.A';
  String latestOutstandingBidVol = 'N.A';
  String latestOutstandingOffer = 'N.A';
  String latestOutstandingOfferVol = 'N.A';
  final dollarFormat = new NumberFormat("#,##0.00", "en_US");
  final shareFormat = new NumberFormat("#,##0", "en_US");

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
      updateOutstandingTradeDataCharts(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListView view = ListView();
    view = ListView(
      padding: const EdgeInsets.all(0.0),
      children: [
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: Text(
                "Index:",
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
        Card(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: RichText(
                    text: TextSpan(
                      text: "Current Highest Bid: ",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor),
                      children: [
                        TextSpan(
                          text:
                              "$latestOutstandingBid ($latestOutstandingBidVol shares)",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      text: "Current Lowest Offer: ",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor),
                      children: [
                        TextSpan(
                          text:
                              "$latestOutstandingOffer ($latestOutstandingOfferVol shares)",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
        outstandingPriceChart,
        outstandingVolumeChart,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Outstanding Trades'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: view,
        isLoading: _loading,
      ),
    );
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
          updateOutstandingTradeDataCharts(context);
        });
      },
    );
  }

  void updateOutstandingTradeDataCharts(BuildContext context) {
    OutstandingTradesAPI.fetchOutstandingTradeData(selectedSymbol, dateRange)
        .then((List outstandingTradeData) {
      //update the latest trade data
      Map? latestOutstandingTrade = outstandingTradeData.last;
      if (latestOutstandingTrade != null) {
        if (latestOutstandingTrade['os_bid'] != null) {
          latestOutstandingBid = "\$" +
              dollarFormat.format(latestOutstandingTrade['os_bid']) +
              " ";
        } else {
          latestOutstandingBid = 'N.A ';
        }
        if (latestOutstandingTrade['os_bid_vol'] != null) {
          latestOutstandingBidVol =
              shareFormat.format(latestOutstandingTrade['os_bid_vol']);
        } else {
          latestOutstandingBidVol = '(N.A)';
        }
        if (latestOutstandingTrade['os_offer'] != null) {
          latestOutstandingOffer = "\$" +
              dollarFormat.format(latestOutstandingTrade['os_offer']) +
              " ";
        } else {
          latestOutstandingOffer = 'N.A ';
        }
        if (latestOutstandingTrade['os_offer_vol'] != null) {
          latestOutstandingOfferVol =
              shareFormat.format(latestOutstandingTrade['os_offer_vol']);
        } else {
          latestOutstandingOfferVol = 'N.A';
        }
      }
      //now update the two charts
      outstandingPriceChart = OutstandingPricesAreaChart(
        outstandingTradeData,
        animate: true,
      );
      outstandingVolumeChart = OutstandingVolumeChart(
        outstandingTradeData,
        animate: true,
      );
      setState(() {
        symbolDropdownButtonBuilt = true;
        _loading = false;
      });
    });
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
          value: OutstandingTradesRange.oneWeek,
          child: Text(
            OutstandingTradesRange.oneWeek,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: OutstandingTradesRange.oneMonth,
          child: Text(
            OutstandingTradesRange.oneMonth,
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: OutstandingTradesRange.oneYear,
          child: Text(
            OutstandingTradesRange.oneYear,
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
          updateOutstandingTradeDataCharts(context);
        });
      },
    );
  }

  Widget buildIndexNameDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: selectedSymbol,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).accentColor,
      ),
      items: [
        new DropdownMenuItem<String>(
          value: 'Composite Totals',
          child: Text(
            'Composite Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'All T%26T Totals',
          child: Text(
            'All T&T Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Cross-Listed Totals',
          child: Text(
            'Cross-Listed Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Mutual Funds Totals',
          child: Text(
            'Mutual Funds Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Second Tier Totals',
          child: Text(
            'Second Tier Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Non Sector Totals',
          child: Text(
            'Non Sector Totals',
            style: TextStyle(fontSize: buttonBarLabelSize),
          ),
        ),
        new DropdownMenuItem<String>(
          value: 'Usd Equity Totals',
          child: Text(
            'USD Equity Totals',
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
          selectedSymbol = newValue!;
          updateOutstandingTradeDataCharts(context);
        });
      },
    );
  }
}
