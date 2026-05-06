import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_provider.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Profile Section
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.surfaceCard,
                  child: Icon(Icons.person, size: 50, color: AppTheme.primaryTeal),
                ),
                const SizedBox(height: 16),
                Text(user?.displayName ?? 'User', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(user?.email ?? 'user@example.com', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryTeal,
                    side: const BorderSide(color: AppTheme.primaryTeal),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Settings Toggles
          Text('PREFERENCES', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.textSecondary)),
          const SizedBox(height: 16),
          _buildSwitchTile(
            context: context,
            title: 'Dark Mode',
            icon: Icons.dark_mode,
            value: settings.isDarkMode,
            onChanged: settingsNotifier.toggleTheme,
          ),
          _buildSwitchTile(
            context: context,
            title: 'Push Notifications',
            icon: Icons.notifications_active,
            value: settings.notificationsEnabled,
            onChanged: settingsNotifier.toggleNotifications,
          ),
          _buildSwitchTile(
            context: context,
            title: 'Auto-read SMS',
            icon: Icons.message,
            value: settings.smsReadingEnabled,
            onChanged: settingsNotifier.toggleSmsReading,
          ),
          _buildSwitchTile(
            context: context,
            title: 'Biometric Login',
            icon: Icons.fingerprint,
            value: settings.biometricAuthEnabled,
            onChanged: settingsNotifier.toggleBiometrics,
          ),
          
          const SizedBox(height: 32),
          
          Text('ACCOUNT', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.textSecondary)),
          const SizedBox(height: 16),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.surfaceCardLight, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.workspace_premium, color: AppTheme.accentGold),
            ),
            title: const Text('Subscription Plan'),
            subtitle: const Text('Free Tier'),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () => context.push('/paywall'),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.surfaceCardLight, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.logout, color: AppTheme.error),
            ),
            title: const Text('Log Out', style: TextStyle(color: AppTheme.error)),
            onTap: () async {
              await ref.read(authControllerProvider).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.surfaceCardLight, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppTheme.primaryTeal),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        value: value,
        activeColor: AppTheme.primaryTeal,
        onChanged: onChanged,
      ),
    );
  }
}
