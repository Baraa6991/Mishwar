import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:mishwar/Constant/Apis.dart';

class MapService {
  final String googleApiKey = ApiConstants.googleKey;
  final Dio _dio = Dio(); // إعادة استخدام نفس الـ Dio instance

  LatLng? currentLocation;
  LatLng? destination;
  final Set<Polyline> polylines = {};

  double? estimatedDistanceKm;
  double? estimatedDurationMin;

  // الحصول على الموقع الحالي
  Future<LatLng?> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    currentLocation = LatLng(position.latitude, position.longitude);
    return currentLocation;
  }

  void setDestination(LatLng dest) {
    destination = dest;
  }

  // رسم الطريق على الخريطة
  Future<void> drawRoute() async {
    if (currentLocation == null || destination == null) return;

    final origin = '${currentLocation!.latitude},${currentLocation!.longitude}';
    final dest = '${destination!.latitude},${destination!.longitude}';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$dest&key=$googleApiKey';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['routes'] != null &&
          response.data['routes'].isNotEmpty) {
        final points = response.data['routes'][0]['overview_polyline']['points'];
        final polylineCoords = _decodePolyline(points);

        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylineCoords,
          ),
        );

        final leg = response.data['routes'][0]['legs'][0];
        estimatedDistanceKm = leg['distance']['value'] / 1000.0;
        estimatedDurationMin = leg['duration']['value'] / 60.0;
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int shift = 0, result = 0, b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  // البحث عن مكان بالاسم
  Future<LatLng?> searchPlace(String query) async {
    final cleanedQuery = query.trim();
    if (cleanedQuery.isEmpty || googleApiKey.isEmpty) return null;

    final url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json'
        '?input=${Uri.encodeComponent(cleanedQuery)}'
        '&inputtype=textquery'
        '&fields=geometry'
        '&key=$googleApiKey';

    try {
      final response = await _dio.get(url);
      final data = response.data;

      if (data != null &&
          data['status'] == 'OK' &&
          data['candidates'] != null &&
          data['candidates'].isNotEmpty) {
        final location = data['candidates'][0]['geometry']['location'];
        final LatLng newLatLng = LatLng(location['lat'], location['lng']);

        setDestination(newLatLng);
        return newLatLng;
      } else {
        debugPrint("لم يتم العثور على نتائج للبحث");
        return null;
      }
    } catch (e) {
      debugPrint("Error searching place: $e");
      return null;
    }
  }

  // اقتراحات الأماكن - محسّنة
  Future<List<String>> getPlaceSuggestions(String input) async {
    if (input.isEmpty || googleApiKey.isEmpty) return [];

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(input)}'
        '&types=geocode'
        '&key=$googleApiKey';

    try {
      final response = await _dio.get(url);
      final data = response.data;

      if (data != null && data['status'] == 'OK' && data['predictions'] != null) {
        return List<String>.from(data['predictions'].map((p) => p['description']));
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching suggestions: $e');
      return [];
    }
  }

  double distanceBetween(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        ) /
        1000;
  }

  Future<String> getAreaFromLatLng(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&language=ar&key=$googleApiKey';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 &&
          response.data['results'] != null &&
          response.data['results'].isNotEmpty) {
        final results = response.data['results'] as List;

        for (var result in results) {
          final components = result['address_components'] as List;
          for (var comp in components) {
            final types = List<String>.from(comp['types']);
            if (types.contains('neighborhood') ||
                types.contains('sublocality_level_1')) {
              return comp['long_name'];
            }
          }
        }

        final cityComp = results[0]['address_components'] as List;
        for (var comp in cityComp) {
          final types = List<String>.from(comp['types']);
          if (types.contains('locality')) {
            return comp['long_name'];
          }
        }
      }
    } catch (e) {
      debugPrint("Error reverse geocoding: $e");
    }

    return "منطقة غير معروفة";
  }

  /// ✅ إعادة تعيين كل شيء
  void reset() {
    destination = null;
    polylines.clear();
    estimatedDistanceKm = null;
    estimatedDurationMin = null;
  }
}