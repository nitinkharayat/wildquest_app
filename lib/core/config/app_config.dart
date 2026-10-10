/// Runtime configuration. Never commit real credentials.
///
/// The mobile client talks to your own backend for privileged APIs such as
/// ElevenLabs and remote Gemma endpoints. This keeps secrets off the device.
class AppConfig {
  const AppConfig._();

  static const apiBaseUrlRaw = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get apiBaseUrl => apiBaseUrlRaw.trim().replaceFirst(RegExp(r'\/$'), '');

  static const gemmaModel = String.fromEnvironment(
    'GEMMA_MODEL',
    defaultValue: 'gemma-3-1b-it',
  );

  static bool get hasBackend => apiBaseUrl.isNotEmpty;
}
