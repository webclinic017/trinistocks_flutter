import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';

class OutstandingTradesAPI {
  OutstandingTradesAPI() {}

  static Future<List> fetchOutstandingTradeData(
      String symbol, String dateRange) async {
    DateTime startDate = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    switch (dateRange) {
      case OutstandingTradesRange.oneWeek:
        startDate = startDate.subtract(Duration(days: 7));
        break;
      case OutstandingTradesRange.oneMonth:
        startDate = startDate.subtract(Duration(days: 31));
        break;
      case OutstandingTradesRange.oneYear:
        startDate = startDate.subtract(Duration(days: 365));
        break;
      default:
        startDate = startDate.subtract(Duration(days: 31));
        break;
    }
    //set up lists to store all the dividend data that we need
    List<Map> outstandingTrades = [];
    //now repeat for the dividend yields
    String url =
        'https://trinistocks.com/api/outstandingtrades?symbol=$symbol&start_date=${dateFormat.format(startDate)}';
    const apiToken = config.APIKeys.guest_api_token;
    var response =
        await http.get(url, headers: {"Authorization": "Token $apiToken"});
    List apiResponse = [];
    if (response.statusCode == 200) {
      apiResponse = json.decode(response.body);
    } else {
      throw Exception("Could not fetch API data from $url");
    }
    for (Map response in apiResponse) {
      Map parsedData = new Map();
      parsedData['date'] = DateTime.parse(response["date"]);
      try {
        parsedData['os_bid'] = double.parse(response['os_bid']);
      } catch (e) {
        parsedData['os_bid'] = null;
      }
      try {
        parsedData['os_bid_vol'] = response['os_bid_vol'];
      } catch (e) {
        parsedData['os_bid_vol'] = null;
      }
      try {
        parsedData['os_offer'] = double.parse(response['os_offer']);
      } catch (e) {
        parsedData['os_offer'] = null;
      }
      try {
        parsedData['os_offer_vol'] = response['os_offer_vol'];
      } catch (e) {
        parsedData['os_offer_vol'] = null;
      }
      try {
        parsedData['volume_traded'] = int.parse(response['volume_traded']);
      } catch (e) {
        parsedData['volume_traded'] = 0;
      }
      outstandingTrades.add(parsedData);
    }
    outstandingTrades.sort((a, b) => (a['date']).compareTo(b['date']));
    return outstandingTrades;
  }
}

class OutstandingTradesRange {
  static const String oneWeek = '1 Week ';
  static const String oneMonth = '1 Month ';
  static const String oneYear = '1 Year ';
}
