import 'package:expense_tracker/collections/income.dart';
import 'package:expense_tracker/repository/adaptor.dart';
import 'package:isar/isar.dart';

import '../services/isar_services.dart';

class IncomeRepository extends Adapter<Income> {
  late final Isar _isar;

  IncomeRepository() : super() {
    _init();
  }

  Future<void> _init() async {
    _isar = await IsarServices().db;
  }

  @override
  Future<void> createMultipleObjects(List<Income> collections) async {
    _isar.writeTxn(() async {
      await _isar.incomes.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Income collection) async {
    await _isar.writeTxn(() async {
      _isar.incomes.put(collection);
    });
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await _isar.writeTxn(() async {
      _isar.incomes.deleteAll(ids);
    });
  }

  @override
  Future<List<Income>> deleteObject(Income collection) async {
    await _isar.writeTxn(() async {
      _isar.incomes.delete(collection.id);
    });
    return await _isar.incomes.where().findAll();
  }

  @override
  Future<List<Income>> getAllObjects() async {
    return await _isar.incomes.where().findAll();
  }

  @override
  Future<Income?> getObjectById(int id) async {
    return await _isar.incomes.get(id);
  }

  @override
  Future<List<Income?>> getObjectsById(List<int> ids) async {
    return await _isar.incomes.getAll(ids);
  }

  @override
  Future<void> updateObject(Income collection) async {
    await _isar.writeTxn(() async {
      final budget = await _isar.incomes.get(collection.id);

      if (budget != null) {
        await _isar.incomes.put(collection);
      }
    });
  }
}
