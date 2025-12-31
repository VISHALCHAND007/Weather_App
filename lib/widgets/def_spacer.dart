import 'package:flutter/material.dart';

class DefSpacer extends StatelessWidget {
  final double height;
  const DefSpacer({this.height = 15 , super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
