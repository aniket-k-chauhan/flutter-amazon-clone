import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:flutter_amazon_clone/models/order.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({required BuildContext context}) async {
    List<Order> orderList = [];
    try {
      final userProvider = context.read<UserProvider>();

      http.Response response = await http.get(
        Uri.parse("$uri/api/my-orders"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
      );

      if (!context.mounted) return orderList;
      httpErrorhandling(
        context: context,
        response: response,
        onSuccess: () {
          final responseJson = jsonDecode(response.body);

          for (int i = 0; i < responseJson.length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(responseJson[i]),
              ),
            );
          }
        },
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }

    return orderList;
  }

  void logout(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("x-auth-token", "");

      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, AuthScreen.routeName, (route) => false);
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }
  }
}
