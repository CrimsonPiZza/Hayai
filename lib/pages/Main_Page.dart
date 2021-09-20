import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';
import '../components/nitendo-switch/on_sales_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Color.fromRGBO(15, 32, 39, 1),
        brightness: Brightness.dark, // status bar brightness
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Color.fromRGBO(15, 32, 39, 1),
          // image: DecorationImage(
          //   image: NetworkImage(
          //       'https://www.kolpaper.com/wp-content/uploads/2020/11/Zenitsu-Wallpaper-2.jpg'),
          //   // colorFilter: ColorFilter.mode(Colors.black, BlendMode.darken),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Column(
          children: [
            CustomAppBar(),
            Expanded(child: OnSalesList()),
          ],
        ),
      ),
    );
  }
}
