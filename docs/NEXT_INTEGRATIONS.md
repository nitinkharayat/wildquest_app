# Optional future integrations

The frontend was deliberately decoupled from external services.

## Gemma

Add an AI service behind `QuestGenerator` later. The UI should continue to accept a validated `Quest` object regardless of whether the source is a local deterministic generator or an AI runtime.

## ElevenLabs

Add a voice service only after the frontend is stable. Keep any private API credential off the client; use a server-side gateway for production voice generation.

## GPS / Android activity recognition

Replace the simulated `WalkController` with platform services in an Android-specific implementation. Keep the UI contract based on elapsed time, distance, and completion state.
