import 'package:expense_tracker/collections/budget.dart';
import 'package:expense_tracker/collections/expense.dart';
import 'package:expense_tracker/collections/income.dart';
import 'package:expense_tracker/collections/receipt.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarServices {
  late Future<Isar> db;

  IsarServices() {
    db = openDb();
  }

  Future<Isar> openDb() async {
    final dir = await getApplicationCacheDirectory();
    if (Isar.instanceNames.isEmpty) {
      return Isar.open(
          [BudgetSchema, ExpenseSchema, IncomeSchema, ReceiptsSchema],
          directory: dir.path, name: 'expenseInstance');
    }
    return Future.value(Isar.getInstance());
  }
}
