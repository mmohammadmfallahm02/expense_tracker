import 'package:expense_tracker/collections/expense.dart';
import 'package:expense_tracker/repository/adaptor.dart';
import 'package:isar/isar.dart';

import '../services/isar_services.dart';

class ExpenseRepository extends Adapter<Expense> {
  late final Isar _isar;

  ExpenseRepository() : super() {
    _init();
  }

  Future<void> _init() async {
    _isar = await IsarServices().db;
  }

  @override
  Future<void> createMultipleObjects(List<Expense> collections) async {
    _isar.writeTxn(() async {
      await _isar.expenses.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Expense collection) async {
    await _isar.writeTxn(() async {
      _isar.expenses.put(collection);
    });
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await _isar.writeTxn(() async {
      _isar.expenses.deleteAll(ids);
    });
  }

  @override
  Future<void> deleteObject(int id) async {
    await _isar.writeTxn(() async {
      _isar.expenses.delete(id);
    });
  }

  @override
  Future<List<Expense>> getAllObjects() async {
    return await _isar.expenses.where().findAll();
  }

  @override
  Future<Expense?> getObjectById(int id) async {
    return await _isar.expenses.get(id);
  }

  @override
  Future<List<Expense?>> getObjectsById(List<int> ids) async {
    return await _isar.expenses.getAll(ids);
  }

  @override
  Future<void> updateObject(Expense collection) async {
    await _isar.writeTxn(() async {
      final budget = await _isar.expenses.get(collection.id);

      if (budget != null) {
        await _isar.expenses.put(collection);
      }
    });
  }
}
