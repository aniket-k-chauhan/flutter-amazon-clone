import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:flutter_amazon_clone/models/user.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CartServices {
  void increaseQuantity({
    required BuildContext context,
    required String productId,
  }) {
    try {
      final ProductDetailsServices productDetailsServices =
          ProductDetailsServices();
      productDetailsServices.addToCart(context: context, productId: productId);
    } catch (error) {
      if (!context.mounted) return;
      showSnackBar(context: context, text: error.toString());
    }
  }

  Future<void> decreaseQuantity({
    required BuildContext context,
    required String productId,
  }) async {
    try {
      final userProvider = context.read<UserProvider>();

      http.Response response = await http.delete(
        Uri.http(authority, "/api/remove-from-cart/$productId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
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
