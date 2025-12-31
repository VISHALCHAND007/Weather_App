import 'package:flutter/material.dart';

class WeatherCustomTile extends StatelessWidget {
  final IconData icon;
  final Color iconTint;
  final String title;
  final String time;

  const WeatherCustomTile({
    required this.icon,
    required this.iconTint,
    required this.title,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Icon(icon, color: iconTint,size: 35,),
        Text(title, style: TextStyle(fontSize: 16),),
        Text(time)
      ],
    );
  }
}