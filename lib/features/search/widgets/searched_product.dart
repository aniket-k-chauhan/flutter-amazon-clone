import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widgets/stars.dart';
import 'package:flutter_amazon_clone/models/product.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double avgRating = 0;
    double totalRating = 0;

    if (product.ratings != null) {
      final ratings = product.ratings;
      for (int i = 0; i < ratings!.length; i++) {
        totalRating += ratings[i].rating;
      }

      if (totalRating != 0) {
        avgRating = totalRating / ratings.length;
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Image.network(
            product.images[0],
            fit: BoxFit.contain,
            width: 135,
            height: 135,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 235,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Stars(rating: avgRating),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    "\$${product.price}",
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "Eligible for free Shipping",
                  ),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: const Text(
                    "In stock",
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
