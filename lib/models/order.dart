import 'dart:convert';

import 'package:flutter_amazon_clone/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final List<int> quantities;
  final String address;
  final String userId;
  final double totalAmount;
  final int orderedAt;
  final int status;

  Order({
    required this.id,
    required this.products,
    required this.quantities,
    required this.address,
    required this.userId,
    required this.totalAmount,
    required this.orderedAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "products": products.map((product) => product.toMap()).toList(),
      "quantities": quantities,
      "address": address,
      "userId": userId,
      "totalAmount": totalAmount,
      "orderedAt": orderedAt,
      "status": status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map["_id"] ?? "",
      products: List<Product>.from(
        map["products"]?.map(
          (item) => Product.fromMap(item["product"]),
        ),
      ),
      quantities: List<int>.from(
        map["products"]?.map((item) => item["quantity"]),
      ),
      address: map["address"] ?? "",
      userId: map["userId"] ?? "",
      totalAmount: map["totalAmount"]?.toDouble() ?? 0.0,
      orderedAt: map["orderedAt"]?.toInt() ?? 0,
      status: map["status"]?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
