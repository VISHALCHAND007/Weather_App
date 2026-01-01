class WeatherModel {
  final String cityName;
  final String description;
  final double temperature;
  final double feelsLike;
  final double minTemperature;
  final double maxTemperature;
  final int humidity;
  final int sunrise;
  final int sunset;
  final double windSpeed;

  const WeatherModel({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.minTemperature,
    required this.maxTemperature,
    required this.humidity,
    required this.sunrise,
    required this.sunset,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json["name"],
      description: json["weather"][0]["description"],
      temperature: json["main"]["temp"] - 273.15,
      feelsLike: json["main"]["feels_like"] - 273.15,
      minTemperature: json["main"]["temp_min"] - 273.15,
      maxTemperature: json["main"]["temp_max"] - 273.15,
      humidity: json["main"]["humidity"],
      sunrise: json["sys"]["sunrise"],
      sunset: json["sys"]["sunset"],
      windSpeed: json["wind"]["speed"],
    );
  }
}
