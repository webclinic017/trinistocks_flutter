import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class TechnicalAnalysisAPI {
  TechnicalAnalysisAPI() {}

  static Future<Map> fetchLatestTechnicalAnalysisData() async {
    String url = 'https://trinistocks.com/api/technicalanalysis';
    const apiToken = config.APIKeys.guest_api_token;
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
      if (apiResponse[i]['symbol'] != null) {
        securityData['symbol'] = apiResponse[i]['symbol'];
        if (apiResponse[i]['sector'] == null) {
          securityData['sector'] = "";
        } else {
          securityData['sector'] = apiResponse[i]['sector'];
        }
        try {
          securityData['last_close_price'] =
              double.parse(apiResponse[i]['last_close_price']);
        } catch (e) {
          securityData['last_close_price'] = 0.0;
        }
        try {
          securityData['sma_20'] = double.parse(apiResponse[i]['sma_20']);
        } catch (e) {
          securityData['sma_20'] = 0.0;
        }
        try {
          securityData['sma_200'] = double.parse(apiResponse[i]['sma_200']);
        } catch (e) {
          securityData['sma_200'] = 0.0;
        }
        try {
          securityData['beta'] = double.parse(apiResponse[i]['beta']);
        } catch (e) {
          securityData['beta'] = 0.0;
        }
        try {
          securityData['adtv'] = apiResponse[i]['adtv'];
        } catch (e) {
          securityData['adtv'] = 0;
        }
        try {
          securityData['high_52w'] = double.parse(apiResponse[i]['high_52w']);
        } catch (e) {
          securityData['high_52w'] = 0.0;
        }
        try {
          securityData['low_52w'] = double.parse(apiResponse[i]['low_52w']);
        } catch (e) {
          securityData['low_52w'] = 0.0;
        }
        try {
          securityData['wtd'] = double.parse(apiResponse[i]['wtd']);
        } catch (e) {
          securityData['wtd'] = 0.0;
        }
        try {
          securityData['mtd'] = double.parse(apiResponse[i]['mtd']);
        } catch (e) {
          securityData['mtd'] = 0.0;
        }

        try {
          securityData['ytd'] = double.parse(apiResponse[i]['ytd']);
        } catch (e) {
          securityData['ytd'] = 0.0;
        }

        returnData.add(securityData);
      }
    }
    // sort the listed stocks by market capitalization
    returnData.sort((a, b) => (a['symbol']).compareTo(b['symbol']));
    //group the data by sector
    Map groupedSectorData = groupBy(returnData, (Map obj) => obj['sector']);
    // return the data from the api request
    return groupedSectorData;
  }
}
