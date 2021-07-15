import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:trinistocks_flutter/apis/listed_stocks_api.dart';
import 'package:trinistocks_flutter/apis/portfolio_api.dart';
import 'package:trinistocks_flutter/apis/profile_management_api.dart';
import 'package:trinistocks_flutter/apis/simulator_games_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:after_layout/after_layout.dart';

class SimulatorTransactionsPage extends StatefulWidget {
  SimulatorTransactionsPage({Key? key}) : super(key: key);

  @override
  _SimulatorTransactionsPageState createState() =>
      _SimulatorTransactionsPageState();
}

class _SimulatorTransactionsPageState extends State<SimulatorTransactionsPage>
    with AfterLayoutMixin<SimulatorTransactionsPage> {
  bool isLoading = true;
  TextEditingController numSharesController = new TextEditingController();
  late FToast fToast;
  String cardView = "Initial";
  late Card initialCardView;
  late Card reviewCardView;
  bool reviewConfirmEnabled = false;
  List<DropdownMenuItem<String>> listedSymbols = [];
  List<Map> portfolioSymbols = [];
  List<Map> symbolsandPrices = [];
  String selectedSymbol = 'AGL';
  double? selectedSymbolPrice;
  double? totalCost;
  double? remainingCash;
  Color? totalCostColor;
  String buyOrSell = 'Buy';
  double buttonBarLabelSize = 16;
  double spacing = 20.0;
  Map? simulatorGame;
  List? simulatorPortfolioData;
  Map? simulatorPlayerData;
  double? liquidCash;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    ListedStocksAPI.fetchListedStockSymbolsAndLatestPrices()
        .then((List<Map> symbolsAndPrices) {
      this.symbolsandPrices = symbolsAndPrices;
      for (Map symbolData in symbolsAndPrices) {
        listedSymbols.add(
          new DropdownMenuItem<String>(
            value: symbolData['symbol'],
            child: Text(
              symbolData['symbol'],
              style: TextStyle(),
            ),
          ),
        );
      }
      setState(() {
        updateLatestPrice(context);
        isLoading = false;
      });
    });
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    simulatorGame = args['simulatorGame'];
    initialCardView = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Table(
              border: TableBorder(),
              columnWidths: {0: FixedColumnWidth(130)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Text(
                      "Symbol",
                      style: TextStyle(fontSize: buttonBarLabelSize),
                    ),
                    buildSymbolDropdownButton(context),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "Current Price",
                      style: TextStyle(fontSize: buttonBarLabelSize),
                    ),
                    SizedBox(
                      width: 200,
                      height: 20,
                      child: Text(
                        "\$" + selectedSymbolPrice.toString(),
                        style: TextStyle(fontSize: buttonBarLabelSize),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "Buy or Sell?",
                      style: TextStyle(fontSize: buttonBarLabelSize),
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: this.buyOrSell,
                      icon: FaIcon(
                        FontAwesomeIcons.arrowAltCircleDown,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: "Buy",
                          child: Text("Buy "),
                        ),
                        DropdownMenuItem(
                          value: "Sell",
                          child: Text("Sell "),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSymbol = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
                TableRow(children: [
                  Text(
                    "Number of shares",
                    style: TextStyle(fontSize: buttonBarLabelSize),
                  ),
                  SizedBox(
                    width: 200,
                    height: 65,
                    child: TextFormField(
                      controller: numSharesController,
                      decoration: const InputDecoration(
                        labelText: 'Shares to buy/sell',
                        hintText: "100",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of shares';
                        }
                        int? numShares = int.tryParse(value);
                        if (numShares == null) {
                          return 'Please enter a valid number of shares';
                        }
                        return null;
                      },
                    ),
                  ),
                ]),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              child: Text(
                "Review",
                style: TextStyle(color: Theme.of(context).backgroundColor),
              ),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.deepOrange)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(
                    () {
                      try {
                        int numShares = int.parse(numSharesController.text);
                        cardView = "Review";
                        //perform calculations/prechecks on transaction
                        if (buyOrSell == "Sell") {
                          //ensure that the user has sufficient shares to sell etc.
                        } else {
                          //else this is a buy transaction
                          //first calculate the total cost of the buy order
                          totalCost = numShares * selectedSymbolPrice!;
                          if (totalCost! < liquidCash!) {
                            remainingCash = liquidCash! - totalCost!;
                            fToast.showToast(
                              child:
                                  returnToast("Transaction looks good!", true),
                              toastDuration: Duration(seconds: 5),
                              gravity: ToastGravity.BOTTOM,
                            );
                            totalCostColor = Colors.green;
                            //enable the confirm button if the transaction passes all the checks
                            reviewConfirmEnabled = true;
                          } else {
                            totalCostColor = Colors.red;
                            //enable the confirm button if the transaction passes all the checks
                            reviewConfirmEnabled = false;
                            throw StdinException(
                                "Your total cost exceeds your remaining cash.");
                          }
                        }
                      } catch (e) {
                        fToast.showToast(
                          child: returnToast("Error! ${e.toString()}", false),
                          toastDuration: Duration(seconds: 5),
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
    reviewCardView = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Table(
              border: TableBorder(),
              columnWidths: {0: FixedColumnWidth(130)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Text(
                      "Symbol",
                      style: TextStyle(fontSize: buttonBarLabelSize),
                    ),
                    Text(selectedSymbol),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "Current Price",
                      style: TextStyle(fontSize: buttonBarLabelSize),
                    ),
                    Text("\$" + selectedSymbolPrice.toString()),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "Buy or Sell?",
                      style: TextStyle(fontSize: buttonBarLabelSize),
                    ),
                    Text(buyOrSell),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
                TableRow(children: [
                  Text(
                    "Number of shares",
                    style: TextStyle(fontSize: buttonBarLabelSize),
                  ),
                  Text(numSharesController.text),
                ]),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "Total cost",
                      style: TextStyle(fontSize: buttonBarLabelSize),
                    ),
                    Text("\$" + totalCost.toString()),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "Remaining cash",
                      style: TextStyle(fontSize: buttonBarLabelSize),
                    ),
                    Text("\$" + remainingCash.toString()),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(
                    "Cancel/Modify",
                    style: TextStyle(color: Theme.of(context).backgroundColor),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () {
                    setState(() {
                      cardView = "Initial";
                      isLoading = false;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Theme.of(context).backgroundColor),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: reviewConfirmEnabled
                      ? () {
                          isLoading = true;
                          //first ensure that correct values have been put in the numshares and price fields
                          try {
                            if (numSharesController.text == '') {
                              throw FormatException(
                                  "Please enter the number of shares traded.");
                            }
                            int numShares = int.parse(numSharesController.text);
                            if (buyOrSell == "Sell") {
                              //add logic for selling shares in simulator
                            }
                            addSimulatorTransaction(
                                    selectedSymbol,
                                    buyOrSell,
                                    numShares,
                                    selectedSymbolPrice!,
                                    remainingCash!)
                                .then(
                              (Map returnValue) {
                                String? returnMessage = returnValue['message'];
                                isLoading = false;
                                if (returnMessage != null) {
                                  fToast.showToast(
                                    child: returnToast(returnMessage, false),
                                    toastDuration: Duration(seconds: 5),
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                } else {
                                  fToast.showToast(
                                    child: returnToast(
                                        "Transaction added successfully!",
                                        true),
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: Duration(seconds: 2),
                                  );
                                  Navigator.pushNamed(
                                      context, '/simulator_portfolio_summary',
                                      arguments: {'game': simulatorGame});
                                }
                              },
                            );
                          } catch (e) {
                            fToast.showToast(
                              child: returnToast(e.toString(), false),
                              toastDuration: Duration(seconds: 5),
                              gravity: ToastGravity.BOTTOM,
                            );
                          }
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio Transactions'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Theme.of(context).accentColor),
                  ),
                  child: Table(
                    border: TableBorder(
                        horizontalInside: BorderSide(
                            width: 1.0, color: Theme.of(context).accentColor)),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Game:",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Center(
                            child: Text(simulatorGame?["game_name"],
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Date Created:",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Center(
                            child: Text(simulatorGame?["date_created"],
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Date Ending:",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Center(
                            child: Text(simulatorGame?["date_ended"],
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Liquid Cash:",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Center(
                            child: Text(liquidCash.toString(),
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                checkCardView(),
                Padding(
                  padding: EdgeInsets.only(left: 100, right: 100),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    icon: FaIcon(FontAwesomeIcons.arrowLeft),
                    label: Text("Back"),
                  ),
                ),
              ],
            ),
          ),
        ),
        isLoading: isLoading,
      ),
    );
  }

  Widget checkCardView() {
    if (cardView == "Review") {
      return reviewCardView;
    } else {
      return initialCardView;
    }
  }

  Widget returnToast(String text, bool success) {
    Widget toast = Text("");
    if (success) {
      toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.green,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.check),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Text(text),
            ),
          ],
        ),
      );
    } else {
      toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.red,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.exclamation),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Text(text),
            ),
          ],
        ),
      );
    }
    return toast;
  }

  Widget buildSymbolDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: this.selectedSymbol,
      isExpanded: true,
      icon: FaIcon(
        FontAwesomeIcons.arrowAltCircleDown,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      items: listedSymbols,
      onChanged: (String? newValue) {
        setState(() {
          selectedSymbol = newValue!;
          updateLatestPrice(context);
        });
      },
    );
  }

  void updateLatestPrice(BuildContext context) {
    for (Map symbolData in symbolsandPrices) {
      if (symbolData['symbol'] == selectedSymbol) {
        setState(() {
          selectedSymbolPrice = double.parse(symbolData['close_price']);
        });
      }
    }
  }

  Future<Map> addSimulatorTransaction(String symbol, String buyOrSell,
      int numShares, double sharePrice, double liquidCashRemaining) {
    Map transactionData = {
      'symbol': symbol,
      'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
      'bought_or_sold': buyOrSell,
      'num_shares': numShares.toString(),
      'share_price': sharePrice.toString(),
      'game_name': simulatorGame?['game_name'],
    };
    Map simulatorGameData = {
      'game_name': simulatorGame?['game_name'],
      'liquid_cash': liquidCashRemaining.toString(),
    };
    return SimulatorGamesAPI.addSimulatorTransaction(
        transactionData, simulatorGameData);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    SimulatorGamesAPI.getSimulatorPlayerAndPortfolioData(
            simulatorGame!['game_name'], simulatorGame!['game_id'])
        .then((Map returnValue) {
      simulatorPlayerData = returnValue['simulatorPlayerData'];
      simulatorPortfolioData = returnValue['simulatorPortfolioData'];
      setState(() {
        liquidCash = double.parse(simulatorPlayerData!['liquid_cash']);
      });
    });
  }
}
