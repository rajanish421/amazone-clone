import 'dart:ffi';

import 'package:amazon_clone/constants/global_variable.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("data"),),
        body: ElevatedButton(onPressed: (){}, child: Text("Click")),
      ),
    );
  }
}