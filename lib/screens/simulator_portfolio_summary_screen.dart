import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/portfolio_api.dart';
import 'package:trinistocks_flutter/apis/simulator_games_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:trinistocks_flutter/widgets/portfolio_book_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_gain_loss_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_market_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_sector_book_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_sector_gain_loss_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_sector_market_value_horizontal_barchart.dart';
import 'package:after_layout/after_layout.dart';

class SimulatorPortfolioSummaryPage extends StatefulWidget {
  SimulatorPortfolioSummaryPage({Key? key}) : super(key: key);

  @override
  _SimulatorPortfolioSummaryPageState createState() =>
      _SimulatorPortfolioSummaryPageState();
}

class _SimulatorPortfolioSummaryPageState
    extends State<SimulatorPortfolioSummaryPage>
    with AfterLayoutMixin<SimulatorPortfolioSummaryPage> {
  bool _loading = true;
  Widget marketValueBarchart = Text("");
  Widget sectorValueBarchart = Text("");
  Widget bookValueBarchart = Text("");
  Widget sectorBookValueBarchart = Text("");
  Widget gainLossBarchart = Text("");
  Widget sectorGainLossBarchart = Text("");
  Map? simulatorGame;
  List simulatorPortfolioData = [];
  List simulatorPortfolioSectorData = [];
  Map? simulatorPlayerData;
  String liquidCash = 'N/A';

  @override
  void initState() {
    super.initState();
    PortfolioAPI.fetchPortfolioSectorData().then((List sectorData) {
      setState(() {
        //build the market value horizontal barchart

        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    simulatorGame = args['game'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Simulator Portfolio Summary"),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: ListView(
          padding: const EdgeInsets.only(top: 10),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
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
                        child: Text(liquidCash,
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/simulator_transactions',
                        arguments: {'simulatorGame': simulatorGame});
                  },
                  icon: FaIcon(FontAwesomeIcons.cashRegister),
                  label: Text("Trade Stocks"),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/simulator_games_rankings',
                        arguments: {'simulatorGame': simulatorGame});
                  },
                  icon: FaIcon(FontAwesomeIcons.medal),
                  label: Text("Rankings"),
                ),
              ],
            ),
            marketValueBarchart,
            bookValueBarchart,
            gainLossBarchart,
            sectorValueBarchart,
            sectorBookValueBarchart,
            sectorGainLossBarchart,
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
        isLoading: _loading,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    SimulatorGamesAPI.getSimulatorPlayerAndPortfolioData(
            simulatorGame!['game_name'], simulatorGame!['game_id'])
        .then((Map returnValue) {
      simulatorPlayerData = returnValue['simulatorPlayerData'];
      simulatorPortfolioData = returnValue['simulatorPortfolioData'];
      simulatorPortfolioSectorData =
          returnValue['simulatorPortfolioSectorData'];
      setState(() {
        liquidCash = simulatorPlayerData!['liquid_cash'];
        marketValueBarchart =
            PortfolioMarketValueHorizontalBarChart(simulatorPortfolioData);
        bookValueBarchart =
            PortfolioBookValueHorizontalBarChart(simulatorPortfolioData);
        gainLossBarchart =
            PortfolioGainLossHorizontalBarChart(simulatorPortfolioData);
        sectorValueBarchart = PortfolioSectorMarketValueHorizontalBarChart(
            simulatorPortfolioSectorData);
        sectorBookValueBarchart = PortfolioSectorBookValueHorizontalBarChart(
            simulatorPortfolioSectorData);
        sectorGainLossBarchart = PortfolioSectorGainLossHorizontalBarChart(
            simulatorPortfolioSectorData);
      });
    });
  }
}
