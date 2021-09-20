import 'package:flutter/material.dart';
import 'components/nitendo-switch/on_sales_list.dart';
import 'pages/Main_Page.dart';

void main() {
  runApp((MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
