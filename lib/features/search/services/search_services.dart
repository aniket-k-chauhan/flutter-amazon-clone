import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/models/product.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchServices {
  Future<List<Product>> fetchSearchedProducts({
    required BuildContext context,
    required String query,
  }) async {
    List<Product> productList = [];
    try {
      final token = context.read<UserProvider>().user.token;

      http.Response response = await http.get(
          Uri.http(authority, "/api/products/search/$query"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token,
          });

      if (!context.mounted) return productList;

      httpErrorhandling(
          context: context,
          response: response,
          onSuccess: () {
            final responseJson = jsonDecode(response.body);

            for (int i = 0; i < responseJson.length; i++) {
              productList.add(
                Product.fromJson(
                  jsonEncode(responseJson[i]),
                ),
              );
            }
          });
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }

    return productList;
  }
}
