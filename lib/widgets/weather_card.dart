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

  String get _getAsset {
    final description = weather.description;
    var result = "assets/lottie/sunny.json";
    if (description.contains("cloud")) {
      result = "assets/lottie/cloudy.json";
    } else if (description.contains("sun") || description.contains("clear")) {
      result = "assets/lottie/sunny.json";
    } else if (description.contains("rain")) {
      result = "assets/lottie/rain.json";
    } else if (description.contains("snow")) {
      result = "assets/lottie/snowfall.json";
    } else if (description.contains("fog") || description.contains("mist")) {
      result = "assets/lottie/fog.json";
    }
    return result;
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
              Lottie.asset(_getAsset, height: 150, width: 150),
              DefSpacer(height: 5),
              Text(
                weather.cityName,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
              ),
              Divider(),
              DefSpacer(height: 5),
              Text(
                "Feels like: ${weather.feelsLike.toStringAsFixed(2)} °C",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              // DefSpacer(height: 1,),
              Text(
                "Temperature: ${weather.temperature.toStringAsFixed(2)} °C",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              DefSpacer(),
              Text(weather.description, style: TextStyle(fontSize: 20)),
              DefSpacer(),
              Divider(),
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
              DefSpacer(),
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  Text(
                    "Humidity: ${weather.humidity}%",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  Text(
                    "Wind: ${weather.windSpeed} m/sec",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),
              // DefSpacer(),
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  Text(
                    "Min temp.: ${weather.minTemperature.toStringAsFixed(2)} °C",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  Text(
                    "Max temp.: ${weather.maxTemperature.toStringAsFixed(2)} °C",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
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
