import 'dart:async';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

import '../../core/constants/game_constants.dart';
import '../../core/utils/geo.dart';

enum LocationPermissionStatus { granted, denied, deniedForever, serviceDisabled }

abstract class LocationService {
  Future<LocationPermissionStatus> check();
  Future<LocationPermissionStatus> request();
  Stream<GeoPoint> positions();
  Future<void> dispose();
}

class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationPermissionStatus> check() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationPermissionStatus.serviceDisabled;
    }
    final permission = await Geolocator.checkPermission();
    return _map(permission);
  }

  @override
  Future<LocationPermissionStatus> request() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationPermissionStatus.serviceDisabled;
    }
    final permission = await Geolocator.requestPermission();
    return _map(permission);
  }

  LocationPermissionStatus _map(LocationPermission p) => switch (p) {
        LocationPermission.denied => LocationPermissionStatus.denied,
        LocationPermission.deniedForever =>
          LocationPermissionStatus.deniedForever,
        LocationPermission.whileInUse ||
        LocationPermission.always =>
          LocationPermissionStatus.granted,
        _ => LocationPermissionStatus.denied,
      };

  @override
  Stream<GeoPoint> positions() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: GameConstants.locationDistanceFilter,
      ),
    ).map(
      (p) => GeoPoint(
        latitude: p.latitude,
        longitude: p.longitude,
        accuracy: p.accuracy,
        timestamp: p.timestamp,
      ),
    );
  }

  @override
  Future<void> dispose() async {}
}

/// Deterministic synthetic walker used by DEMO MODE.
///
/// Produces a slow, believable loop around a fixed origin so judges can run the
/// full quest flow without leaving the room.
class DemoLocationService implements LocationService {
  DemoLocationService({this.metersPerSecond = 1.4});

  final double metersPerSecond;
  Timer? _timer;
  final _controller = StreamController<GeoPoint>.broadcast();

  double _angle = 0;
  static const _origin = GeoPoint(latitude: 37.7749, longitude: -122.4194);
  static const _radiusMeters = 60.0;

  @override
  Future<LocationPermissionStatus> check() async =>
      LocationPermissionStatus.granted;

  @override
  Future<LocationPermissionStatus> request() async =>
      LocationPermissionStatus.granted;

  @override
  Stream<GeoPoint> positions() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      // Angular step so the linear speed roughly matches a real walk.
      _angle += metersPerSecond / _radiusMeters;
      final lat = _origin.latitude + (_radiusMeters * math.cos(_angle)) / 111320.0;
      final lng = _origin.longitude +
          (_radiusMeters * math.sin(_angle)) /
              (111320.0 * math.cos(_origin.latitude * math.pi / 180));
      if (!_controller.isClosed) {
        _controller.add(GeoPoint(
          latitude: lat,
          longitude: lng,
          accuracy: 4,
          timestamp: DateTime.now(),
        ));
      }
    });
    return _controller.stream;
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    _timer = null;
    await _controller.close();
  }
}

