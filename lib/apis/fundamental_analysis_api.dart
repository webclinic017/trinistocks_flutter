import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';
import "package:collection/collection.dart";

class FundamentalAnalysisAPI {
  FundamentalAnalysisAPI() {}

  static Future<Map> fetchLatestAuditedFundamentalAnalysisData() async {
    //first get the main data from the fundamental analysis api
    String fundamentalDataURL =
        'https://trinistocks.com/api/fundamentalanalysis';
    const apiToken = config.APIKeys.app_api_token;
    Response response = await http
        .get(fundamentalDataURL, headers: {"Authorization": "Token $apiToken"});
    List apiResponse = [];
    if (response.statusCode == 200) {
      apiResponse = json.decode(response.body);
    } else {
      throw Exception("Could not fetch API data from $fundamentalDataURL");
    }
    var formatter = new DateFormat('yyyy-MM-dd');
    //parse the apiresponse data to be returned
    List<Map> fullResponseData = [];
    for (int i = 0; i < apiResponse.length; i++) {
      if (apiResponse[i]['report_type'] == "annual") {
        Map securityData = Map();
        securityData['symbol'] = apiResponse[i]['symbol'];
        if (apiResponse[i]['sector'] == null) {
          securityData['sector'] = 'N/A';
        } else {
          securityData['sector'] = apiResponse[i]['sector'];
        }
        securityData['date'] = formatter.parse(apiResponse[i]['date']);
        securityData['report_type'] = apiResponse[i]['report_type'];
        securityData['RoE'] = double.tryParse(apiResponse[i]['RoE']);
        securityData['EPS'] = double.tryParse(apiResponse[i]['EPS']);
        securityData['RoIC'] = double.tryParse(apiResponse[i]['RoIC']);
        securityData['current_ratio'] =
            double.tryParse(apiResponse[i]['current_ratio']);
        if (apiResponse[i]['price_to_earnings_ratio'] == null) {
          securityData['price_to_earnings_ratio'] = double.nan;
        } else {
          securityData['price_to_earnings_ratio'] =
              double.tryParse(apiResponse[i]['price_to_earnings_ratio']);
        }
        if (apiResponse[i]['dividend_yield'] == null) {
          securityData['dividend_yield'] = double.nan;
        } else {
          securityData['dividend_yield'] =
              double.tryParse(apiResponse[i]['dividend_yield']);
        }
        if (apiResponse[i]['dividend_payout_ratio'] == null) {
          securityData['dividend_payout_ratio'] = double.nan;
        } else {
          securityData['dividend_payout_ratio'] =
              double.tryParse(apiResponse[i]['dividend_payout_ratio']);
        }
        if (apiResponse[i]['price_to_book_ratio'] == null) {
          securityData['dividend_payout_ratio'] = double.nan;
        } else {
          securityData['price_to_book_ratio'] =
              double.tryParse(apiResponse[i]['price_to_book_ratio']);
        }
        if (apiResponse[i]['cash_per_share'] == null) {
          securityData['cash_per_share'] = double.nan;
        } else {
          securityData['cash_per_share'] =
              double.tryParse(apiResponse[i]['cash_per_share']);
        }
        fullResponseData.add(securityData);
      }
    }
    // sort the data by symbol
    //returnData.sort((a, b) => (a['symbol']).compareTo(b['symbol']));
    // get the latest date for each symbol
    List<Map> latestReturnData = [];
    var groupedSymbolData =
        groupBy(fullResponseData, (Map obj) => obj['symbol']);
    for (var group in groupedSymbolData.values) {
      group.sort((a, b) => (a['date']).compareTo(b['date']));
      int lastIndex = group.length - 1;
      latestReturnData.add(group[lastIndex]);
    }
    //group the data by sector
    Map groupedSectorData =
        groupBy(latestReturnData, (Map obj) => obj['sector']);
    // return the data from the api request
    return groupedSectorData;
  }
}
