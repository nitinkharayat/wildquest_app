import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../core/utils/geo.dart';
import '../../models/quest.dart';
import '../../models/walking_session.dart';
import '../activity/activity_service.dart';
import '../location/location_service.dart';

abstract class WalkingSessionService {
  Stream<WalkingTick> get ticks;
  WalkingSession? get session;
  Future<void> start(Quest quest);
  void pause();
  void resume();
  Future<WalkingSession> stop({required bool completed, bool interrupted = false});
  Future<void> dispose();
}

class DefaultWalkingSessionService implements WalkingSessionService {
  DefaultWalkingSessionService({required LocationService location, required ActivityService activity, required this.demo}) : _location = location, _activity = activity;
  final LocationService _location;
  final ActivityService _activity;
  final bool demo;
  final _ticks = StreamController<WalkingTick>.broadcast();
  StreamSubscription<GeoPoint>? _positionSub;
  Timer? _timer;
  WalkingSession? _session;
  Quest? _quest;
  GeoPoint? _lastPoint;
  WalkingState _state = WalkingState.unknown;
  int _activeSeconds = 0;
  double _distance = 0;
  bool _paused = false;
  bool _targetReached = false;
  final _uuid = const Uuid();

  @override Stream<WalkingTick> get ticks => _ticks.stream;
  @override WalkingSession? get session => _session;

  @override
  Future<void> start(Quest quest) async {
    await _positionSub?.cancel();
    _quest = quest;
    _activeSeconds = 0;
    _distance = 0;
    _lastPoint = null;
    _paused = false;
    _targetReached = false;
    _state = WalkingState.unknown;
    _session = WalkingSession(id: _uuid.v4(), questId: quest.id, questTitle: quest.title, startedAt: DateTime.now(), activeSeconds: 0, distanceMeters: 0, demo: demo);
    await _activity.isAvailable();
    _positionSub = _location.positions().listen(_onPoint, onError: (_) => _emit());
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused) return;
      _activeSeconds++;
      _emit();
    });
    _emit();
  }

  void _onPoint(GeoPoint point) {
    if (_paused) return;
    final previous = _lastPoint;
    _lastPoint = point;
    if (previous == null) return;
    final delta = haversineMeters(previous, point);
    if (delta > 80 || delta < .5) return;
    _distance += delta;
    final seconds = (point.timestamp != null && previous.timestamp != null) ? point.timestamp!.difference(previous.timestamp!).inMilliseconds / 1000 : 1.0;
    final speed = seconds > 0 ? delta / seconds : 0.0;
    _state = speed < .7 ? WalkingState.still : speed <= 2.8 ? WalkingState.walking : speed <= 5.0 ? WalkingState.running : WalkingState.vehicle;
    _emit();
  }

  void _emit() {
    final quest = _quest;
    if (quest != null) _targetReached = _distance >= quest.distanceMeters;
    if (!_ticks.isClosed) _ticks.add(WalkingTick(elapsed: Duration(seconds: _activeSeconds), distanceMeters: _distance, state: _state, targetReached: _targetReached));
  }

  @override void pause() { _paused = true; _emit(); }
  @override void resume() { _paused = false; _emit(); }

  @override
  Future<WalkingSession> stop({required bool completed, bool interrupted = false}) async {
    _timer?.cancel(); _timer = null;
    await _positionSub?.cancel(); _positionSub = null;
    final base = _session!;
    final finished = WalkingSession(id: base.id, questId: base.questId, questTitle: base.questTitle, startedAt: base.startedAt, endedAt: DateTime.now(), activeSeconds: _activeSeconds, distanceMeters: _distance, completed: completed, interrupted: interrupted, demo: demo);
    _session = finished;
    return finished;
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel(); _timer = null;
    await _positionSub?.cancel(); _positionSub = null;
    await _ticks.close();
    await _location.dispose();
    await _activity.dispose();
  }
}
