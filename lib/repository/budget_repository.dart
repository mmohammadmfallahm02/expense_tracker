import 'package:expense_tracker/collections/budget.dart';
import 'package:expense_tracker/repository/adaptor.dart';
import 'package:expense_tracker/services/isar_services.dart';
import 'package:isar/isar.dart';

class BudgetRepository extends Adapter<Budget> {
  late final Isar _isar;

  BudgetRepository() : super() {
    _init();
  }

  Future<void> _init() async {
    _isar = await IsarServices().db;
  }

  @override
  Future<void> createMultipleObjects(List<Budget> collections) async {
    _isar.writeTxn(() async {
      await _isar.budgets.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Budget collection) async {
    await _isar.writeTxn(() async {
      _isar.budgets.put(collection);
    });
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await _isar.writeTxn(() async {
      _isar.budgets.deleteAll(ids);
    });
  }

  @override
  Future<List<Budget>> deleteObject(Budget collection) async {
    await _isar.writeTxn(() async {
      _isar.budgets.delete(collection.id);
    });
    return await _isar.budgets.where().findAll();
  }

  @override
  Future<List<Budget>> getAllObjects() async {
    return await _isar.budgets.where().findAll();
  }

  @override
  Future<Budget?> getObjectById(int id) async {
    return await _isar.budgets.get(id);
  }

  @override
  Future<List<Budget?>> getObjectsById(List<int> ids) async {
    return await _isar.budgets.getAll(ids);
  }

  @override
  Future<void> updateObject(Budget collection) async {
    await _isar.writeTxn(() async {
      final budget = await _isar.budgets.get(collection.id);

      if (budget != null) {
        await _isar.budgets.put(collection);
      }
    });
  }

  Future<Budget?> getObjectByDate(
      {required int month, required int year}) async {
    return await _isar.budgets
        .filter()
        .monthEqualTo(month)
        .yearEqualTo(year)
        .findFirst();
  }
}





/*
this is how to use

class SomeOtherClass {
 final BudgetRepository _budgetRepository = BudgetRepository();

 void someMethod() async {
    Budget budget = Budget(...); // Create a Budget object
    await _budgetRepository.createObject(budget);
 }
}

*/ 