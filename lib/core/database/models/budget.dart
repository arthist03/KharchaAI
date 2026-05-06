import 'package:isar/isar.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;

  late String category;
  
  late double monthlyLimit;
  
  late double currentSpent;
  
  late DateTime month;
}
