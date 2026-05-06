import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/firebase_config_loader.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'features/settings/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("⚠️ Failed to load .env file: $e");
  }

  // Load Firebase config from assets/json/firebase_config.json
  try {
    final options = await FirebaseConfigLoader.loadCurrentPlatform();
    await Firebase.initializeApp(options: options);
    debugPrint('✅ Firebase initialized successfully');
  } on FirebaseConfigException catch (e) {
    debugPrint('❌ Firebase config error: $e');
    debugPrint('   → Make sure assets/json/firebase_config.json has valid keys.');
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
  }
  
  runApp(
    const ProviderScope(
      child: KharchaApp(),
    ),
  );
}

class KharchaApp extends ConsumerWidget {
  const KharchaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final isDarkMode = ref.watch(settingsProvider).isDarkMode;

    return MaterialApp.router(
      title: 'KharchaAI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
