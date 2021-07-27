import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:trinistocks_flutter/apis/profile_management_api.dart';
import 'package:trinistocks_flutter/apis/simulator_games_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SimulatorGamesPage extends StatefulWidget {
  SimulatorGamesPage({Key? key}) : super(key: key);

  @override
  _SimulatorGamesPageState createState() => _SimulatorGamesPageState();
}

class _SimulatorGamesPageState extends State<SimulatorGamesPage> {
  bool isLoading = false;
  List<TableRow> activeSimulatorGames = [];
  List<TableRow> inactiveSimulatorGames = [];
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    fetchCurrentGamesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulator Games'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Image(
                    image: AssetImage(
                      'assets/images/stocks_dashboard.jpg',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/simulator_game_create');
                      },
                      icon: FaIcon(FontAwesomeIcons.plus),
                      label: Text("Create New Game"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green[700]),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/simulator_game_join');
                      },
                      icon: FaIcon(FontAwesomeIcons.searchPlus),
                      label: Text("Join Game"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange[700]),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text("Current Games",
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Table(
                    border:
                        TableBorder.all(color: Theme.of(context).shadowColor),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: activeSimulatorGames,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text("Past Games",
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, bottom: 10),
                  child: Table(
                    border:
                        TableBorder.all(color: Theme.of(context).shadowColor),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: inactiveSimulatorGames,
                  ),
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
          ),
        ),
        isLoading: isLoading,
      ),
    );
  }

  void fetchCurrentGamesList() {
    SimulatorGamesAPI.getJoinedSimulatorGames().then(
      (List returnValue) {
        Map firstReturnValue = returnValue[0];
        if (firstReturnValue.containsKey("error")) {
          fToast.showToast(
            child: returnToast(firstReturnValue["error"], false),
            toastDuration: Duration(seconds: 5),
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          List<TableRow> fetchedActiveSimulatorGames = [];
          List<TableRow> fetchedInactiveSimulatorGames = [];
          for (Map game in returnValue) {
            if (game['is_active']) {
              fetchedActiveSimulatorGames.add(
                TableRow(
                  children: <Widget>[
                    Center(
                      child: Text(game["game_name"],
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/simulator_portfolio_summary',
                              arguments: {'game': game});
                        },
                        label: Text("Manage"),
                        icon: FaIcon(FontAwesomeIcons.pen),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.brown),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              fetchedInactiveSimulatorGames.add(
                TableRow(
                  children: <Widget>[
                    Center(
                      child: Text(game["game_name"],
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/simulator_portfolio_summary',
                              arguments: {'game': game});
                        },
                        label: Text("Manage"),
                        icon: FaIcon(FontAwesomeIcons.pen),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.brown),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          if (fetchedInactiveSimulatorGames.isEmpty) {
            fetchedInactiveSimulatorGames = [
              TableRow(children: [Text(""), Text("")])
            ];
          }
          this.setState(
            () {
              this.activeSimulatorGames = fetchedActiveSimulatorGames;
              this.inactiveSimulatorGames = fetchedInactiveSimulatorGames;
            },
          );
        }
        ;
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
