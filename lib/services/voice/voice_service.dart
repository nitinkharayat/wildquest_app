import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../core/config/app_config.dart';

abstract class VoiceService {
  bool get isAvailable;
  Future<void> speak(String text, {required String cacheKey});
  Future<void> stop();
  Future<void> dispose();
}

class SilentVoiceService implements VoiceService {
  const SilentVoiceService();
  @override bool get isAvailable => false;
  @override Future<void> speak(String text, {required String cacheKey}) async {}
  @override Future<void> stop() async {}
  @override Future<void> dispose() async {}
}

/// Calls the WildQuest backend. The ElevenLabs API key never ships in the app.
class BackendVoiceService implements VoiceService {
  BackendVoiceService({http.Client? client, AudioPlayer? player})
      : _client = client ?? http.Client(),
        _player = player ?? AudioPlayer();
  final http.Client _client;
  final AudioPlayer _player;

  @override
  bool get isAvailable => AppConfig.hasBackend;

  @override
  Future<void> speak(String text, {required String cacheKey}) async {
    if (!isAvailable || text.trim().isEmpty) return;
    try {
      final safeKey = _safeCacheKey(cacheKey);
      final cached = await _cached(safeKey);
      final file = cached ?? await _download(text, safeKey);
      if (file == null) return;
      await _player.stop();
      await _player.play(DeviceFileSource(file.path));
    } catch (_) {}
  }

  String _safeCacheKey(String key) => key.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

  Future<File?> _download(String text, String cacheKey) async {
    final response = await _client.post(
      Uri.parse('${AppConfig.apiBaseUrl}/api/voice'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text, 'cache_key': cacheKey}),
    ).timeout(const Duration(seconds: 25));
    if (response.statusCode < 200 || response.statusCode >= 300 || response.bodyBytes.isEmpty) return null;
    final dir = await _cacheDir();
    final file = File('${dir.path}/$cacheKey.mp3');
    await file.writeAsBytes(response.bodyBytes, flush: true);
    return file;
  }

  Future<File?> _cached(String cacheKey) async {
    final file = File('${(await _cacheDir()).path}/$cacheKey.mp3');
    return file.existsSync() ? file : null;
  }

  Future<Directory> _cacheDir() async {
    final root = await getApplicationSupportDirectory();
    final dir = Directory('${root.path}/wildquest_voice');
    await dir.create(recursive: true);
    return dir;
  }

  @override Future<void> stop() async { try { await _player.stop(); } catch (_) {} }
  @override Future<void> dispose() async { await _player.dispose(); _client.close(); }
}
