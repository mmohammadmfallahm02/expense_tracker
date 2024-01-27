import 'package:expense_tracker/collections/receipt.dart';
import 'package:expense_tracker/repository/adaptor.dart';
import 'package:isar/isar.dart';

import '../services/isar_services.dart';

class ReceiptsRepository extends Adapter<Receipts> {
  late final Isar _isar;

  ReceiptsRepository() : super() {
    _init();
  }

  Future<void> _init() async {
    _isar = await IsarServices().db;
  }

  @override
  Future<void> createMultipleObjects(List<Receipts> collections) async {
    _isar.writeTxn(() async {
      await _isar.receipts.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Receipts collection) async {
    await _isar.writeTxn(() async {
      _isar.receipts.put(collection);
    });
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await _isar.writeTxn(() async {
      _isar.receipts.deleteAll(ids);
    });
  }

  @override
  Future<void> deleteObject(int id) async {
    await _isar.writeTxn(() async {
      _isar.receipts.delete(id);
    });
  }

  @override
  Future<List<Receipts>> getAllObjects() async {
    return await _isar.receipts.where().findAll();
  }

  @override
  Future<Receipts?> getObjectById(int id) async {
    return await _isar.receipts.get(id);
  }

  @override
  Future<List<Receipts?>> getObjectsById(List<int> ids) async {
    return await _isar.receipts.getAll(ids);
  }

  @override
  Future<void> updateObject(Receipts collection) async {
    await _isar.writeTxn(() async {
      final budget = await _isar.receipts.get(collection.id);

      if (budget != null) {
        await _isar.receipts.put(collection);
      }
    });
  }
}
