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
            Map? gameToJoin;
            for (Map game in apiResponse) {
              if (game['game_name'] == gameName) {
                if (game['game_code'] == gameCode) {
                  gameFound = true;
                  gameToJoin = game;
                } else {
                  throw Exception("Game code is incorrect.");
                }
              }
            }
            if (gameFound == false || gameToJoin == null) {
              throw Exception("No game with that name found");
            } else {
              //we have found the game and verified the code, so go ahead and add this user to the game
              // we have to create a new simulator player for this user and this game
              Map simulatorPlayerPostData = {};
              simulatorPlayerPostData['liquid_cash'] =
                  gameToJoin['starting_cash'].toString();
              simulatorPlayerPostData['game_name'] = gameToJoin['game_name'];
              url = 'https://trinistocks.com/api/simulatorplayers';
              var simulatorPlayerResponse = await http.post(url,
                  headers: {"Authorization": "Token $apiToken"},
                  body: simulatorPlayerPostData);
              Map gameJoinResponse = json.decode(simulatorPlayerResponse.body);
              if (simulatorPlayerResponse.statusCode == 201) {
                return {"message": "Successfully joined game!"};
              } else {
                String errorMessages = "";
                gameJoinResponse.forEach((key, value) {
                  errorMessages += value[0];
                });
                throw Exception(errorMessages);
              }
            }
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

  static Future<Map> getSimulatorPlayerAndPortfolioData(
      String gameName, int gameId) async {
    //ensure that the user is signed in
    return ProfileManagementAPI.checkUserLoggedIn().then(
      (Map userInfo) async {
        try {
          if (userInfo['isLoggedIn'] = true) {
            String url = 'https://trinistocks.com/api/simulatorplayers';
            final apiToken = userInfo['token'];
            var response = await http
                .get(url, headers: {"Authorization": "Token $apiToken"});
            if (response.statusCode == 200) {
              List allSimulatorPlayers = json.decode(response.body);
              //check for the simulator player that matches the current gameName
              Map? simulatorPlayerData;
              for (Map simulatorPlayer in allSimulatorPlayers) {
                if (simulatorPlayer['simulator_game'] == gameId) {
                  simulatorPlayerData = simulatorPlayer;
                }
              }
              //also get the portfolio data for this gameName
              url =
                  'https://trinistocks.com/api/simulatorportfolios?game_name=$gameName';
              //first get all the simulator players for this user
              response = await http
                  .get(url, headers: {"Authorization": "Token $apiToken"});
              if (response.statusCode == 200) {
                List simulatorPortfolioData = json.decode(response.body);
                //ensure the datatypes are correct
                for (Map symbolData in simulatorPortfolioData) {
                  symbolData['average_cost'] =
                      double.tryParse(symbolData['average_cost']);
                  symbolData['book_cost'] =
                      double.tryParse(symbolData['book_cost']);
                  symbolData['current_market_price'] =
                      double.tryParse(symbolData['current_market_price']);
                  symbolData['market_value'] =
                      double.tryParse(symbolData['market_value']);
                  symbolData['total_gain_loss'] =
                      double.tryParse(symbolData['total_gain_loss']);
                  symbolData['gain_loss_percent'] =
                      double.tryParse(symbolData['gain_loss_percent']);
                }
                //also get the portfolio sector data for this game name
                url =
                    'https://trinistocks.com/api/simulatorportfoliosectors?game_name=$gameName';
                //first get all the simulator players for this user
                response = await http
                    .get(url, headers: {"Authorization": "Token $apiToken"});
                if (response.statusCode == 200) {
                  List simulatorPortfolioSectorData =
                      json.decode(response.body);
                  for (Map sectorData in simulatorPortfolioSectorData) {
                    sectorData['book_cost'] =
                        double.tryParse(sectorData['book_cost']);
                    sectorData['market_value'] =
                        double.tryParse(sectorData['market_value']);
                    sectorData['total_gain_loss'] =
                        double.tryParse(sectorData['total_gain_loss']);
                    sectorData['gain_loss_percent'] =
                        double.tryParse(sectorData['gain_loss_percent']);
                  }
                  return {
                    'simulatorPlayerData': simulatorPlayerData,
                    'simulatorPortfolioData': simulatorPortfolioData,
                    'simulatorPortfolioSectorData': simulatorPortfolioSectorData
                  };
                  //also get the portfolio sector data for this game name
                } else {
                  throw Exception("Could not GET API data from $url");
                }
              } else {
                throw Exception("Could not GET API data from $url");
              }
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

  static Future<Map> getSimulatorPlayersInGame(String gameName) async {
    //ensure that the user is signed in
    return ProfileManagementAPI.checkUserLoggedIn().then(
      (Map userInfo) async {
        try {
          if (userInfo['isLoggedIn'] = true) {
            String url =
                'https://trinistocks.com/api/simulatorplayers?game_name=$gameName';
            final apiToken = userInfo['token'];
            var response = await http
                .get(url, headers: {"Authorization": "Token $apiToken"});
            if (response.statusCode == 200) {
              List allSimulatorPlayers = json.decode(response.body);
              return {'simulatorPlayerData': allSimulatorPlayers};
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

  static Future<Map> addSimulatorTransaction(
      Map transactionData, Map simulatorGameUpdate) async {
    //ensure that the user is signed in
    return ProfileManagementAPI.checkUserLoggedIn().then((Map userInfo) async {
      Map response = Map();
      if (userInfo['isLoggedIn'] = true) {
        //first set the new liquid cash for the simulator player
        String url = 'https://trinistocks.com/api/simulatorplayers';
        final apiToken = userInfo['token'];
        var apiResponse = await http.post(url,
            headers: {"Authorization": "Token $apiToken"},
            body: simulatorGameUpdate);
        if (apiResponse.statusCode == 202) {
          String url = 'https://trinistocks.com/api/simulatortransactions';
          final apiToken = userInfo['token'];
          var apiResponse = await http.put(url,
              headers: {"Authorization": "Token $apiToken"},
              body: transactionData);
          if (apiResponse.statusCode == 201) {
            response['message'] = null;
          } else {
            response['message'] = apiResponse.body;
          }
        } else {
          response['message'] =
              "Could not update remaining cash for simulator player.";
        }
      } else {
        response['message'] = "No user logged in";
      }
      return response;
    });
  }
}
