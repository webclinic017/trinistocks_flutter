import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/profile_management_api.dart';
import 'package:trinistocks_flutter/apis/simulator_games_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SimulatorGameCreatePage extends StatefulWidget {
  SimulatorGameCreatePage({Key? key}) : super(key: key);

  @override
  _SimulatorGameCreatePageState createState() =>
      _SimulatorGameCreatePageState();
}

class _SimulatorGameCreatePageState extends State<SimulatorGameCreatePage> {
  bool isLoading = false;
  String? username;
  String? email;
  String? token;
  late FToast fToast;
  String cardView = "Login";
  late Card profileCardView;
  late Card deleteConfirmCardView;
  TextEditingController gameNameController =
      new TextEditingController(text: "");
  TextEditingController gameCodeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController(
      text: DateTime.now().add(Duration(days: 30)).toString().substring(0, 10));
  TextEditingController startingCashController =
      new TextEditingController(text: "10000");
  bool? isPrivate = true;

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
        title: Text('Create New Simulator Game'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      body: LoadingOverlay(
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Theme.of(context).accentColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 20,
                      bottom: 10,
                    ),
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
                      controller: gameNameController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: CheckboxListTile(
                      value: isPrivate,
                      onChanged: (value) {
                        setState(() {
                          isPrivate = value;
                        });
                      },
                      title: Text("Private Game"),
                      secondary: FaIcon(FontAwesomeIcons.userSecret),
                    ),
                  ),
                  isPrivate!
                      ? Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 20,
                            bottom: 10,
                          ),
                          child: TextFormField(
                            style: TextStyle(decorationColor: Colors.red),
                            decoration: const InputDecoration(
                              icon: FaIcon(
                                FontAwesomeIcons.key,
                                size: 30,
                              ),
                              labelText: 'Secret 6 Digit Code',
                              hintText: 'eg. 123456',
                              border: OutlineInputBorder(),
                            ),
                            controller: gameCodeController,
                            obscureText: true,
                          ),
                        )
                      : Text(""),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 20,
                      bottom: 10,
                    ),
                    child: TextFormField(
                      readOnly: true,
                      controller: dateController,
                      decoration: const InputDecoration(
                        icon: FaIcon(
                          FontAwesomeIcons.calendar,
                          size: 30,
                        ),
                        labelText: 'Date Game Ending',
                        hintText: 'eg. 01/01/2099',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            Duration(days: 365),
                          ),
                        );
                        try {
                          dateController.text =
                              date.toString().substring(0, 10);
                        } catch (e) {}
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 20,
                      bottom: 10,
                    ),
                    child: TextFormField(
                      controller: startingCashController,
                      decoration: const InputDecoration(
                        icon: FaIcon(
                          FontAwesomeIcons.coins,
                          size: 30,
                        ),
                        labelText: 'Starting Cash (TTD)',
                        hintText: 'eg. 10000',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: Row(
                            children: [
                              FaIcon(FontAwesomeIcons.plusSquare),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Create Game",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(15)),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).toggleableActiveColor),
                          ),
                          onPressed: () {
                            //do some prechecks before submitting the data
                            int? gameCode;
                            double startingCash;
                            try {
                              if (gameNameController.text == '') {
                                throw FormatException(
                                    "Please enter a name for your game!");
                              }
                              if (isPrivate! && gameCodeController.text == '') {
                                throw FormatException(
                                    "Please enter a secret code for your private game!");
                              } else if (isPrivate!) {
                                try {
                                  gameCode = int.parse(gameCodeController.text);
                                  if (gameCode < 000000 || gameCode > 999999) {
                                    throw FormatException();
                                  }
                                } catch (e) {
                                  throw FormatException(
                                      "Please ensure that you have entered a valid positive 6 digit integer for the game code!");
                                }
                              }
                              if (dateController.text == '') {
                                throw FormatException(
                                    "Please enter a date when your game will end!");
                              }
                              if (startingCashController.text == '') {
                                throw FormatException(
                                    "Please enter the amount of starting cash to give each player!");
                              } else {
                                try {
                                  startingCash =
                                      double.parse(startingCashController.text);
                                } catch (e) {
                                  throw FormatException(
                                      "Please enter a valid number for the starting cash!");
                                }
                              }
                              isLoading = true;
                              SimulatorGamesAPI.createSimulatorGame(
                                      gameNameController.text,
                                      dateController.text,
                                      isPrivate,
                                      gameCode,
                                      startingCash)
                                  .then(
                                (returnValue) {
                                  if (returnValue['message'] == "Success") {
                                    fToast.showToast(
                                      child: returnToast(
                                          "Successfully created new simulator game!",
                                          true),
                                      toastDuration: Duration(seconds: 2),
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    Navigator.pushReplacementNamed(
                                        context, '/simulator_games');
                                  } else {
                                    fToast.showToast(
                                      child: returnToast(
                                          returnValue['message'], false),
                                      toastDuration: Duration(seconds: 5),
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              );
                            } catch (e) {
                              fToast.showToast(
                                child: returnToast(e.toString(), false),
                                toastDuration: Duration(seconds: 5),
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: Row(children: [
                            FaIcon(FontAwesomeIcons.arrowLeft),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text("Back"),
                            ),
                          ]),
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(5)),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/simulator_games');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        isLoading: isLoading,
      ),
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
