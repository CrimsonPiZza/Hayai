import 'package:flutter/material.dart';

class ZenitsuLoadingIndicator extends StatelessWidget {
  const ZenitsuLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/icons/loading_zenitsu.gif',
        width: 64,
        height: 64,
      ),
    );
  }
}
