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
      securityData['symbol'] = apiResponse[i]['symbol'];
      securityData['sector'] = apiResponse[i]['sector'];
      securityData['last_close_price'] =
          double.parse(apiResponse[i]['last_close_price']);
      securityData['sma_20'] = double.parse(apiResponse[i]['sma_20']);
      securityData['sma_200'] = double.parse(apiResponse[i]['sma_200']);
      if (apiResponse[i]['beta'] == null) {
        securityData['beta'] = double.nan;
      } else {
        securityData['beta'] = double.parse(apiResponse[i]['beta']);
      }
      securityData['adtv'] = apiResponse[i]['adtv'];
      securityData['high_52w'] = double.parse(apiResponse[i]['high_52w']);
      securityData['low_52w'] = double.parse(apiResponse[i]['low_52w']);
      securityData['wtd'] = double.parse(apiResponse[i]['wtd']);
      securityData['mtd'] = double.parse(apiResponse[i]['mtd']);
      securityData['ytd'] = double.parse(apiResponse[i]['ytd']);
      returnData.add(securityData);
    }
    // sort the listed stocks by market capitalization
    returnData.sort((a, b) => (a['symbol']).compareTo(b['symbol']));
    //group the data by sector
    Map groupedSectorData = groupBy(returnData, (Map obj) => obj['sector']);
    // return the data from the api request
    return groupedSectorData;
  }
}
