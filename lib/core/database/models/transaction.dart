import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  late String title;
  
  late double amount;
  
  /// e.g. "Food", "Transport", "Salary"
  late String category;
  
  /// e.g. "expense" or "income"
  late String type;
  
  late DateTime date;
  
  /// Original SMS content if parsed
  String? originalSms;
  
  /// Whether this was synced to cloud (for Lite mode)
  bool isSynced = false;
}
