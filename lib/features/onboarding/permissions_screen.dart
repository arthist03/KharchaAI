import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/permissions/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _smsGranted = false;
  bool _notificationGranted = false;

  void _requestAll() async {
    final sms = await AppPermissions.requestSmsPermission();
    final notif = await AppPermissions.requestNotificationPermission();
    setState(() {
      _smsGranted = sms;
      _notificationGranted = notif;
    });
    
    if (_smsGranted && _notificationGranted && mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_moon, size: 64, color: AppTheme.primaryTeal),
              const SizedBox(height: 32),
              Text(
                'Bank-grade\nPrivacy',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'KharchaAI securely reads transactional SMS to automate your expense tracking. We never read your personal messages.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              _buildPermissionRow(
                icon: Icons.message,
                title: 'SMS Access',
                subtitle: 'To auto-read bank alerts',
                isGranted: _smsGranted,
              ),
              const SizedBox(height: 24),
              _buildPermissionRow(
                icon: Icons.notifications_active,
                title: 'Notifications',
                subtitle: 'To alert you on overspending',
                isGranted: _notificationGranted,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _requestAll,
                  child: const Text('Grant Permissions'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isGranted,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: isGranted ? AppTheme.primaryTeal : AppTheme.textSecondary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        if (isGranted)
          const Icon(Icons.check_circle, color: AppTheme.primaryTeal),
      ],
    );
  }
}
