import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _isPro = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Upgrade KharchaAI'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.workspace_premium, size: 80, color: AppTheme.accentGold),
            const SizedBox(height: 24),
            Text(
              'Choose Your Experience',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: _buildPlanCard(
                    title: 'Lite',
                    price: '₹79',
                    aiType: 'Cloud AI',
                    features: ['Auto SMS parsing', 'Basic insights'],
                    isPopular: false,
                    isSelected: !_isPro,
                    onTap: () => setState(() => _isPro = false),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPlanCard(
                    title: 'Pro',
                    price: '₹149',
                    aiType: 'On-Device AI',
                    features: ['Full privacy', 'Predictive AI', 'OCR Scanner', 'Tax Export'],
                    isPopular: true,
                    isSelected: _isPro,
                    onTap: () => setState(() => _isPro = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (!_isPro)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: const Text(
                  'Disclaimer: Lite mode sends transaction data to our secure cloud API for processing. We use end-to-end encryption.',
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPro ? AppTheme.accentGold : AppTheme.primaryTeal,
                  foregroundColor: AppTheme.background,
                ),
                onPressed: () {
                  // Connect to RevenueCat later
                },
                child: Text('Subscribe to ${_isPro ? "Pro" : "Lite"}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String aiType,
    required List<String> features,
    required bool isPopular,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceCardLight : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? (isPopular ? AppTheme.accentGold : AppTheme.primaryTeal) : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isPopular ? AppTheme.accentGold : AppTheme.primaryTeal).withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Most Popular', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            else
              const SizedBox(height: 20),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('$price/mo', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24, color: isPopular ? AppTheme.accentGold : AppTheme.primaryTeal)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(aiType, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            ),
            const SizedBox(height: 24),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
