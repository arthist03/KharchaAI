import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform, debugPrint;

/// Production-grade Firebase configuration loader.
///
/// Loads Firebase credentials from a gitignored JSON asset file
/// (`assets/json/firebase_config.json`) at runtime, ensuring
/// no API keys are ever hardcoded or committed to source control.
///
/// Usage:
/// ```dart
/// final options = await FirebaseConfigLoader.loadCurrentPlatform();
/// await Firebase.initializeApp(options: options);
/// ```
class FirebaseConfigLoader {
  static const String _configPath = 'assets/json/firebase_config.json';

  /// Loads the [FirebaseOptions] for the current platform.
  ///
  /// Throws [FirebaseConfigException] if the config file is missing,
  /// malformed, or doesn't contain a section for the current platform.
  static Future<FirebaseOptions> loadCurrentPlatform() async {
    final configMap = await _loadConfigFile();
    final platformKey = _resolvePlatformKey();
    return _parseOptions(configMap, platformKey);
  }

  /// Reads and decodes the JSON config from assets.
  static Future<Map<String, dynamic>> _loadConfigFile() async {
    try {
      final raw = await rootBundle.loadString(_configPath);
      final decoded = json.decode(raw);
      if (decoded is! Map<String, dynamic>) {
        throw FirebaseConfigException(
          'firebase_config.json must be a JSON object, got ${decoded.runtimeType}.',
        );
      }
      return decoded;
    } on FlutterError {
      throw FirebaseConfigException(
        'Firebase config not found at $_configPath. '
        'Please ensure the file exists and is declared in pubspec.yaml assets.',
      );
    } on FormatException catch (e) {
      throw FirebaseConfigException(
        'firebase_config.json contains invalid JSON: ${e.message}',
      );
    }
  }

  /// Maps the current platform to its config key.
  static String _resolvePlatformKey() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      default:
        throw FirebaseConfigException(
          'Unsupported platform: $defaultTargetPlatform',
        );
    }
  }

  /// Parses a platform section into [FirebaseOptions].
  static FirebaseOptions _parseOptions(
    Map<String, dynamic> config,
    String platformKey,
  ) {
    final section = config[platformKey];
    if (section == null || section is! Map<String, dynamic>) {
      throw FirebaseConfigException(
        'No "$platformKey" section found in firebase_config.json. '
        'Available platforms: ${config.keys.join(', ')}',
      );
    }

    // Validate required fields
    final apiKey = section['apiKey'] as String?;
    final appId = section['appId'] as String?;
    final messagingSenderId = section['messagingSenderId'] as String?;
    final projectId = section['projectId'] as String?;

    if (apiKey == null || apiKey.isEmpty || apiKey.startsWith('YOUR_')) {
      throw FirebaseConfigException(
        'Missing or placeholder "apiKey" in "$platformKey" config. '
        'Please replace placeholder values with your actual Firebase keys.',
      );
    }
    if (appId == null || appId.isEmpty || appId.startsWith('YOUR_')) {
      throw FirebaseConfigException(
        'Missing or placeholder "appId" in "$platformKey" config.',
      );
    }
    if (messagingSenderId == null || messagingSenderId.isEmpty) {
      throw FirebaseConfigException(
        'Missing "messagingSenderId" in "$platformKey" config.',
      );
    }
    if (projectId == null || projectId.isEmpty) {
      throw FirebaseConfigException(
        'Missing "projectId" in "$platformKey" config.',
      );
    }

    debugPrint('🔥 Firebase config loaded for platform: $platformKey');

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: section['authDomain'] as String?,
      storageBucket: section['storageBucket'] as String?,
      measurementId: section['measurementId'] as String?,
      iosBundleId: section['iosBundleId'] as String?,
    );
  }
}

/// Exception thrown when Firebase configuration fails to load.
class FirebaseConfigException implements Exception {
  final String message;
  const FirebaseConfigException(this.message);

  @override
  String toString() => 'FirebaseConfigException: $message';
}
