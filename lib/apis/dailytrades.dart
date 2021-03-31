import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class FetchDailyTrades {
  FetchDailyTrades() {}

  static Future<Map> fetchLatestTrades() async {
    print("Now requesting data");
    String url = 'https://trinistocks.com/api/latestdailytrades';
    const apiToken = config.APIKeys.app_api_token;
    final response =
        await http.get(url, headers: {"Authorization": "Token $apiToken"});
    List apiResponse = [];
    if (response.statusCode == 200) {
      apiResponse = json.decode(response.body);
    } else {
      throw Exception("Could not fetch API data from $url");
    }
    // create a map to store the parsed api response
    Map returnData = new Map();
    // parse the date into the form we need
    DateTime parsedDate = DateTime.parse(apiResponse[0]["date"]);
    DateFormat dateFormat = DateFormat.yMMMMd('en_US');
    returnData['date'] = dateFormat.format(parsedDate);
    // parse the value traded data for the chart
    returnData['valuesTraded'] = <Map>[];
    for (var i = 0; i < apiResponse.length; i++) {
      if (apiResponse[i]['symbol'] != null &&
          apiResponse[i]['value_traded'] != null) {
        returnData['valuesTraded'].add({
          "symbol": apiResponse[i]["symbol"],
          "value_traded": double.tryParse(apiResponse[i]["value_traded"]),
        });
      }
    }
    // temp delay to display overlay
    await Future.delayed(Duration(seconds: 2));
    // return the data from the api request
    print("Now received data");
    return returnData;
  }
}
