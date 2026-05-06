import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool smsReadingEnabled;
  final bool biometricAuthEnabled;

  SettingsState({
    this.isDarkMode = true,
    this.notificationsEnabled = true,
    this.smsReadingEnabled = true,
    this.biometricAuthEnabled = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? smsReadingEnabled,
    bool? biometricAuthEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      smsReadingEnabled: smsReadingEnabled ?? this.smsReadingEnabled,
      biometricAuthEnabled: biometricAuthEnabled ?? this.biometricAuthEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      isDarkMode: prefs.getBool('isDarkMode') ?? true,
      notificationsEnabled: prefs.getBool('notificationsEnabled') ?? true,
      smsReadingEnabled: prefs.getBool('smsReadingEnabled') ?? true,
      biometricAuthEnabled: prefs.getBool('biometricAuthEnabled') ?? false,
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state.isDarkMode);
    await prefs.setBool('notificationsEnabled', state.notificationsEnabled);
    await prefs.setBool('smsReadingEnabled', state.smsReadingEnabled);
    await prefs.setBool('biometricAuthEnabled', state.biometricAuthEnabled);
  }

  void toggleTheme(bool value) {
    state = state.copyWith(isDarkMode: value);
    _saveSettings();
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
    _saveSettings();
  }

  void toggleSmsReading(bool value) {
    state = state.copyWith(smsReadingEnabled: value);
    _saveSettings();
  }

  void toggleBiometrics(bool value) {
    state = state.copyWith(biometricAuthEnabled: value);
    _saveSettings();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
