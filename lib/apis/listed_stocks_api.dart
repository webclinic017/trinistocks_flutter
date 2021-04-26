import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class ListedStocksAPI {
  ListedStocksAPI() {}

  static Future<Map> fetchAllListedStockData() async {
    String url = 'https://trinistocks.com/api/listedstocks';
    const apiToken = config.APIKeys.app_api_token;
    final response =
        await http.get(url, headers: {"Authorization": "Token $apiToken"});
    List apiResponse = [];
    if (response.statusCode == 200) {
      apiResponse = json.decode(response.body);
    } else {
      throw Exception("Could not fetch API data from $url");
    }
    //parse the apiresponse data to be returned
    List<Map> returnData = [];
    for (int i = 0; i < apiResponse.length; i++) {
      Map securityData = Map();
      securityData['symbol'] = apiResponse[i]['symbol'];
      securityData['security_name'] = apiResponse[i]['security_name'];
      securityData['status'] = apiResponse[i]['status'];
      if (apiResponse[i]['sector'] != null) {
        securityData['sector'] = apiResponse[i]['sector'];
      } else {
        securityData['sector'] = 'N/A';
      }
      securityData['issued_share_capital'] =
          apiResponse[i]['issued_share_capital'];
      securityData['market_capitalization'] =
          double.parse(apiResponse[i]['market_capitalization']);
      securityData['financial_year_end'] = apiResponse[i]['financial_year_end'];
      securityData['currency'] = apiResponse[i]['currency'];
      returnData.add(securityData);
    }
    // sort the listed stocks by market capitalization
    returnData.sort((a, b) =>
        (b['market_capitalization']).compareTo(a['market_capitalization']));
    //group the data by sector
    Map groupedSectorData = groupBy(returnData, (Map obj) => obj['sector']);
    // return the data from the api request
    return groupedSectorData;
  }

  static Future<List<String>> fetchListedStockSymbols() async {
    String url = 'https://trinistocks.com/api/listedstocks';
    const apiToken = config.APIKeys.app_api_token;
    final response =
        await http.get(url, headers: {"Authorization": "Token $apiToken"});
    List apiResponse = [];
    if (response.statusCode == 200) {
      apiResponse = json.decode(response.body);
    } else {
      throw Exception("Could not fetch API data from $url");
    }
    //parse the apiresponse data to be returned
    List<String> returnData = [];
    for (int i = 0; i < apiResponse.length; i++) {
      returnData.add(apiResponse[i]['symbol']);
    }
    // sort the listed stocks by market capitalization
    returnData.sort((a, b) => (a).compareTo(b));
    // return the data from the api request
    return returnData;
  }
}
