import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/models/user.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailsServices {
  Future<void> rateProduct({
    required BuildContext context,
    required double rating,
    required String productId,
  }) async {
    try {
      final token = context.read<UserProvider>().user.token;

      http.Response response = await http.post(
        Uri.http(authority, "/api/rate-product"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
        body: jsonEncode({
          "id": productId,
          "rating": rating,
        }),
      );

      if (!context.mounted) return;
      httpErrorhandling(
        context: context,
        response: response,
        onSuccess: () {},
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }
  }

  Future<void> addToCart({
    required BuildContext context,
    required String productId,
  }) async {
    try {
      final userProvider = context.read<UserProvider>();

      http.Response response = await http.post(
        Uri.http(authority, "/api/add-to-cart"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode({
          "id": productId,
        }),
      );

      if (!context.mounted) return;
      httpErrorhandling(
        context: context,
        response: response,
        onSuccess: () {
          User updatedUser = userProvider.user.copyWith(
            cart: jsonDecode(response.body)["cart"],
          );

          userProvider.setUserFromModel(updatedUser);
        },
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }
  }
}
