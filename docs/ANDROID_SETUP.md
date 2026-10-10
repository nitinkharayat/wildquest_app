# Android setup after scaffolding

From the repository root:

```bash
flutter create . --platforms=android
flutter pub get
```

Add the location permission to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

For a production build that continues tracking while the app is backgrounded/locked, implement and disclose Android background-location behavior separately; do not silently add it.

For an emulator, the backend URL is commonly:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8787
```

For a physical device, use the development machine's LAN IP and make sure the device can reach the backend.
