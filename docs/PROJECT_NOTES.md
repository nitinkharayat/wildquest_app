# WildQuest project notes

## Repaired from the generated source

- Wired `LocalStore` into Riverpod at startup.
- Added all screens referenced by the original router.
- Completed the truncated reusable widget file.
- Moved ElevenLabs API access behind a backend gateway so the secret is not embedded in the Flutter app.
- Added a deterministic AI quest JSON validator and offline fallback quests.
- Removed time-only quest completion; completion now requires meaningful movement and elapsed time.
- Added GPS-derived walking state for the MVP instead of pretending a sensor plugin was implemented.
- Added explicit demo completion for hackathon judging.
- Added backend configuration, README, and Git hygiene.

## Known limitations to test on Android

- This package contains Dart source; platform folders can be scaffolded with `flutter create . --platforms=android`.
- True background tracking while the app is locked/backgrounded needs Android-specific configuration and device testing.
- The current `totalScreenFreeSeconds` metric is a product metric based on quest session duration; a production version should verify screen-off/app-background time explicitly.
- Remote Gemma support expects a compatible endpoint configured as `GEMMA_ENDPOINT`.
