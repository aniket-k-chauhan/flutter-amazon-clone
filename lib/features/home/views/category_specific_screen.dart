import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widgets/loader.dart';
import 'package:flutter_amazon_clone/common/widgets/single_product.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/features/home/services/home_services.dart';
import 'package:flutter_amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_amazon_clone/models/product.dart';

class CategorySpecificScreen extends StatefulWidget {
  static const String routeName = "/category-screen";
  final String category;
  const CategorySpecificScreen({super.key, required this.category});

  @override
  State<CategorySpecificScreen> createState() => _CategorySpecificScreenState();
}

class _CategorySpecificScreenState extends State<CategorySpecificScreen> {
  final HomeServices homeServices = HomeServices();
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts(widget.category);
  }

  void fetchCategoryProducts(String category) async {
    products = await homeServices.fetchCategoryProducts(
      context: context,
      category: category,
    );
    setState(() {});
  }

  void navigateToProductDetailsScreen(Product product) {
    Navigator.of(context)
        .pushNamed(ProductDetailsScreen.routeName, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: products == null
          ? const Loader()
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    "Keep shopping for ${widget.category}",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: GridView.builder(
                    itemCount: products!.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.4,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final product = products![index];
                      return GestureDetector(
                        onTap: () => navigateToProductDetailsScreen(product),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 130,
                              child: SingleProduct(image: product.images[0]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7)
                                  .copyWith(top: 5),
                              child: Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
