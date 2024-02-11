import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const OptionButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.white, width: 0.0),
        //   borderRadius: BorderRadius.circular(50),
        //   color: Colors.white,
        // ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.black12.withOpacity(0.03),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
