import 'package:location/location.dart';
import 'package:weather_app/models/location_model.dart';

class LocationHelper {
  final _location = Location();

  Future<void> requestPermission() async {
    await _location.requestPermission();
  }

  Future<LocationModel?> getUserCoordinates() async {
    await requestPermission();
    var permission = await _location.hasPermission();
    if (permission != PermissionStatus.granted) {
      return null;
    }

    // we have permission now
    try {
      final result = await _location.getLocation();
      return LocationModel(
        latitude: result.latitude ?? 0.0,
        longitude: result.longitude ?? 0.0,
      );
    } catch (error) {
      rethrow;
    }
  }
}
