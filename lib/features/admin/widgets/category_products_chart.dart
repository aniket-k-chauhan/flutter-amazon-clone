import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/features/admin/models/sale.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sale> sales;
  const CategoryProductsChart({super.key, required this.sales});

  double getMaxEarnings() {
    double maxEarnings = 0;

    for (int i = 0; i < sales.length; i++) {
      if (sales[i].earning > maxEarnings) {
        maxEarnings = sales[i].earning;
      }
    }
    return maxEarnings;
  }

  double getMaxY(double maxEarnings) {
    String earning = maxEarnings.toInt().toString();
    String leftMostDigit = (int.parse(earning[0]) + 1).toString();
    String maxY = leftMostDigit.padRight(earning.length, "0");
    return double.parse(maxY);
  }

  @override
  Widget build(BuildContext context) {
    double maxEarnings = getMaxEarnings();
    double maxY = getMaxY(maxEarnings);

    return BarChart(
      BarChartData(
        maxY: maxY,
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    sales[value.toInt()].label,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(
          sales.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: sales[index].earning,
                width: 50,
                borderRadius: BorderRadius.circular(3),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxEarnings,
                  color: Colors.teal.shade50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
