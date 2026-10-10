import 'dart:math' as math;

class GeoPoint {
  const GeoPoint({
    required this.latitude,
    required this.longitude,
    this.accuracy = 0,
    this.timestamp,
  });

  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime? timestamp;
}

/// Great-circle distance in metres.
double haversineMeters(GeoPoint a, GeoPoint b) {
  const earthRadius = 6371000.0;
  final dLat = _rad(b.latitude - a.latitude);
  final dLon = _rad(b.longitude - a.longitude);
  final lat1 = _rad(a.latitude);
  final lat2 = _rad(b.latitude);

  final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
  return 2 * earthRadius * math.asin(math.min(1, math.sqrt(h)));
}

double _rad(double deg) => deg * math.pi / 180.0;

