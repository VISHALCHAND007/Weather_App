import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:weather_app/models/location_model.dart';

class LocationHelper {
  late final _location = Location();

  Future<void> requestPermission() async {
    await _location.requestPermission();
  }

  Future<LocationModel?> getUserCoordinatesMy() async {
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

  Future<LocationModel?> getUserCoordinates() async {
    try {
      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) return null;
      }

      await Future.delayed(const Duration(milliseconds: 300));

      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return null;
      }

      final result = await _location.getLocation();

      if (result.latitude == null || result.longitude == null) return null;

      return LocationModel(
        latitude: result.latitude!,
        longitude: result.longitude!,
      );
    } on PlatformException catch (e) {
      print("Location PlatformException code: ${e.code}");
      return null;
    } catch (e) {
      print("Unexpected location error: $e");
      return null;
    }
  }
}
