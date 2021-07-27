import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:trinistocks_flutter/widgets/simulator_games_rankings_datatable.dart';
import 'package:trinistocks_flutter/widgets/simulator_games_rankings_horizontal_barchart.dart';

class SimulatorGamesRankingsPage extends StatefulWidget {
  SimulatorGamesRankingsPage({Key? key}) : super(key: key);

  @override
  _SimulatorGamesRankingsPageState createState() =>
      _SimulatorGamesRankingsPageState();
}

class _SimulatorGamesRankingsPageState extends State<SimulatorGamesRankingsPage>
    with AfterLayoutMixin<SimulatorGamesRankingsPage> {
  bool _loading = true;
  Widget portfolioValueBarchart = Text("");
  late FToast fToast;
  Map? simulatorGame;
  String? gameName;
  Widget simulatorGameBarChart = Text("");
  Widget simulatorGameRankings = Column();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simulator Game Rankings"),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: simulatorGameBarChart,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: simulatorGameRankings,
            ),
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
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    simulatorGame = args['simulatorGame'];
    gameName = simulatorGame!['game_name'];
    SimulatorGamesAPI.getSimulatorPlayersInGame(gameName!).then(
      (Map returnValue) {
        if (returnValue.containsKey('error')) {
          fToast.showToast(
            child: returnToast(returnValue['error'], false),
            toastDuration: Duration(seconds: 5),
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          setState(() {
            simulatorGameBarChart = SimulatorGamesRankingsHorizontalBarChart(
                returnValue['simulatorPlayerData']);
            _loading = false;
            simulatorGameRankings = SimulatorGamesRankingsDataTable(
                tableData: returnValue['simulatorPlayerData'],
                headerColor: Theme.of(context).primaryColor,
                leftHandColor: Theme.of(context).highlightColor);
          });
        }
      },
    );
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
}
