import 'dart:convert';

import 'package:weather_app/helpers/secret_keys.dart';
import 'package:weather_app/helpers/url.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<WeatherModel?> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      "${Url.weatherBaseUrl}?lat=$latitude&lon=$longitude&appId=${SecretKeys.weatherApiKey}",
    );
    final result = await http.get(url);
    if (result.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(result.body));
    } else {
      throw Exception("Error:: $result");
    }
  }
}
