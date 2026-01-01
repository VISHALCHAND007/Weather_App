import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/location_model.dart';

class LocationHelper {
  Future<void> requestPermission() async {
    await Geolocator.requestPermission();
  }

  Future<LocationModel?> getUserCoordinatesMy() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Optionally request enabling it (Geolocator doesn't auto-request, but you can guide user)
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (error) {
      rethrow;
    }
  }
}

// class LocationHelper {
//   late final _location = Location();
//
//   Future<void> requestPermission() async {
//     await _location.requestPermission();
//   }
//
//   Future<LocationModel?> getUserCoordinatesMy() async {
//     var serviceEnabled = await _location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _location.requestService();
//       if (!serviceEnabled) return null;
//     }
//     var permission = await _location.hasPermission();
//     if (permission != PermissionStatus.granted) {
//       return null;
//     }
//
//     // we have permission now
//     try {
//       final result = await _location.getLocation();
//       return LocationModel(
//         latitude: result.latitude ?? 0.0,
//         longitude: result.longitude ?? 0.0,
//       );
//     } catch (error) {
//       rethrow;
//     }
//   }
//
//   Future<LocationModel?> getUserCoordinates() async {
//     try {
//       PermissionStatus permission = await _location.hasPermission();
//       if (permission == PermissionStatus.denied) {
//         print("permission denied:: $permission");
//         permission = await _location.requestPermission();
//         print("permission:: $permission");
//         if (permission != PermissionStatus.granted) {
//           print("returning null");
//           return null;
//         }
//         ;
//       }
//
//       await Future.delayed(const Duration(milliseconds: 300));
//
//       bool serviceEnabled = await _location.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await _location.requestService();
//         if (!serviceEnabled) return null;
//       }
//
//       final result = await _location.getLocation();
//
//       if (result.latitude == null || result.longitude == null) return null;
//
//       return LocationModel(
//         latitude: result.latitude!,
//         longitude: result.longitude!,
//       );
//     } on PlatformException catch (e) {
//       print("Location PlatformException code: ${e.code}");
//       return null;
//     } catch (e) {
//       print("Unexpected location error: $e");
//       return null;
//     }
//   }
// }
