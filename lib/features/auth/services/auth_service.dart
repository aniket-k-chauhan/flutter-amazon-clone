import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widgets/bottom_bar.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/models/user.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String password,
    required String name,
    required String email,
  }) async {
    try {
      User user = User(
        id: "",
        name: name,
        email: email,
        password: password,
        address: "",
        type: "",
        token: "",
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse("$uri/api/signup"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
      );

      if (!context.mounted) return;

      httpErrorhandling(
        context: context,
        response: res,
        onSuccess: () => showSnackBar(
          context: context,
          text: "Account created! Login with the same credentials!",
        ),
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }
  }

  // sign in user
  void signInUser({
    required BuildContext context,
    required String password,
    required String email,
  }) async {
    try {
      User user = User(
        id: "",
        name: "",
        email: email,
        password: password,
        address: "",
        type: "",
        token: "",
        cart: [],
      );

      http.Response res = await http.post(Uri.parse("$uri/api/signin"),
          body: user.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

      if (!context.mounted) return;

      httpErrorhandling(
          context: context,
          response: res,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            if (!context.mounted) return;

            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await prefs.setString(
                "x-auth-token", jsonDecode(res.body)["token"]);

            if (!context.mounted) return;

            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, (route) => false);
            showSnackBar(
                context: context, text: "User successfully Logged In!");
          });
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }
  }

  // get user data
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null) {
        prefs.setString("x-auth-token", "");
        return;
      }

      http.Response tokenRes = await http.post(
        Uri.parse("$uri/tokenIsValid"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token
        },
      );

      var resBody = jsonDecode(tokenRes.body);

      if (!resBody) return;

      http.Response userRes = await http.get(
        Uri.parse("$uri/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token
        },
      );

      if (!context.mounted) return;

      context.read<UserProvider>().setUser(userRes.body);
    } catch (error) {
      log(error.toString());
      // showSnackBar(context: context, text: error.toString());
    }
  }
}
