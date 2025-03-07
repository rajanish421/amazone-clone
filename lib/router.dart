import 'package:amazon_clone/comman/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

import 'features/admin/screens/add_product_screen.dart';
import 'features/home/screen/category_deals_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSetting) {
  var category = routeSetting.arguments as String ;
  switch (routeSetting.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSetting,
          builder: (_)=>BottomBar());
    case AddProductScreen.routeName:
      return MaterialPageRoute(
          settings: routeSetting,
          builder: (_)=>AddProductScreen());
    case CategoryDealsScreen.routeName:
      return MaterialPageRoute(
          settings: routeSetting,
          builder: (_)=>CategoryDealsScreen(category: category));
    default:
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => Scaffold(
          body: Center(
            child: Text("Page does not exist!"),
          ),
        ),
      );
  }
}
