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
              style: TextStyle(fontSize: buttonBarLabelSize),
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
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: [
                      Text(
                        "Symbol",
                        style: TextStyle(
                          fontSize: buttonBarLabelSize,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 5, bottom: 5, left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: buildSymbolDropdownButton(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: [
                      Text(
                        "Range",
                        style: TextStyle(
                          fontSize: buttonBarLabelSize,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 5, bottom: 5, left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: startDateDropdownButton(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          margin: EdgeInsets.only(left: 25, right: 25),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: RichText(
                        text: TextSpan(
                          text: "Current Highest Bid: ",
                          style: TextStyle(color: Theme.of(context).cardColor),
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
                          style: TextStyle(color: Theme.of(context).cardColor),
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
              ],
            ),
          ),
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
        FontAwesomeIcons.chevronDown,
      ),
      items: listedSymbols,
      underline: Text(""),
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
        animate: false,
      );
      outstandingVolumeChart = OutstandingVolumeChart(
        outstandingTradeData,
        animate: false,
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
        FontAwesomeIcons.chevronDown,
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
      underline: Text(""),
      onChanged: (String? newValue) {
        setState(() {
          _loading = true;
          dateRange = newValue!;
          updateOutstandingTradeDataCharts(context);
        });
      },
    );
  }
}
