import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trinistocks_flutter/apis/profile_management_api.dart';

class SimulatorGamesAPI {
  SimulatorGamesAPI() {}

  static Future<Map> createSimulatorGame(String gameName, String dateEnded,
      bool? private, int? gameCode, double startingCash) async {
    //ensure that the user is signed in
    return ProfileManagementAPI.checkUserLoggedIn().then(
      (Map userInfo) async {
        try {
          if (userInfo['isLoggedIn'] = true) {
            String url = 'https://trinistocks.com/api/simulatorgames';
            final apiToken = userInfo['token'];
            Map simulatorGamePostData = {};
            simulatorGamePostData['game_name'] = gameName;
            simulatorGamePostData['date_ended'] = dateEnded;
            simulatorGamePostData['starting_cash'] = startingCash.toString();
            if (private == true) {
              simulatorGamePostData['private'] = "True";
              simulatorGamePostData['game_code'] = gameCode.toString();
            }
            var simulatorGameResponse = await http.post(url,
                headers: {"Authorization": "Token $apiToken"},
                body: simulatorGamePostData);
            Map apiResponse = {};
            apiResponse = json.decode(simulatorGameResponse.body);
            if (simulatorGameResponse.statusCode == 201) {
              //also create a new simulator player id for this game
              Map simulatorPlayerPostData = {};
              simulatorPlayerPostData['liquid_cash'] = startingCash.toString();
              simulatorPlayerPostData['game_name'] = gameName;
              url = 'https://trinistocks.com/api/simulatorplayers';
              var simulatorPlayerResponse = await http.post(url,
                  headers: {"Authorization": "Token $apiToken"},
                  body: simulatorPlayerPostData);
              apiResponse.addAll(json.decode(simulatorPlayerResponse.body));
              if (simulatorPlayerResponse.statusCode == 201) {
                apiResponse['message'] = "Success";
              } else {
                String errorMessages = "";
                apiResponse.forEach((key, value) {
                  errorMessages += value[0];
                });
                throw Exception(errorMessages);
              }
            } else {
              String errorMessages = "";
              apiResponse.forEach((key, value) {
                errorMessages += key;
                errorMessages += value[0];
              });
              throw Exception(errorMessages);
            }
            return apiResponse;
          } else {
            throw Exception('Please ensure that you are logged in!');
          }
        } catch (e) {
          return {'message': e.toString()};
        }
      },
    );
  }

  static Future<Map> joinSimulatorGame(String gameName, int? gameCode) async {
    //ensure that the user is signed in
    return ProfileManagementAPI.checkUserLoggedIn().then(
      (Map userInfo) async {
        try {
          if (userInfo['isLoggedIn'] = true) {
            // first perform a get request on the simulator game
            String url = 'https://trinistocks.com/api/simulatorgames';
            final apiToken = userInfo['token'];
            var response = await http
                .get(url, headers: {"Authorization": "Token $apiToken"});
            List apiResponse = [];
            if (response.statusCode == 200) {
              apiResponse = json.decode(response.body);
            } else {
              throw Exception("Could not GET API data from $url");
            }
            //now check through the apiResponse and search for the game requested
            bool gameFound = false;
            for (Map game in apiResponse) {
              if (game['game_name'] == gameName) {
                if (game['game_code'] == gameCode) {
                  gameFound = true;
                } else {
                  throw Exception("Game code is incorrect.");
                }
              }
            }
            if (gameFound == false) {
              throw Exception("No game with that name found");
            } else {
              //we have found the game and verified the code, so go ahead and add this player to the game
              return {"message": "Successfully joined game!"};
            }
            //     //we only need to create a new simulator player for the join process
            //     Map simulatorPlayerPostData = {};
            //     simulatorPlayerPostData['liquid_cash'] = startingCash.toString();
            //     simulatorPlayerPostData['game_name'] = gameName;
            //     url = 'https://trinistocks.com/api/simulatorplayers';
            //     var simulatorPlayerResponse = await http.post(url,
            //         headers: {"Authorization": "Token $apiToken"},
            //         body: simulatorPlayerPostData);
            //     apiResponse.addAll(json.decode(simulatorPlayerResponse.body));
            //     if (simulatorPlayerResponse.statusCode == 201) {
            //       apiResponse['message'] = "Success";
            //     } else {
            //       String errorMessages = "";
            //       apiResponse.forEach((key, value) {
            //         errorMessages += value[0];
            //       });
            //       throw Exception(errorMessages);
            //     }
            //   } else {
            //     String errorMessages = "";
            //     apiResponse.forEach((key, value) {
            //       errorMessages += key;
            //       errorMessages += value[0];
            //     });
            //     throw Exception(errorMessages);
            //   }
            //   return apiResponse;
          } else {
            throw Exception('Please ensure that you are logged in!');
          }
        } catch (e) {
          return {'error': e.toString()};
        }
      },
    );
  }

