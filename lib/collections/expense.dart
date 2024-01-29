import 'package:expense_tracker/collections/receipt.dart';
import 'package:isar/isar.dart';

part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;

  @Index()
  late double amount;

  @Index()
  late DateTime date;

  @Enumerated(EnumType.name)
  CategoryEnum? categoryEnum;

  SubCategory? subCategory;

  final receipts = IsarLinks<Receipts>();

  @Index(composite: [CompositeIndex('amount')])
  String? paymentMethod;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String>? description;
}

enum CategoryEnum { bills, food, clothes, transport, fun, others }

@embedded
class SubCategory {
  String? name;
}
