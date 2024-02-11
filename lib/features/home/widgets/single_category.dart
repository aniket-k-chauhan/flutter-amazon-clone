import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/features/home/views/category_specific_screen.dart';

class SingleCategory extends StatelessWidget {
  final String categoryImage;
  final String categoryTitle;
  const SingleCategory(
      {super.key, required this.categoryImage, required this.categoryTitle});

  void navigateToCategoryScreen(BuildContext context, String category) {
    Navigator.of(context)
        .pushNamed(CategorySpecificScreen.routeName, arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToCategoryScreen(context, categoryTitle),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                categoryImage,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            categoryTitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
