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
      prefs.setString('username', apiResponse['username']);
      prefs.setString('token', apiResponse['token']);
      prefs.setString('email', apiResponse['email']);
    } else {
      //if we get any other weird response codes
      returnData['message'] = "Error while trying to access API.";
    }
    return returnData;
  }

  static Future<String?> recoverPassword(String email) async {
    String url = 'https://trinistocks.com/api/password_reset';
    final response = await http.post(url, body: {'email': email});
    if (response.statusCode == 200) {
      //don't do anything else, the email was sent successfully
      return null;
    } else {
      return "We ran into an error! ${response.reasonPhrase}";
    }
  }

  static Future<String?> resetPassword(
      String token, String password1, String password2) async {
    //first check that the two submitted passwords match each other
    if (password1 != password2) {
      return "Please ensure that your new passwords match!";
    } else {
      //else continue
      String url =
          'https://trinistocks.com/api/password_resetconfirm/?token=$token';
      final response =
          await http.post(url, body: {'token': token, 'password': password1});
      if (response.statusCode == 200) {
        //password was reset successfully, don't return an error message
        return null;
      } else {
        return "We ran into an error! ${response.reasonPhrase}";
      }
    }
  }

  static Future<String?> signupUser(
      String username, String email, String password1, String password2) async {
    if (password1 != password2) {
      return "Please ensure that your new passwords match!";
    } else {
      String url = 'https://trinistocks.com/api/createuser';
      final response = await http.post(url,
          body: {'email': email, 'username': username, 'password': password1});
      if (response.statusCode == 201) {
        //don't do anything else, the email was sent successfully
        return null;
      } else {
        return "We ran into an error! ${response.reasonPhrase}";
      }
    }
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
