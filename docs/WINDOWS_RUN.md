# Windows run

This build is frontend-only and does not need Gemma, ElevenLabs, GPS, an API key, or the Python backend.

## Fresh project

```powershell
flutter pub get
flutter run -d windows
```

## Updating the previous WildQuest checkout

Run:

```powershell
.\cleanup_old_integrations.ps1
flutter clean
flutter pub get
flutter run -d windows
```

The current UI includes a `COMPLETE DEMO` action so the full quest/reward flow can be demonstrated without a real outdoor sensor implementation.