  static Future<Map> getAllSimulatorGamesAndPlayers() async {
    //ensure that the user is signed in
    return ProfileManagementAPI.checkUserLoggedIn().then(
      (Map userInfo) async {
        try {
          if (userInfo['isLoggedIn'] = true) {
            String url = 'https://trinistocks.com/api/simulatorgames';
            final apiToken = userInfo['token'];
            var response = await http
                .get(url, headers: {"Authorization": "Token $apiToken"});
            if (response.statusCode == 200) {
              List allSimulatorGames = json.decode(response.body);
              //ensure that we only display the games that the user is a part of
              url = 'https://trinistocks.com/api/simulatorplayers';
              //first get all the simulator players for this user
              response = await http
                  .get(url, headers: {"Authorization": "Token $apiToken"});
              if (response.statusCode == 200) {
                List allSimulatorPlayers = json.decode(response.body);
                Map returnData = {};
                returnData['simulatorPlayers'] = allSimulatorPlayers;
                returnData['simulatorGames'] = allSimulatorGames;
                return returnData;
              } else {
                throw Exception("Could not GET API data from $url");
              }
            } else if (response.statusCode == 500) {
              throw Exception(
                  "No games found. Create/Join a game today to get started!");
            } else {
              throw Exception("Could not GET API data from $url");
            }
          } else {
            return {'error': 'Please ensure that you are logged in!'};
          }
        } catch (e) {
          return {'error': e.toString()};
        }
      },
    );
  }

  static Future<List> getJoinedSimulatorGames() async {
    //ensure that the user is signed in
    return ProfileManagementAPI.checkUserLoggedIn().then(
      (Map userInfo) async {
        try {
          if (userInfo['isLoggedIn'] = true) {
            String url = 'https://trinistocks.com/api/simulatorgames';
            final apiToken = userInfo['token'];
            var response = await http
                .get(url, headers: {"Authorization": "Token $apiToken"});
            if (response.statusCode == 200) {
              List allSimulatorGames = json.decode(response.body);
              //ensure that we only display the games that the user is a part of
              url = 'https://trinistocks.com/api/simulatorplayers';
              //first get all the simulator players for this user
              response = await http
                  .get(url, headers: {"Authorization": "Token $apiToken"});
              if (response.statusCode == 200) {
                List allSimulatorPlayers = json.decode(response.body);
                // now compare the players and games and get the games that were joined
                List allJoinedSimulatorGames = [];
                for (Map simulatorGame in allSimulatorGames) {
                  for (Map simulatorPlayer in allSimulatorPlayers) {
                    if (simulatorPlayer['simulator_game'] ==
                        simulatorGame['game_id']) {
                      allJoinedSimulatorGames.add(simulatorGame);
                    }
                  }
                }
                return allJoinedSimulatorGames;
              } else {
                throw Exception("Could not GET API data from $url");
              }
            } else if (response.statusCode == 500) {
              throw Exception(
                  "No games found. Create/Join a game today to get started!");
            } else {
              throw Exception("Could not GET API data from $url");
            }
          } else {
            return [
              {'error': 'Please ensure that you are logged in!'}
            ];
          }
        } catch (e) {
          return [
            {'error': e.toString()}
          ];
        }
      },
    );
  }
}
