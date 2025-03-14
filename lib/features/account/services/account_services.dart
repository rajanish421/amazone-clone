import 'dart:convert';

import 'package:amazon_clone/constants/error-handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:amazon_clone/models/order.dart';
import '../../../constants/global_variable.dart';

class AccountServices {
  // fetch orders
  Future<List<Order>> fetchMyOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    List<Order> orderList = [];
    print("Before tryr block");
    try {
      print("After try block");
      http.Response res =
          await http.get(Uri.parse("$uri/api/orders/me"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      print("After req block");
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
           print(jsonDecode(res.body));
          //
          // var decodedBody = jsonDecode(res.body);
          //
          // if (decodedBody != null && decodedBody is List) {
          //   orderList.clear(); // Optional: Clear the list before adding new items
          //   for (var order in decodedBody) {
          //     orderList.add(Order.fromJson(jsonEncode(order)));//No need for jsonEncode
          //   }
          // } else {
          //   print("Error: API did not return a list");
          // }


          // orderList.add(Order.fromJson(res.body));
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
          print("he;;.............");
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return orderList;
  }
}
