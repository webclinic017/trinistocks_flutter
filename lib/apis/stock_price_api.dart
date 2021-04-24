import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class StockPriceAPI {
  StockPriceAPI() {}

  static Future<List<Map>> fetchStockPriceData(
      String symbol, String dateRange) async {
    DateTime startDate = DateTime.now();
    DateFormat dateFormat = DateFormat.yMMMMd('en_US');
    switch (dateRange) {
      case StockPriceDateRange.oneMonth:
        startDate = startDate.subtract(Duration(days: 30));
        break;
      case StockPriceDateRange.oneYear:
        startDate = startDate.subtract(Duration(days: 365));
        break;
      case StockPriceDateRange.fiveYears:
        startDate = startDate.subtract(Duration(days: 365 * 5));
        break;
      case StockPriceDateRange.tenYears:
        startDate = startDate.subtract(Duration(days: 365 * 10));
        break;
      default:
        startDate = startDate.subtract(Duration(days: 365));
        break;
    }
    String url =
        'https://trinistocks.com/api/stockprices?symbol=$symbol&start_date=${dateFormat.format(startDate)}';
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
    List<Map> returnData = [];
    for (Map response in apiResponse) {
      if (response['symbol'] != null) {
        Map parsedData = new Map();
        parsedData['date'] = DateTime.parse(response["date"]);
        parsedData['symbol'] = response['symbol'];
        parsedData['openPrice'] = double.tryParse(response['open_price']);
        parsedData['closePrice'] = double.tryParse(response['close_price']);
        parsedData['low'] = double.tryParse(response['low']);
        parsedData['high'] = double.tryParse(response['high']);
        returnData.add(parsedData);
      }
    }
    return returnData;
  }
}

class StockPriceDateRange {
  static const String oneMonth = '1 Month';
  static const String oneYear = '1 Year';
  static const String fiveYears = '5 Years';
  static const String tenYears = '10 Years';
}
