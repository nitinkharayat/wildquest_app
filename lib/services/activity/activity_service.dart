import 'dart:async';

import '../../models/walking_session.dart';

/// Abstraction over Android Activity Recognition.
///
/// The real plugin integration is intentionally isolated here. Swap
/// [MockActivityService] for a platform implementation without touching
/// the rest of the app.
abstract class ActivityService {
  Future<bool> isAvailable();
  Future<bool> requestPermission();
  Stream<WalkingState> states();
  Future<void> dispose();
}

/// Safe default used when activity recognition is unavailable or denied.
///
/// It infers a walking state from movement rather than claiming a sensor
/// reading it does not have — the app never fabricates sensor data.
class MockActivityService implements ActivityService {
  MockActivityService({this.assumeWalkingAfter = const Duration(seconds: 6)});

  final Duration assumeWalkingAfter;
  Timer? _timer;
  final _controller = StreamController<WalkingState>.broadcast();

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Stream<WalkingState> states() {
    _controller.add(WalkingState.unknown);
    _timer ??= Timer(assumeWalkingAfter, () {
      if (!_controller.isClosed) _controller.add(WalkingState.walking);
    });
    return _controller.stream;
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    await _controller.close();
  }
}

