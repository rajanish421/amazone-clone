import 'dart:convert';

import 'package:amazon_clone/constants/error-handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constants/global_variable.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class AddressServices {
  // save user address
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      print("error from save address block");
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
          );

          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get all the products
  // void placeOrder({
  //   required BuildContext context,
  //   required String address,
  //   required double totalSum,
  // }) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //
  //   try {
  //     http.Response res = await http.post(Uri.parse('$uri/api/order'),
  //         headers: {
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'x-auth-token': userProvider.user.token,
  //         },
  //         body: jsonEncode({
  //           'cart': userProvider.user.cart,
  //           'address': address,
  //           'totalPrice': totalSum,
  //         }));
  //
  //     httpErrorHandle(
  //       response: res,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context, 'Your order has been placed!');
  //         User user = userProvider.user.copyWith(
  //           cart: [],
  //         );
  //         userProvider.setUserFromModel(user);
  //       },
  //     );
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }



// place order
  void placeOrder(
      {required BuildContext context,
      required String address,
      required double totalSum}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/order"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
           'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'cart': userProvider.user.cart,
          'address': address,
          'totalPrice': totalSum,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Your order has been placed!');
          User user = userProvider.user.copyWith(cart: []);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
