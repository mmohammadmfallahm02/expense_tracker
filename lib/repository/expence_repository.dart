import 'package:expense_tracker/collections/expense.dart';
import 'package:expense_tracker/collections/receipt.dart';
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
  Future<List<Expense>> deleteObject(Expense collection) async {
    await _isar.writeTxn(() async {
      await _isar.expenses.delete(collection.id);
    });

    return await _isar.expenses.where().findAll();
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

  Future<List<Expense>> getObjectsByToday() async {
    return await _isar.expenses
        .where()
        .dateEqualTo(DateTime.now().copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0))
        .findAll();
  }

  Future<double> getSumForCategory(CategoryEnum value) async {
    return await _isar.expenses
        .filter()
        .categoryEnumEqualTo(value)
        .amountProperty()
        .sum();
  }

  Future<List<Expense>> getObjectsByCategory(CategoryEnum value) async {
    return await _isar.expenses.filter().categoryEnumEqualTo(value).findAll();
  }

  Future<List<Expense>> getObjectsByAmountRange(
      double lowAmount, double highAmount) async {
    return await _isar.expenses
        .filter()
        .amountBetween(lowAmount, highAmount, includeLower: false)
        .findAll();
  }

  Future<List<Expense>> getObjectsWithAmountGreaterThan(
      double amountValue) async {
    return await _isar.expenses
        .filter()
        .amountGreaterThan(amountValue)
        .findAll();
  }

  Future<List<Expense>> getObjectsWithAmountLessThan(double amountValue) async {
    return await _isar.expenses.filter().amountLessThan(amountValue).findAll();
  }

  Future<List<Expense>> getObjectsByOptions(
      CategoryEnum value, double amountHighValue) async {
    return await _isar.expenses
        .filter()
        .categoryEnumEqualTo(value)
        .or()
        .amountGreaterThan(amountHighValue)
        .findAll();
  }

  Future<List<Expense>> getObjectsNotOthersCategory() async {
    return await _isar.expenses
        .filter()
        .not()
        .categoryEnumEqualTo(CategoryEnum.others)
        .findAll();
  }

  Future<List<Expense>> getObjectsByGroupFilter(
      String searchText, DateTime dateTime) async {
    return await _isar.expenses
        .filter()
        .categoryEnumEqualTo(CategoryEnum.others)
        .group((q) =>
            q.paymentMethodContains(searchText).or().dateEqualTo(dateTime))
        .findAll();
  }

  Future<List<Expense>> getObjectBySearchText(String searchText) async {
    return await _isar.expenses
        .filter()
        .paymentMethodStartsWith(searchText)
        .or()
        .paymentMethodEndsWith(searchText)
        .findAll();
  }

  Future<List<Expense>> getObjectsUsingAnyOf(
      List<CategoryEnum> categories) async {
    return await _isar.expenses
        .filter()
        .anyOf(categories, (q, CategoryEnum cat) => q.categoryEnumEqualTo(cat))
        .findAll();
  }

  Future<List<Expense>> getObjectsUsingAllOf(
      List<CategoryEnum> categories) async {
    return await _isar.expenses
        .filter()
        .allOf(categories, (q, CategoryEnum cat) => q.categoryEnumEqualTo(cat))
        .findAll();
  }

  Future<List<Expense>> getObjectWithoutPaymentMethod() async {
    return await _isar.expenses.filter().paymentMethodIsEmpty().findAll();
  }

  Future<List<Expense>> getObjectWithTags(int tags) async {
    return await _isar.expenses
        .filter()
        .descriptionLengthEqualTo(tags)
        .findAll();
  }

  Future<List<Expense>> getObjectWithTagName(String tagWord) async {
    return await _isar.expenses
        .filter()
        .descriptionElementEqualTo(tagWord, caseSensitive: false)
        .findAll();
  }

  Future<List<Expense>> getObjectBySubCategory(String subCategory) async {
    return await _isar.expenses
        .filter()
        .subCategory((q) => q.nameEqualTo(subCategory))
        .findAll();
  }

  Future<List<Expense>> getObjectsByReceipts(String receiptName) async {
    return await _isar.expenses
        .filter()
        .receipts(
            (q) => q.nameEqualTo(receiptName).or().nameContains(receiptName))
        .findAll();
  }

  Future<List<Expense>> getObjectsAndPaginate(int offset) async {
    return await _isar.expenses.where().offset(offset).limit(2).findAll();
  }

  Future<List<Expense>> getObjectWithDistinctValues() async {
    return await _isar.expenses.where().distinctByCategoryEnum().findAll();
  }

  Future<List<Expense>> getOnlyFirstObject() async {
    List<Expense> querySelected = [];

    await _isar.expenses.where().findFirst().then((value) {
      if (value != null) {
        querySelected.add(value);
      }
    });
    return querySelected;
  }

  Future<List<Expense>> deleteOnlyFirstObject() async {
    await _isar.writeTxn(() async {
      _isar.expenses.where().deleteFirst();
    });
    return await _isar.expenses.where().findAll();
  }

  Future<int> getTotalObjects() async {
    return await _isar.expenses.where().count();
  }

  Future<void> clearData() async {
    return _isar.writeTxn(() async {
      await _isar.clear();
    });
  }

  Future<List<String?>> getPaymentProperty() async {
    return await _isar.expenses.where().paymentMethodProperty().findAll();
  }

  Future<double> totalExpenses() async {
    return await _isar.expenses
        .where()
        .distinctByCategoryEnum()
        .amountProperty()
        .sum();
  }

  Future<List<Expense>> fullTExtSearch(String searchText) async {
    return await _isar.expenses
        .filter()
        .descriptionElementEqualTo(searchText)
        .or()
        .descriptionElementStartsWith(searchText)
        .or()
        .descriptionElementEndsWith(searchText)
        .findAll();

    // return await _isar.expenses
    //     .filter()
    //     .descriptionElementContains(searchText)
    //     .findAll();
  }
}
