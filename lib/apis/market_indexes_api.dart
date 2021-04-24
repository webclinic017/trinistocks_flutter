import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class MarketIndexesAPI {
  MarketIndexesAPI() {}

  static Future<List> fetchLast30Days() async {
    //first get todays date
    var today = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String todayDate = formatter.format(today);
    // then get the date from 30 days ago
    var monthBack = today.subtract(const Duration(days: 30));
    String monthBackDate = formatter.format(monthBack);
    String url =
        'https://trinistocks.com/api/marketindices?start_date=$monthBackDate&end_date=$todayDate';
    const apiToken = config.APIKeys.app_api_token;
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
