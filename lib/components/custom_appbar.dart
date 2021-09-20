import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        child: ClipOval(
          child: Image.asset(
            'assets/images/profile.jpg',
            width: 48,
          ),
        ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ぜんいつ",
              style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w100,
                  color: Colors.white)),
          Text("Hi, Zenitsu",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
        ],
      ),
      trailing: Container(
        child: ClipOval(
          child: Image.asset(
            'assets/icons/menu_icon.png',
            width: 28,
          ),
        ),
      ),
    );
  }
}
