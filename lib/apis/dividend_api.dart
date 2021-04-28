import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class DividendAPI {
  DividendAPI() {}

  static Future<Map> fetchDividendData(String symbol, String dateRange) async {
    DateTime startDate = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    switch (dateRange) {
      case DividendDateRange.threeYears:
        startDate = startDate.subtract(Duration(days: 365 * 3));
        break;
      case DividendDateRange.fiveYears:
        startDate = startDate.subtract(Duration(days: 365 * 5));
        break;
      case DividendDateRange.tenYears:
        startDate = startDate.subtract(Duration(days: 365 * 10));
        break;
      default:
        startDate = startDate.subtract(Duration(days: 365 * 5));
        break;
    }
    // create a map to store the parsed api response
    Map returnData = new Map();
    //set up lists to store all the dividend data that we need
    List<Map> dividendPayments = [];
    List<Map> dividendYields = [];
    //first get the dividend payment data
    String url =
        'https://trinistocks.com/api/dividendpayments?symbol=$symbol&start_date=${dateFormat.format(startDate)}';
    const apiToken = config.APIKeys.app_api_token;
    var response =
        await http.get(url, headers: {"Authorization": "Token $apiToken"});
    List apiResponse = [];
    if (response.statusCode == 200) {
      apiResponse = json.decode(response.body);
    } else {
      throw Exception("Could not fetch API data from $url");
    }
    for (Map response in apiResponse) {
      if (response['symbol'] != null) {
        Map parsedData = new Map();
        parsedData['date'] = DateTime.parse(response["record_date"]);
        parsedData['dividend_amount'] =
            double.tryParse(response['dividend_amount']);
        dividendPayments.add(parsedData);
      }
    }
    //now repeat for the dividend yields
    url =
        'https://trinistocks.com/api/dividendyields?symbol=$symbol&start_date=${dateFormat.format(startDate)}';
    response =
        await http.get(url, headers: {"Authorization": "Token $apiToken"});
    if (response.statusCode == 200) {
      apiResponse = json.decode(response.body);
    } else {
      throw Exception("Could not fetch API data from $url");
    }
    for (Map response in apiResponse) {
      if (response['symbol'] != null) {
        Map parsedData = new Map();
        parsedData['date'] = DateTime.parse(response["date"]);
        parsedData['dividend_yield'] =
            double.tryParse(response['dividend_yield']);
        dividendYields.add(parsedData);
      }
    }
    returnData['dividendPayments'] = dividendPayments;
    returnData['dividendYields'] = dividendYields;
    return returnData;
  }
}

class DividendDateRange {
  static const String threeYears = '3 Years';
  static const String fiveYears = '5 Years';
  static const String tenYears = '10 Years';
}
