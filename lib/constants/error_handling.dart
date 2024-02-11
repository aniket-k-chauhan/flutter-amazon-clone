import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:http/http.dart' as http;

void httpErrorhandling({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case >= 200 && < 300:
      onSuccess();
      break;

    case >= 400 && < 500:
      showSnackBar(
          context: context, text: jsonDecode(response.body)["message"]);
      break;

    case >= 500 && < 600:
      showSnackBar(context: context, text: jsonDecode(response.body)["error"]);
      break;

    default:
      showSnackBar(context: context, text: response.body);
  }
}
