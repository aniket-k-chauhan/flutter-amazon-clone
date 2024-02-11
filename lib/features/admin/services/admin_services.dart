import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/features/admin/models/sale.dart';
import 'package:flutter_amazon_clone/models/order.dart';
import 'package:flutter_amazon_clone/models/product.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  // Add Product
  Future<void> sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    try {
      final cloudinary = CloudinaryPublic(
        dotenv.env["CLOUDINARY_CLOUD_NAME"]!,
        dotenv.env["CLOUDINARY_UPLOAD_PRESET"]!,
      );

      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        category: category,
        images: imageUrls,
      );

      if (!context.mounted) return;

      final token = context.read<UserProvider>().user.token;

      http.Response response = await http.post(
        Uri.http(authority, "/admin/add-product"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
        body: product.toJson(),
      );

      if (!context.mounted) return;
      httpErrorhandling(
        context: context,
        response: response,
        onSuccess: () {
          showSnackBar(context: context, text: "Product Added Successfully");
          Navigator.pop(context);
        },
      );
    } catch (error) {
      if (!context.mounted) return;
      showSnackBar(context: context, text: error.toString());
    }
  }

  // get all Products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    List<Product> productList = [];
    try {
      final token = context.read<UserProvider>().user.token;
      http.Response response = await http.get(
        Uri.http(authority, "/admin/get-products"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );

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

  // delete product by id
  Future deleteProduct({
    required BuildContext context,
    required String id,
    required VoidCallback onSuccess,
  }) async {
    try {
      final token = context.read<UserProvider>().user.token;

      http.Response response = await http.delete(
        Uri.http(authority, "/admin/delete-product/$id"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );

      if (!context.mounted) return;
      httpErrorhandling(
        context: context,
        response: response,
        onSuccess: onSuccess,
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }
  }

  // get all Orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    List<Order> orderList = [];
    try {
      final token = context.read<UserProvider>().user.token;
      http.Response response = await http.get(
        Uri.http(authority, "/admin/get-orders"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
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

  Future<void> changeOrderStatus({
    required BuildContext context,
    required String orderId,
    required VoidCallback onSuccess,
  }) async {
    try {
      final token = context.read<UserProvider>().user.token;

      http.Response response = await http.post(
        Uri.http(authority, "/admin/change-order-status"),
        headers: <String, String>{
          "Content-Type": "application/json; chatset=UTF-8",
          "x-auth-token": token,
        },
        body: jsonEncode({
          "orderId": orderId,
        }),
      );

      if (!context.mounted) return;
      httpErrorhandling(
        context: context,
        response: response,
        onSuccess: onSuccess,
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    List<Sale> sales = [];
    double totalEarnings = 0.0;

    try {
      final token = context.read<UserProvider>().user.token;
      http.Response response = await http.get(
        Uri.http(authority, "/admin/analytics"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );

      if (!context.mounted) {
        return {
          "sales": sales,
          "totalEarnings": totalEarnings,
        };
      }

      httpErrorhandling(
        context: context,
        response: response,
        onSuccess: () {
          final responseJson = jsonDecode(response.body);
          totalEarnings = responseJson["totalEarnings"].toDouble();

          sales = [
            Sale("Mobiles", responseJson["mobilesEarnings"].toDouble()),
            Sale("Essentials", responseJson["essentialsEarnings"].toDouble()),
            Sale("Appliances", responseJson["appliancesEarnings"].toDouble()),
            Sale("Books", responseJson["booksEarnings"].toDouble()),
            Sale("Fashion", responseJson["fashionEarnings"].toDouble()),
          ];
        },
      );
    } catch (error) {
      showSnackBar(context: context, text: error.toString());
    }

    return {
      "sales": sales,
      "totalEarnings": totalEarnings,
    };
  }
}
