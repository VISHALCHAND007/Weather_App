import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/widgets/def_spacer.dart';
import 'package:weather_app/widgets/weather_custom_tile.dart';
import 'package:intl/intl.dart' as intl;

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({required this.weather, super.key});

  String convertTime(int time) {
    final date = DateTime.fromMicrosecondsSinceEpoch(time);
    return intl.DateFormat("hh:mm a").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        color: Colors.white30,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [
              DefSpacer(height: 30),
              Lottie.asset("assets/lottie/sunny.json", height: 150, width: 150),
              DefSpacer(),
              Text(
                weather.cityName,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
              ),
              DefSpacer(),
              Text(
                "${weather.temperature.toStringAsFixed(2)} °C",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              DefSpacer(),
              Text(weather.description, style: TextStyle(fontSize: 20)),
              DefSpacer(),
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  Text(
                    "Humidity: ${weather.humidity}%",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Wind: ${weather.windSpeed} m/sec",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              DefSpacer(),
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  WeatherCustomTile(
                    icon: Icons.wb_sunny_outlined,
                    iconTint: Colors.orangeAccent,
                    title: "Sunrise",
                    time: convertTime(weather.sunrise),
                  ),
                  WeatherCustomTile(
                    icon: Icons.wb_twighlight,
                    iconTint: Colors.deepPurpleAccent,
                    title: "Sunset",
                    time: convertTime(weather.sunset),
                  ),
                ],
              ),
              DefSpacer(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
