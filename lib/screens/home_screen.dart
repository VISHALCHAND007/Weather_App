import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/helpers/location_helper.dart';
import 'package:weather_app/helpers/strings.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = false;
  late final scaffoldMessenger = ScaffoldMessenger.of(context);
  final weatherService = WeatherService();
  double? latitude;
  double? longitude;
  WeatherModel? _weather;

  void _saveTestCoordinates() async {
    final lat = 28.7041;
    final long = 77.1025;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Strings.userLocation, "$lat,$long");
  }

  Color get getBgColor {
    final desc = _weather?.description.toLowerCase() ?? "";

    if (desc.contains("cloud") ||
        desc.contains("fog") ||
        desc.contains("mist")) {
      return Colors.grey.shade400;
    } else if (desc.contains("rain")) {
      return Colors.blueGrey;
    } else if (desc.contains("clear") || desc.contains("sun")) {
      return Colors.orangeAccent;
    } else if (desc.contains("snow")) {
      return Colors.blue.shade200;
    } else if (desc.contains("storm") || desc.contains("thunder")) {
      return Colors.deepPurple;
    }

    return Colors.blue; // default
  }

  Color get bgLightColor {
    final desc = _weather?.description.toLowerCase() ?? "";

    if (desc.contains("cloud") ||
        desc.contains("fog") ||
        desc.contains("mist")) {
      return Colors.grey.shade300;
    } else if (desc.contains("rain")) {
      return Colors.blueGrey.shade300;
    } else if (desc.contains("clear") || desc.contains("sun")) {
      return Colors.orange.shade300;
    } else if (desc.contains("snow")) {
      return Colors.lightBlue.shade200;
    } else if (desc.contains("storm") || desc.contains("thunder")) {
      return Colors.deepPurple.shade300;
    }

    return Colors.blue.shade300;
  }

  void fetchWeather() async {
    final weather = await weatherService.getWeather(
      latitude: latitude!,
      longitude: longitude!,
    );
    if (weather != null) {
      setState(() {
        _weather = weather;
      });
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Some error occurred...")),
      );
    }
  }

  void checkUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final userLocation = prefs.getString(Strings.userLocation);
    if (userLocation == null) {
      print("fetching user location.");
      _fetchLocation();
    } else {
      latitude = double.parse(userLocation.split(",")[0]);
      longitude = double.parse(userLocation.split(",")[1]);

      print("$latitude, $longitude ::pre-saved.");
      fetchWeather();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserLocation();
    });
  }

  void _fetchLocation() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    try {
      final helper = LocationHelper();
      await helper.requestPermission();
      final _fetchLocation = await helper.getUserCoordinates();
      if (_fetchLocation != null) {
        latitude = _fetchLocation.latitude;
        longitude = _fetchLocation.longitude;

        prefs.setString(Strings.userLocation, "$latitude,$longitude");
        print("$latitude, $longitude ::fetched.");

        //make request
        fetchWeather();
      }
    } catch (error) {
      print(error);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Error:: $error")));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
        backgroundColor: bgLightColor,
        actions: [
          IconButton(onPressed: _fetchLocation, icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: _saveTestCoordinates,
            icon: Icon(Icons.control_point_duplicate),
          ),
        ],
      ),
      body: isLoading
          ? progress()
          : _weather != null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [bgLightColor, getBgColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: WeatherCard(weather: _weather!),
            )
          : progress(),
    );
  }

  Center progress() => Center(child: CircularProgressIndicator());
}
