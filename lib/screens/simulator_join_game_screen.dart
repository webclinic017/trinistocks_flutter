import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/profile_management_api.dart';
import 'package:trinistocks_flutter/apis/simulator_games_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SimulatorJoinGamePage extends StatefulWidget {
  SimulatorJoinGamePage({Key? key}) : super(key: key);

  @override
  _SimulatorJoinGamePageState createState() => _SimulatorJoinGamePageState();
}

class _SimulatorJoinGamePageState extends State<SimulatorJoinGamePage> {
  bool isLoading = false;
  String? username;
  String? email;
  String? token;
  late FToast fToast;
  String cardViewName = "Initial";
  late Card initialCardView;
  late Card privateSearchCardView;
  late Card publicGamesCardView;
  bool? isPrivate = true;
  TextEditingController privateGameNameController = TextEditingController();
  TextEditingController privateGameCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<TableRow> publicGameRows = [];

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Widget checkCardView() {
    if (cardViewName == "Private") {
      return privateSearchCardView;
    } else if (cardViewName == "Public") {
      return publicGamesCardView;
    } else {
      return initialCardView;
    }
  }

  @override
  Widget build(BuildContext context) {
    initialCardView = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(100, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.teal)),
              onPressed: () {
                setState(() {
                  cardViewName = "Private";
                });
              },
              icon: FaIcon(FontAwesomeIcons.doorClosed),
              label: Text("Join Private Game"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(100, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.purple)),
              onPressed: () {
                setState(() {
                  getPublicSimulatorGames();
                  cardViewName = "Public";
                });
              },
              icon: FaIcon(FontAwesomeIcons.doorOpen),
              label: Text("Search Public Games"),
            ),
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).accentColor)),
            onPressed: () {
              setState(() {
                Navigator.pushReplacementNamed(context, '/simulator_games');
              });
            },
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
            label: Text("Back"),
          ),
        ],
      ),
    );
    privateSearchCardView = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, right: 10, left: 5),
            child: TextFormField(
              style: TextStyle(decorationColor: Colors.red),
              decoration: const InputDecoration(
                icon: FaIcon(
                  FontAwesomeIcons.chessBoard,
                  size: 30,
                ),
                labelText: 'Game Name',
                hintText: 'eg. My New trinistocks Game',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the game name';
                }
                return null;
              },
              controller: privateGameNameController,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, right: 10, left: 5, bottom: 10),
            child: TextFormField(
              style: TextStyle(decorationColor: Colors.red),
              decoration: const InputDecoration(
                icon: FaIcon(
                  FontAwesomeIcons.key,
                  size: 30,
                ),
                labelText: 'Game Code',
                hintText: 'eg. 123456',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the game code';
                }
                if (int.tryParse(value) == null) {
                  return "Enter a valid 6-digit integer";
                }
                return null;
              },
              controller: privateGameCodeController,
            ),
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(100, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.purple)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                joinPrivateSimulatorGame().then((Map returnValue) {
                  if (returnValue.containsKey("error")) {
                    fToast.showToast(
                      child: returnToast(returnValue["error"], false),
                      toastDuration: Duration(seconds: 5),
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else {
                    fToast.showToast(
                      child: returnToast(returnValue["message"], true),
                      toastDuration: Duration(seconds: 5),
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                });
              }
            },
            icon: FaIcon(FontAwesomeIcons.searchPlus),
            label: Text("Join Game"),
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).accentColor)),
            onPressed: () {
              setState(() {
                cardViewName = "Initial";
              });
            },
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
            label: Text("Back"),
          ),
        ],
      ),
    );
    publicGamesCardView = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 350,
            height: 375,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Table(
                border: TableBorder.all(color: Theme.of(context).accentColor),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: publicGameRows,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).accentColor)),
            onPressed: () {
              setState(() {
                cardViewName = "Initial";
              });
            },
            icon: FaIcon(FontAwesomeIcons.arrowLeft),
            label: Text("Back"),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Simulator Game'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      body: LoadingOverlay(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
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
                    bottom: 10,
                  ),
                ),
                checkCardView(),
              ],
            ),
          ),
        ),
        isLoading: isLoading,
      ),
    );
  }

  void getPublicSimulatorGames() async {
    return SimulatorGamesAPI.getAllSimulatorGamesAndPlayers().then(
      (Map returnValue) async {
        List<Map> publicGames = [];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? userId = int.parse(prefs.get('user_id').toString());
        //check the game code to see which ones are public games
        for (Map simulatorGame in returnValue['simulatorGames']) {
          //check if the user has already joined this game
          bool gameJoined = false;
          for (Map simulatorPlayer in returnValue['simulatorPlayers']) {
            if (simulatorPlayer['simulator_game'] == simulatorGame['game_id'] &&
                simulatorPlayer['user'] == userId) {
              gameJoined = true;
            }
          }
          if (gameJoined == false && simulatorGame['game_code'] == null) {
            //ensure that the user has not already joined these games
            publicGames.add(simulatorGame);
          }
        }
        //now build the table rows with this data
        publicGameRows.clear();
        for (Map game in publicGames) {
          publicGameRows.add(
            TableRow(
              children: <Widget>[
                Center(
                  child: Text(game["game_name"],
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    label: Text("Join"),
                    icon: FaIcon(FontAwesomeIcons.pen),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.brown),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        setState(() {});
      },
    );
  }

  Future<Map> joinPrivateSimulatorGame() {
    return SimulatorGamesAPI.joinSimulatorGame(privateGameNameController.text,
            int.tryParse(privateGameCodeController.text))
        .then((returnValue) {
      return returnValue;
    });
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
