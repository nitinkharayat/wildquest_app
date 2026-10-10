import 'package:go_router/go_router.dart';

import '../features/creatures/creature_screens.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_screens.dart';
import '../features/quests/quest_flow_screens.dart';
import '../features/rewards/reward_reveal_screen.dart';
import '../features/settings/settings_screens.dart';
import '../features/splash/splash_screen.dart';
import '../features/walking/walking_screens.dart';
import '../models/quest.dart';

class AppRoutes {
  const AppRoutes._();
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const quests = '/quests';
  static const questDetails = '/quests/details';
  static const walk = '/walk';
  static const complete = '/complete';
  static const reward = '/reward';
  static const collection = '/collection';
  static const creature = '/collection/creature';
  static const progress = '/progress';
  static const history = '/history';
  static const settings = '/settings';
}

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
      GoRoute(path: AppRoutes.quests, builder: (_, __) => const QuestSelectionScreen()),
      GoRoute(path: AppRoutes.questDetails, builder: (_, s) => QuestDetailsScreen(quest: s.extra as Quest)),
      GoRoute(path: AppRoutes.walk, builder: (_, s) => WalkingScreen(quest: s.extra as Quest)),
      GoRoute(path: AppRoutes.complete, builder: (_, __) => const QuestCompleteScreen()),
      GoRoute(path: AppRoutes.reward, builder: (_, __) => const RewardRevealScreen()),
      GoRoute(path: AppRoutes.collection, builder: (_, __) => const CollectionScreen()),
      GoRoute(path: AppRoutes.creature, builder: (_, s) => CreatureDetailScreen(creatureId: s.extra as String)),
      GoRoute(path: AppRoutes.progress, builder: (_, __) => const ProgressScreen()),
      GoRoute(path: AppRoutes.history, builder: (_, __) => const HistoryScreen()),
      GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen()),
    ],
  );
}
