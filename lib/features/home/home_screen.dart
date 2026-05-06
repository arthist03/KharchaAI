import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/theme/app_theme.dart';
import '../auth/auth_provider.dart';

// Transaction model
class Transaction {
  final String title;
  final double amount;
  final String category;
  final IconData icon;
  final Color color;
  final DateTime date;

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.icon,
    required this.color,
    required this.date,
  });

  bool get isIncome => amount > 0;

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
        'category': category,
        'iconCode': icon.codePoint,
        'colorValue': color.value,
        'date': date.toIso8601String(),
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        title: json['title'],
        amount: (json['amount'] as num).toDouble(),
        category: json['category'],
        icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
        color: Color(json['colorValue']),
        date: DateTime.parse(json['date']),
      );
}

// Transaction provider
class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('transactions');
    if (saved != null) {
      final List<dynamic> decoded = jsonDecode(saved);
      state = decoded.map((e) => Transaction.fromJson(e)).toList();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'transactions', jsonEncode(state.map((t) => t.toJson()).toList()));
  }

  void add(Transaction tx) {
    state = [tx, ...state];
    _save();
  }

  void remove(int index) {
    state = [...state]..removeAt(index);
    _save();
  }

  double get totalBalance =>
      state.fold(0.0, (sum, tx) => sum + tx.amount);
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  return TransactionNotifier();
});

// Category helpers
final categoryMap = {
  'Food & Dining': {'icon': Icons.fastfood, 'color': Colors.orange},
  'Transport': {'icon': Icons.directions_car, 'color': Colors.blue},
  'Shopping': {'icon': Icons.shopping_bag, 'color': Colors.purple},
  'Bills & Utilities': {'icon': Icons.receipt_long, 'color': Colors.red},
  'Entertainment': {'icon': Icons.movie, 'color': Colors.pink},
  'Health': {'icon': Icons.local_hospital, 'color': Colors.green},
  'Salary': {'icon': Icons.account_balance, 'color': AppTheme.primaryTeal},
  'Freelance': {'icon': Icons.work, 'color': Colors.teal},
  'Other': {'icon': Icons.more_horiz, 'color': Colors.grey},
};

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final transactions = ref.watch(transactionProvider);
    final balance = ref.read(transactionProvider.notifier).totalBalance;

    // Dynamic greeting
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning,';
    } else if (hour < 17) {
      greeting = 'Good Afternoon,';
    } else {
      greeting = 'Good Evening,';
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(greeting,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      Text(user?.displayName ?? 'User',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.push('/settings'),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.surfaceCard,
                      child: Icon(Icons.person, color: AppTheme.primaryTeal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Balance card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.05), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryTeal.withOpacity(0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Balance',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white.withOpacity(0.7))),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${_formatCurrency(balance)}',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: AppTheme.primaryTeal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(context, Icons.document_scanner,
                      'Scan Receipt', () => context.push('/scanner')),
                  _buildQuickAction(context, Icons.account_balance,
                      'Tax Helper', () => context.push('/tax_helper')),
                  _buildQuickAction(context, Icons.workspace_premium,
                      'Upgrade Pro', () => context.push('/paywall')),
                ],
              ),
              const SizedBox(height: 32),
              Text('Recent Transactions',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long,
                                size: 64,
                                color: Colors.white.withOpacity(0.15)),
                            const SizedBox(height: 16),
                            Text('No transactions yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.white.withOpacity(0.4))),
                            const SizedBox(height: 8),
                            Text('Tap + to add your first one',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.white.withOpacity(0.3),
                                        fontSize: 12)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: transactions.length > 5
                            ? 5
                            : transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          return _buildTransactionItem(context, tx);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransaction(context, ref),
        backgroundColor: AppTheme.primaryTeal,
        child: const Icon(Icons.add, color: AppTheme.background),
      ),
    );
  }

  void _showAddTransaction(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'Food & Dining';
    bool isIncome = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Add Transaction',
                    style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 20),
                // Income/Expense toggle
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setSheetState(() => isIncome = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isIncome
                                ? AppTheme.error.withOpacity(0.2)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: !isIncome
                                    ? AppTheme.error.withOpacity(0.5)
                                    : Colors.transparent),
                          ),
                          child: Center(
                            child: Text('Expense',
                                style: TextStyle(
                                    color: !isIncome
                                        ? AppTheme.error
                                        : Colors.white54,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setSheetState(() => isIncome = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isIncome
                                ? AppTheme.primaryTeal.withOpacity(0.2)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: isIncome
                                    ? AppTheme.primaryTeal.withOpacity(0.5)
                                    : Colors.transparent),
                          ),
                          child: Center(
                            child: Text('Income',
                                style: TextStyle(
                                    color: isIncome
                                        ? AppTheme.primaryTeal
                                        : Colors.white54,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Title (e.g. Swiggy, Rent)',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Amount (₹)',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: const Color(0xFF1E1E1E),
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryTeal),
                  menuMaxHeight: 300,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  items: categoryMap.entries.map((entry) {
                    final icon = entry.value['icon'] as IconData;
                    final color = entry.value['color'] as Color;
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: color, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(entry.key),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (v) =>
                      setSheetState(() => selectedCategory = v ?? selectedCategory),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final amount =
                          double.tryParse(amountController.text.trim());
                      final title = titleController.text.trim();
                      if (title.isEmpty || amount == null || amount <= 0) return;

                      final cat = categoryMap[selectedCategory]!;
                      ref.read(transactionProvider.notifier).add(Transaction(
                            title: title,
                            amount: isIncome ? amount : -amount,
                            category: selectedCategory,
                            icon: cat['icon'] as IconData,
                            color: cat['color'] as Color,
                            date: DateTime.now(),
                          ));
                      Navigator.pop(ctx);
                    },
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction tx) {
    final dateStr = _formatDate(tx.date);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tx.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(tx.icon, color: tx.color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(dateStr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${tx.isIncome ? '+' : '-'}₹ ${_formatCurrency(tx.amount.abs())}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16,
                  color: tx.isIncome ? AppTheme.primaryTeal : Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCardLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryTeal),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final isNeg = amount < 0;
    final abs = amount.abs();
    if (abs >= 100000) {
      final lakhs = (abs / 100000).toStringAsFixed(2);
      return '${isNeg ? '-' : ''}$lakhs L';
    }
    if (abs >= 1000) {
      final thousands = (abs / 1000).floor();
      final remainder = (abs % 1000).toInt();
      if (remainder == 0) return '${isNeg ? '-' : ''}$thousands,000';
      return '${isNeg ? '-' : ''}$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return '${isNeg ? '-' : ''}${abs.toInt()}';
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDay = DateTime(dt.year, dt.month, dt.day);
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';

    if (txDay == today) return 'Today, $h:$m $ampm';
    if (txDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, $h:$m $ampm';
    }
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
