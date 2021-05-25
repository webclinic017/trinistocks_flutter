import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class MarketIndexesAPI {
  MarketIndexesAPI() {}

  static Future<List> fetchMarketIndexData(
      String dateRange, String indexName) async {
    //first get todays date
    var formatter = new DateFormat('yyyy-MM-dd');
    DateTime startDate = DateTime.now();
    switch (dateRange) {
      case MarketIndexDateRange.oneMonth:
        startDate = startDate.subtract(Duration(days: 30));
        break;
      case MarketIndexDateRange.oneYear:
        startDate = startDate.subtract(Duration(days: 365));
        break;
      case MarketIndexDateRange.fiveYears:
        startDate = startDate.subtract(Duration(days: 365 * 5));
        break;
      case MarketIndexDateRange.tenYears:
        startDate = startDate.subtract(Duration(days: 365 * 10));
        break;
      default:
        startDate = startDate.subtract(Duration(days: 365));
        break;
    }
    String url =
        'https://trinistocks.com/api/marketindices?start_date=${formatter.format(startDate)}&index_name=$indexName';
    const apiToken = config.APIKeys.guest_api_token;
    final response =
        await http.get(url, headers: {"Authorization": "Token $apiToken"});
    List apiResponse = [];
    if (response.statusCode == 200) {
      apiResponse = json.decode(response.body);
    } else {
      throw Exception("Could not fetch API data from $url");
    }
    // sort the news by date
    apiResponse.sort((a, b) => (b['date']).compareTo(a['date']));
    // return the data from the api request
    return apiResponse;
  }
}

class MarketIndexDateRange {
  static const String oneMonth = '1 Month';
  static const String oneYear = '1 Year';
  static const String fiveYears = '5 Years';
  static const String tenYears = '10 Years';
}
