import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/config.dart' as config;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileManagementAPI {
  ProfileManagementAPI() {}

  static Future<Map> checkProvidedCredentials(
      String username, String password) async {
    String url = 'https://trinistocks.com/api/usertoken';
    final response = await http
        .post(url, body: {'username': username, 'password': password});
    var apiResponse = json.decode(response.body);
    Map returnData = Map();
    returnData['token'] = null;
    if (response.statusCode == 400) {
      //if incorrect login details were provided
      returnData['message'] = apiResponse['non_field_errors'][0];
    } else if (response.statusCode == 200) {
      //if the user credentials are correct
      returnData['message'] = null;
      returnData['token'] = apiResponse['token'];
      //store the user profile to maintain the logged in state
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', username);
      prefs.setString('token', apiResponse['token']);
    } else {
      //if we get any other weird response codes
      returnData['message'] = "Error while trying to access API.";
    }
    return returnData;
  }

  static Future<Map> checkUserLoggedIn() async {
    Map userInfo = Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') == null) {
      userInfo['isLoggedIn'] = false;
    } else {
      userInfo['isLoggedIn'] = true;
      userInfo['username'] = prefs.getString('username');
      userInfo['token'] = prefs.getString('token');
    }
    return userInfo;
  }
}
