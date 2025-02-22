import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BelowAppBarWidget extends StatelessWidget {
  const BelowAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user  = Provider.of<UserProvider>(context).user;
    return Container(
      decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Row(
        children: [
          Text(
            "Hello, ",
            style: TextStyle(fontSize: 22,color: Colors.black),
          ),
          Text(
            user.name,
            style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black),
          ),
        ],
      ),
    );
  }
}
