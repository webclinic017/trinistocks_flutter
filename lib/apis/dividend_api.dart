import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class DividendAPI {
  DividendAPI() {}

  static Future<List> fetchDividendPaymentData(
      String symbol, String dateRange) async {
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
    //set up lists to store all the dividend data that we need
    List<Map> dividendPayments = [];
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
    await Future.delayed(const Duration(seconds: 5));
    return dividendPayments;
  }

  static Future<List> fetchDividendYieldData(
      String symbol, String dateRange) async {
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
    //set up lists to store all the dividend data that we need
    List<Map> dividendYields = [];
    //now repeat for the dividend yields
    String url =
        'https://trinistocks.com/api/dividendyields?symbol=$symbol&start_date=${dateFormat.format(startDate)}';
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
        parsedData['date'] = DateTime.parse(response["date"]);
        parsedData['dividend_yield'] =
            double.tryParse(response['dividend_yield']);
        dividendYields.add(parsedData);
      }
    }
    return dividendYields;
  }
}

class DividendDateRange {
  static const String threeYears = '3 Years';
  static const String fiveYears = '5 Years';
  static const String tenYears = '10 Years';
}
