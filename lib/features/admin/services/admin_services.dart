import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../constants/error-handling.dart';
import '../../../constants/global_variable.dart';
import '../../../providers/user_provider.dart';

class AdminServices {
  // sell products

  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final cloudinary = CloudinaryPublic('dkc73d9op', 'treetree');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      print('heloooo');
      showSnackBar(context, e.toString());
    }
  }

  // Get app products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
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
      print('hello');
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  // Delete product

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(
          {'id': product.id},
        ),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      print('error');
      showSnackBar(context, e.toString());
    }
  }

  // fetch all order
  Future<List<Order>> fetchAllOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/admin/get-orders"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  // change order status

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res =
          await http.post(Uri.parse('$uri/admin/change-order-status'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode({
                'id': order.id,
                'status': status,
              }));

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get total earnings or analytics

  Future<Map<String, dynamic>> getEarnings({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        "Content-Type": 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });
      print(jsonDecode(res.body));
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialsEarnings']),
            Sales('Appliances', response['appliancesEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}
