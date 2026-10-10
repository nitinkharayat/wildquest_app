import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'providers/providers.dart';
import 'services/storage/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await LocalStore.open();
  final container = ProviderContainer(
    overrides: [localStoreProvider.overrideWithValue(store)],
  );
  await container.read(progressProvider.notifier).load();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const WildQuestApp(),
    ),
  );
}
