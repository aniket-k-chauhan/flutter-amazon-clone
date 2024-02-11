import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/features/account/services/account_services.dart';
import 'package:flutter_amazon_clone/features/account/widgets/option_button.dart';

class AccountOptions extends StatelessWidget {
  const AccountOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            OptionButton(onPressed: () {}, text: "Your Orders"),
            OptionButton(onPressed: () {}, text: "Turn Seller"),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            OptionButton(
                onPressed: () => AccountServices().logout(context),
                text: "Log Out"),
            OptionButton(onPressed: () {}, text: "Your Wish List"),
          ],
        ),
      ],
    );
  }
}
