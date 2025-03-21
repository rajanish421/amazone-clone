import 'dart:convert';

import 'package:amazon_clone/constants/error-handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../providers/user_provider.dart';

class SearchServices {
  Future<List<Product>> fetchSearchedProducts(
      {required BuildContext context, required String searchQuery}) async {
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse("$uri/api/products/search/$searchQuery"),
          headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print(res.body);
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      print("error from here");
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}
