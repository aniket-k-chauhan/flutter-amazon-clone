import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widgets/custom_button.dart';
import 'package:flutter_amazon_clone/common/widgets/custom_textfield.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter_amazon_clone/features/admin/widgets/image_picker_field.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = "/add-product";
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _addProductFormKey = GlobalKey<FormState>();
  final AdminServices adminServices = AdminServices();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final ImagePickerInputController imagePickerController =
      ImagePickerInputController();

  String category = "Mobiles";
  List<File> selectedImagesList = [];

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    imagePickerController.dispose();
  }

  void sellProduct() async {
    if (_addProductFormKey.currentState!.validate()) {
      await adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        category: category,
        // validating not null value as
        // custom create FormField in
        // ImagePickerFormField widget
        images: imagePickerController.value!,
      );
    }
  }

  List<String> productCategories = [
    "Mobiles",
    "Essentials",
    "Appliances",
    "Books",
    "Fashion",
  ];

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
          title: const Text(
            "Add Product",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: ValueListenableBuilder(
                valueListenable: imagePickerController,
                builder: (_, images, __) {
                  return Column(
                    children: [
                      ImagePickerFormField(
                        validator: (value) {
                          if (value == null) return "Please select an image";

                          return null;
                        },
                        controller: imagePickerController,
                      ),
                      if (images != null && images.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: CarouselSlider(
                            items: imagePickerController.value!
                                .map(
                                  (i) => Builder(
                                    builder: (context) => ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        i,
                                        fit: BoxFit.fitHeight,
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              height: 200,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      CustomTextfield(
                        controller: productNameController,
                        hintText: "Product Name",
                      ),
                      const SizedBox(height: 10),
                      CustomTextfield(
                        controller: descriptionController,
                        hintText: "Description",
                        maxLines: 7,
                      ),
                      const SizedBox(height: 10),
                      CustomTextfield(
                        controller: priceController,
                        hintText: "Price",
                      ),
                      const SizedBox(height: 10),
                      CustomTextfield(
                        controller: quantityController,
                        hintText: "Quantity",
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              value: category,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  category = value!;
                                });
                              },
                              items: productCategories
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // CustomButton(text: "Sell", onPressed: () {}),
                    ],
                  );
                }),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(onPressed: sellProduct, text: "Sell"),
      ),
    );
  }
}
