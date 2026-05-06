import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessage {
  final String role; // 'user' or 'ai'
  final String text;
  final DateTime timestamp;

  ChatMessage({required this.role, required this.text, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'role': role,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        role: json['role'],
        text: json['text'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class TaxHelperScreen extends ConsumerStatefulWidget {
  const TaxHelperScreen({super.key});

  @override
  ConsumerState<TaxHelperScreen> createState() => _TaxHelperScreenState();
}

class _TaxHelperScreenState extends ConsumerState<TaxHelperScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  // Load saved chat history from device
  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('ai_chat_history');
    if (saved != null) {
      final List<dynamic> decoded = jsonDecode(saved);
      setState(() {
        _messages.addAll(decoded.map((e) => ChatMessage.fromJson(e)));
      });
      _scrollToBottom();
    }
  }

  // Save chat history to device
  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_messages.map((m) => m.toJson()).toList());
    await prefs.setString('ai_chat_history', encoded);
  }

  // Build user financial context for the AI
  String _buildUserContext() {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'User';
    final userEmail = user?.email ?? '';

    // Pull real data from the transaction provider
    final transactions = ref.read(transactionProvider);
    final balance = ref.read(transactionProvider.notifier).totalBalance;

    // Calculate category totals
    final Map<String, double> categoryTotals = {};
    double totalExpenses = 0;
    double totalIncome = 0;
    for (final tx in transactions) {
      if (tx.isIncome) {
        totalIncome += tx.amount;
      } else {
        totalExpenses += tx.amount.abs();
        categoryTotals[tx.category] =
            (categoryTotals[tx.category] ?? 0) + tx.amount.abs();
      }
    }

    // Build category breakdown string
    String categoryBreakdown = 'No expense data yet.';
    if (categoryTotals.isNotEmpty) {
      categoryBreakdown = categoryTotals.entries
          .map((e) => '  • ${e.key}: ₹${e.value.toInt()}')
          .join('\n');
    }

    // Build recent transactions string
    String recentTx = 'No transactions recorded yet.';
    if (transactions.isNotEmpty) {
      recentTx = transactions
          .take(10)
          .map((tx) =>
              '${tx.title} ${tx.isIncome ? '+' : '-'}₹${tx.amount.abs().toInt()} (${tx.category})')
          .join(', ');
    }

    return '''
You are KharchaAI — a smart, concise Indian personal finance advisor inside a fintech app.

USER PROFILE:
- Name: $userName
- Email: $userEmail

USER'S FINANCIAL DATA (live from app):
- Total Balance: ₹${balance.toInt()}
- Total Income This Month: ₹${totalIncome.toInt()}
- Total Expenses This Month: ₹${totalExpenses.toInt()}
- Category Breakdown:
$categoryBreakdown
- Recent Transactions: $recentTx

RULES:
1. Keep answers short, practical, and specific to Indian tax laws (FY 2025-26).
2. Use the user's actual data above to personalize suggestions.
3. Format responses with bullet points and sections when helpful.
4. When the user asks about savings, calculate based on their real expenses.
5. If the user has no data yet, guide them to start adding transactions.
6. DO NOT greet the user (e.g., do not say "Hi Arth" or "Hello"). Jump straight to the answer.
7. Use ₹ for currency. Be friendly but professional.
''';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _askGemini() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(role: 'user', text: prompt));
      _isLoading = true;
      _promptController.clear();
    });
    _scrollToBottom();
    await _saveChatHistory();

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
        throw Exception("Please add your Gemini API Key to the .env file");
      }

      debugPrint('Gemini: Using API key starting with ${apiKey.substring(0, 10)}...');
      debugPrint('Gemini: Calling model gemini-2.5-flash...');

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      // Prepend context to the user's prompt
      final context = _buildUserContext();
      final fullPrompt = '$context\n\nUser question: $prompt';

      final response = await model
          .generateContent([Content.text(fullPrompt)])
          .timeout(const Duration(seconds: 30));

      debugPrint('Gemini: Got response: ${response.text?.substring(0, 50)}...');

      setState(() {
        _messages.add(ChatMessage(role: 'ai', text: response.text ?? 'No response received.'));
      });
      await _saveChatHistory();
      _scrollToBottom();
    } catch (e, stackTrace) {
      debugPrint('Gemini ERROR: $e');
      debugPrint('Gemini STACK: $stackTrace');
      setState(() {
        _messages.add(ChatMessage(
          role: 'ai',
          text: '⚠️ Error: ${e.toString().replaceAll(RegExp(r'Exception: '), '')}',
        ));
      });
      await _saveChatHistory();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearChat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ai_chat_history');
    setState(() => _messages.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Financial Advisor'),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 22),
              tooltip: 'Clear chat',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppTheme.surfaceCard,
                    title: const Text('Clear Chat History?'),
                    content: const Text('This will delete all saved messages.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          _clearChat();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Clear', style: TextStyle(color: AppTheme.error)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoading) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),

          // Chat Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Ask about taxes, savings, budget...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onSubmitted: (_) => _askGemini(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryTeal, AppTheme.primaryTealDark],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                      onPressed: _isLoading ? null : _askGemini,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final suggestions = [
      '💰 How can I save more tax this year?',
      '📊 Analyze my monthly spending',
      '🏦 Should I invest in PPF or ELSS?',
      '📉 Where am I overspending?',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryTeal.withOpacity(0.15),
                  AppTheme.accentGold.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, size: 48, color: AppTheme.primaryTeal),
          ),
          const SizedBox(height: 24),
          Text(
            'Your AI Financial Advisor',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'I have access to your spending data and can give personalized advice on taxes, savings, and budgeting.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...suggestions.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    _promptController.text = s.replaceAll(RegExp(r'[^\w\s?]'), '').trim();
                    _askGemini();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12,
          left: isUser ? 48 : 0,
          right: isUser ? 0 : 48,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryTeal.withOpacity(0.15) : AppTheme.surfaceCard,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          border: Border.all(
            color: isUser ? AppTheme.primaryTeal.withOpacity(0.3) : Colors.white.withOpacity(0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  isUser ? Icons.person : Icons.auto_awesome,
                  size: 14,
                  color: isUser ? AppTheme.primaryTeal : AppTheme.accentGold,
                ),
                const SizedBox(width: 6),
                Text(
                  isUser ? 'You' : 'KharchaAI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isUser ? AppTheme.primaryTeal : AppTheme.accentGold,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.3)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Message body
            isUser
                ? SelectableText(
                    message.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  )
                : MarkdownBody(
                    data: message.text,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.5),
                      strong: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      em: const TextStyle(fontStyle: FontStyle.italic),
                      listBullet: TextStyle(color: AppTheme.primaryTeal, fontSize: 14),
                      h1: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      h2: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      h3: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: AppTheme.accentGold,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Thinking...',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
