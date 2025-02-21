import 'dart:convert';

import 'package:amazon_clone/comman/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/error-handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/home/screen/home_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
// Sign UP Service
  void signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    print("Sign Up methods called");
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
      );
      http.Response res = await http.post(Uri.parse("$uri/api/signup"),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Account Created !");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// Sing In Service
  Future<void> signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// Get user data
  void getUserData(BuildContext context) async {
    try {
      // get token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      //check token
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      // verify the token
      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        print(userRes.body);
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
