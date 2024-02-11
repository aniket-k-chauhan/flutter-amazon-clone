import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/models/user.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressSevices {
  // save user address
  Future<void> saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = context.read<UserProvider>();
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/save-user-address"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode({
          "address": address,
        }),
      );

      if (!context.mounted) return;
      httpErrorhandling(
        context: context,
        response: response,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            address: jsonDecode(response.body)["address"],
          );

          userProvider.setUserFromModel(user);
        },
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }
  }

  // order Item
  Future<void> placeOrder({
    required BuildContext context,
    required String address,
    required double totalAmount,
  }) async {
    final userProvider = context.read<UserProvider>();
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/order"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode({
          "cart": userProvider.user.cart,
          "address": address,
          "totalAmount": totalAmount,
        }),
      );

      if (!context.mounted) return;
      httpErrorhandling(
          context: context,
          response: response,
          onSuccess: () {
            showSnackBar(context: context, text: "Your order has been placed!");
            User user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromModel(user);
          });
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }
  }
}
