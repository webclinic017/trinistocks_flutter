import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class StockNewsAPI {
  StockNewsAPI() {}

  static Future<List<Map>> fetch10LatestNews() async {
    //first get todays date
    var today = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String todayDate = formatter.format(today);
    // then get the date a month back
    var monthBack = today.subtract(const Duration(days: 28));
    String monthBackDate = formatter.format(monthBack);
    String url =
        'https://trinistocks.com/api/stocknewsdata?start_date=$monthBackDate&end_date=$todayDate';
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
    // create a list to store the latest 10 news items
    List<Map> returnData = [];
    // go through each api response item until we have enough items
    for (var i = 0; i < 10; i++) {
      if (apiResponse[i]['symbol'] != null && apiResponse[i]['date'] != null) {
        Map newsData = new Map();
        newsData['symbol'] = apiResponse[i]['symbol'];
        newsData['date'] = formatter.parse(apiResponse[i]['date']);
        if (apiResponse[i]['category'] != null) {
          newsData['category'] = apiResponse[i]['category'];
        } else {
          newsData['category'] = 'N.A';
        }
        if (apiResponse[i]['title'] != null && apiResponse[i]['link'] != null) {
          newsData['title'] = apiResponse[i]['title'];
          newsData['link'] = apiResponse[i]['link'];
        } else {
          newsData['title'] = 'N.A';
          newsData['link'] = '';
        }
        returnData.add(newsData);
      }
    }
    // temp delay to display overlay
    await Future.delayed(Duration(seconds: 2));
    // return the data from the api request
    return returnData;
  }
}
