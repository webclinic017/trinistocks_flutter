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
    const apiToken = config.APIKeys.guest_api_token;
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
        //make sure all keys are not null
        for (var key in apiResponse[i].keys) {
          if (apiResponse[i][key] == null) {
            apiResponse[i][key] = "";
          }
        }
        Map securityData = Map();
        if (apiResponse[i]['symbol'] != null) {
          securityData['symbol'] = apiResponse[i]['symbol'];
          if (apiResponse[i]['sector'] == null) {
            securityData['sector'] = 'N/A';
          } else {
            securityData['sector'] = apiResponse[i]['sector'];
          }
          securityData['date'] = formatter.parse(apiResponse[i]['date']);
          securityData['report_type'] = apiResponse[i]['report_type'];
          try {
            securityData['RoE'] = double.parse(apiResponse[i]['RoE']);
          } catch (e) {
            securityData['RoE'] = 0.0;
          }
          try {
            securityData['EPS'] = double.parse(apiResponse[i]['EPS']);
          } catch (e) {
            securityData['EPS'] = 0.0;
          }
          try {
            securityData['RoIC'] = double.parse(apiResponse[i]['RoIC']);
          } catch (e) {
            securityData['RoIC'] = 0.0;
          }
          try {
            securityData['current_ratio'] =
                double.parse(apiResponse[i]['current_ratio']);
          } catch (e) {
            securityData['current_ratio'] = 0.0;
          }
          try {
            securityData['price_to_earnings_ratio'] =
                double.parse(apiResponse[i]['price_to_earnings_ratio']);
          } catch (e) {
            securityData['price_to_earnings_ratio'] = 0.0;
          }
          try {
            securityData['dividend_yield'] =
                double.parse(apiResponse[i]['dividend_yield']);
          } catch (e) {
            securityData['dividend_yield'] = 0.0;
          }
          try {
            securityData['dividend_payout_ratio'] =
                double.parse(apiResponse[i]['dividend_payout_ratio']);
          } catch (e) {
            securityData['dividend_payout_ratio'] = 0.0;
          }
          try {
            securityData['price_to_book_ratio'] =
                double.parse(apiResponse[i]['price_to_book_ratio']);
          } catch (e) {
            securityData['price_to_book_ratio'] = 0.0;
          }
          try {
            securityData['cash_per_share'] =
                double.parse(apiResponse[i]['cash_per_share']);
          } catch (e) {
            securityData['cash_per_share'] = 0.0;
          }
          fullResponseData.add(securityData);
        }
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

  static Future<List> fetchAuditedFundamentalAnalysisData(
      String symbol, String dateRange) async {
    DateTime startDate = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    switch (dateRange) {
      case FundamentalDateRange.threeYears:
        startDate = startDate.subtract(Duration(days: 365 * 3));
        break;
      case FundamentalDateRange.fiveYears:
        startDate = startDate.subtract(Duration(days: 365 * 5));
        break;
      case FundamentalDateRange.tenYears:
        startDate = startDate.subtract(Duration(days: 365 * 10));
        break;
      default:
        startDate = startDate.subtract(Duration(days: 365 * 3));
        break;
    }
    //first get the main data from the fundamental analysis api
    String fundamentalDataURL =
        'https://trinistocks.com/api/fundamentalanalysis?symbol=$symbol&start_date=${dateFormat.format(startDate)}';
    const apiToken = config.APIKeys.guest_api_token;
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
        //make sure all keys are not null
        for (var key in apiResponse[i].keys) {
          if (apiResponse[i][key] == null) {
            apiResponse[i][key] = "";
          }
        }
        Map securityData = Map();
        if (apiResponse[i]['symbol'] != null) {
          securityData['symbol'] = apiResponse[i]['symbol'];
          if (apiResponse[i]['sector'] == null) {
            securityData['sector'] = 'N/A';
          } else {
            securityData['sector'] = apiResponse[i]['sector'];
          }
          securityData['date'] = formatter.parse(apiResponse[i]['date']);
          securityData['report_type'] = apiResponse[i]['report_type'];
          try {
            securityData['RoE'] = double.parse(apiResponse[i]['RoE']);
          } catch (e) {
            securityData['RoE'] = 0.0;
          }
          try {
            securityData['EPS'] = double.parse(apiResponse[i]['EPS']);
          } catch (e) {
            securityData['EPS'] = 0.0;
          }
          try {
            securityData['RoIC'] = double.parse(apiResponse[i]['RoIC']);
          } catch (e) {
            securityData['RoIC'] = 0.0;
          }
          try {
            securityData['current_ratio'] =
                double.parse(apiResponse[i]['current_ratio']);
          } catch (e) {
            securityData['current_ratio'] = 0.0;
          }
          try {
            securityData['price_to_earnings_ratio'] =
                double.parse(apiResponse[i]['price_to_earnings_ratio']);
          } catch (e) {
            securityData['price_to_earnings_ratio'] = 0.0;
          }
          try {
            securityData['dividend_yield'] =
                double.parse(apiResponse[i]['dividend_yield']);
          } catch (e) {
            securityData['dividend_yield'] = 0.0;
          }
          try {
            securityData['dividend_payout_ratio'] =
                double.parse(apiResponse[i]['dividend_payout_ratio']);
          } catch (e) {
            securityData['dividend_payout_ratio'] = 0.0;
          }
          try {
            securityData['price_to_book_ratio'] =
                double.parse(apiResponse[i]['price_to_book_ratio']);
          } catch (e) {
            securityData['price_to_book_ratio'] = 0.0;
          }
          try {
            securityData['cash_per_share'] =
                double.parse(apiResponse[i]['cash_per_share']);
          } catch (e) {
            securityData['cash_per_share'] = 0.0;
          }
          fullResponseData.add(securityData);
        }
      }
    }
    // return the data from the api request
    return fullResponseData;
  }

  static Future<List> fetchQuarterlyFundamentalAnalysisData(
      String symbol, String dateRange) async {
    DateTime startDate = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    switch (dateRange) {
      case FundamentalDateRange.threeYears:
        startDate = startDate.subtract(Duration(days: 365 * 3));
        break;
      case FundamentalDateRange.fiveYears:
        startDate = startDate.subtract(Duration(days: 365 * 5));
        break;
      case FundamentalDateRange.tenYears:
        startDate = startDate.subtract(Duration(days: 365 * 10));
        break;
      default:
        startDate = startDate.subtract(Duration(days: 365 * 3));
        break;
    }
    //first get the main data from the fundamental analysis api
    String fundamentalDataURL =
        'https://trinistocks.com/api/fundamentalanalysis?symbol=$symbol&start_date=${dateFormat.format(startDate)}';
    const apiToken = config.APIKeys.guest_api_token;
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
      if (apiResponse[i]['report_type'] == "quarterly") {
        //make sure all keys are not null
        for (var key in apiResponse[i].keys) {
          if (apiResponse[i][key] == null) {
            apiResponse[i][key] = "";
          }
        }
        Map securityData = Map();
        if (apiResponse[i]['symbol'] != null) {
          securityData['symbol'] = apiResponse[i]['symbol'];
          if (apiResponse[i]['sector'] == null) {
            securityData['sector'] = 'N/A';
          } else {
            securityData['sector'] = apiResponse[i]['sector'];
          }
          securityData['date'] = formatter.parse(apiResponse[i]['date']);
          securityData['report_type'] = apiResponse[i]['report_type'];
          try {
            securityData['RoE'] = double.parse(apiResponse[i]['RoE']);
          } catch (e) {
            securityData['RoE'] = 0.0;
          }
          try {
            securityData['EPS'] = double.parse(apiResponse[i]['EPS']);
          } catch (e) {
            securityData['EPS'] = 0.0;
          }
          try {
            securityData['RoIC'] = double.parse(apiResponse[i]['RoIC']);
          } catch (e) {
            securityData['RoIC'] = 0.0;
          }
          try {
            securityData['current_ratio'] =
                double.parse(apiResponse[i]['current_ratio']);
          } catch (e) {
            securityData['current_ratio'] = 0.0;
          }
          try {
            securityData['price_to_earnings_ratio'] =
                double.parse(apiResponse[i]['price_to_earnings_ratio']);
          } catch (e) {
            securityData['price_to_earnings_ratio'] = 0.0;
          }
          try {
            securityData['dividend_yield'] =
                double.parse(apiResponse[i]['dividend_yield']);
          } catch (e) {
            securityData['dividend_yield'] = 0.0;
          }
          try {
            securityData['dividend_payout_ratio'] =
                double.parse(apiResponse[i]['dividend_payout_ratio']);
          } catch (e) {
            securityData['dividend_payout_ratio'] = 0.0;
          }
          try {
            securityData['price_to_book_ratio'] =
                double.parse(apiResponse[i]['price_to_book_ratio']);
          } catch (e) {
            securityData['price_to_book_ratio'] = 0.0;
          }
          try {
            securityData['cash_per_share'] =
                double.parse(apiResponse[i]['cash_per_share']);
          } catch (e) {
            securityData['cash_per_share'] = 0.0;
          }
          fullResponseData.add(securityData);
        }
      }
    }
    // return the data from the api request
    return fullResponseData;
  }
}

class FundamentalDateRange {
  static const String threeYears = '3 Years';
  static const String fiveYears = '5 Years';
  static const String tenYears = '10 Years';
}
