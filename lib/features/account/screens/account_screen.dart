import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/account/widgets/top_bottom.dart';
import 'package:flutter/material.dart';

import '../widgets/below_app_bar.dart';
import '../widgets/order.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 120,
                  height: 50,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 15,left: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.notifications_outlined),
                    ),
                    Icon(Icons.search),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          BelowAppBarWidget(),
          SizedBox(height: 10,),
          TopBottomWidget(),
          SizedBox(height: 10,),
          Orders(),
        ],
      ),
    );
  }
}
