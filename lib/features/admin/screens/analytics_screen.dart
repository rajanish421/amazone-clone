import 'package:amazon_clone/comman/widgets/loader.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter/material.dart';

import '../models/sales.dart';
import '../widgets/category_products_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEarning();
  }

  getEarning() async {
    var earningData = await adminServices.getEarnings(context: context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(totalSales);
    print(earnings);

    return totalSales == null || earnings == null
        ? const Loader()
        : Column(
            children: [
              Text(
                '\$$totalSales',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 250,
                child: CategoryProductsChart(
                  earnings: earnings!,
                  totalSales: totalSales!,
                ),
              ),
            ],
          );
  }
}
