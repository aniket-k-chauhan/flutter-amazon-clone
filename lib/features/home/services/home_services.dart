import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/models/product.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    List<Product> productList = [];

    try {
      final token = context.read<UserProvider>().user.token;

      http.Response response = await http.get(
          Uri.parse("$uri/api/products?category=$category"),
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
        },
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }

    return productList;
  }

  Future<Product> fetchDealsOfTheDay({
    required BuildContext context,
  }) async {
    Product product = Product(
      name: "name",
      description: "",
      price: 0,
      quantity: 0,
      category: "",
      images: [],
    );

    try {
      final token = context.read<UserProvider>().user.token;

      http.Response response = await http
          .get(Uri.parse("$uri/api/deal-of-the-day"), headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token,
      });

      if (!context.mounted) return product;
      httpErrorhandling(
        context: context,
        response: response,
        onSuccess: () {
          product = Product.fromJson(response.body);
        },
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }

    return product;
  }
}
