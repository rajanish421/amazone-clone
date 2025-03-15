import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  int totalSales;
  List<Sales> earnings;

  CategoryProductsChart(
      {super.key, required this.earnings, required this.totalSales});

  List<BarChartGroupData> _barGroup() {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < earnings.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i * 2,
          barRods: [
            BarChartRodData(
              toY: earnings[i].earning.toDouble(),
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: _barGroup(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Show labels dynamically
                if (value.toInt() % 2 == 0 && value ~/ 2 < earnings.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      earnings[value ~/ 2].label,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return Container();
              },
              reservedSize: 30, // Space for labels
            ),
          ),
        ),
      ),
    );
  }
}
