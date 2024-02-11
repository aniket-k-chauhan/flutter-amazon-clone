import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/features/home/widgets/single_category.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemExtent: 75,
        itemCount: GlobalVariables.categoryImages.length,
        itemBuilder: (context, index) {
          return SingleCategory(
            categoryImage: GlobalVariables.categoryImages[index]["image"]!,
            categoryTitle: GlobalVariables.categoryImages[index]["title"]!,
          );
        },
      ),
    );
  }
}
