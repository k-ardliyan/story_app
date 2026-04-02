import 'package:geocoding/geocoding.dart';

class ReverseGeocodingService {
  final Map<String, String> _cache = <String, String>{};

  Future<String> getAddress({
    required double latitude,
    required double longitude,
  }) async {
    final String key = _cacheKey(latitude, longitude);
    final String? cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        final String fallback = _fallback(latitude, longitude);
        _cache[key] = fallback;
        return fallback;
      }

      final Placemark place = placemarks.first;
      final List<String> parts = <String>[
        if ((place.street ?? '').trim().isNotEmpty) place.street!.trim(),
        if ((place.subLocality ?? '').trim().isNotEmpty)
          place.subLocality!.trim(),
        if ((place.locality ?? '').trim().isNotEmpty) place.locality!.trim(),
        if ((place.administrativeArea ?? '').trim().isNotEmpty)
          place.administrativeArea!.trim(),
        if ((place.country ?? '').trim().isNotEmpty) place.country!.trim(),
      ];

      final String address = parts.isEmpty
          ? _fallback(latitude, longitude)
          : parts.join(', ');
      _cache[key] = address;
      return address;
    } catch (_) {
      return _fallback(latitude, longitude);
    }
  }

  String _cacheKey(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(5)}_${longitude.toStringAsFixed(5)}';
  }

  String _fallback(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
  }
}
