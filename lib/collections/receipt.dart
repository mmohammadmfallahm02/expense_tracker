import 'package:expense_tracker/collections/expense.dart';
import 'package:isar/isar.dart';

part 'receipt.g.dart';

@collection
class Receipts {
  Id id = Isar.autoIncrement;

  late String name;
  
  @Backlink(to: 'receipts')
  final expense = IsarLink<Expense>();
}
