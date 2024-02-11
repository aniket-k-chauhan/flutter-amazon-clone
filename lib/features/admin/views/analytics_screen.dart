import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widgets/loader.dart';
import 'package:flutter_amazon_clone/features/admin/models/sale.dart';
import 'package:flutter_amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter_amazon_clone/features/admin/widgets/category_products_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();

  double? totalEarnings;
  List<Sale>? sales;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  void getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalEarnings = earningData["totalEarnings"];
    sales = earningData["sales"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return totalEarnings == null || sales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                "\$$totalEarnings",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: CategoryProductsChart(sales: sales!),
              ),
            ],
          );
  }
}
