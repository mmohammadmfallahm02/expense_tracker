import 'dart:io';

import 'package:expense_tracker/collections/budget.dart';
import 'package:expense_tracker/collections/expense.dart';
import 'package:expense_tracker/collections/receipt.dart';
import 'package:expense_tracker/repository/budget_repository.dart';
import 'package:expense_tracker/repository/expence_repository.dart';
import 'package:expense_tracker/repository/receipt_repository.dart';
import 'package:path_provider/path_provider.dart';

mixin Func {
  Future<void> createBudget(double amount) async {
    final budget = Budget()
      ..month = DateTime.now().month
      ..year = DateTime.now().year
      ..amount = amount;

    return await BudgetRepository().createObject(budget);
  }

  Future<Budget?> getBudget({required int month, required int year}) async {
    return await BudgetRepository()
        .getObjectByDate(month: month, year: year)
        .then((value) => value);
  }

  Future<void> updateBudget(Budget budget) async {
    return await BudgetRepository().updateObject(budget);
  }

  Future<void> createExpense(
      double amount,
      DateTime date,
      CategoryEnum categoryEnum,
      String subCat,
      Set<Receipts> receipts,
      List<String> description,
      String paymentMethod) async {
    final subcategory = SubCategory()..name = subCat;

    final formattedDate = date.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

    for (Receipts receipt in receipts) {
      await ReceiptsRepository().createObject(receipt);
    }

    Expense expense = Expense()
      ..amount = amount
      ..date = formattedDate
      ..categoryEnum = categoryEnum
      ..subCategory = subcategory
      ..description = description
      ..paymentMethod = paymentMethod
      ..receipts.addAll(receipts);

    return await ExpenseRepository().createObject(expense);
  }

  Future<List<Expense>> getTodaysExpenses() async {
    return await ExpenseRepository().getObjectsByToday().then((value) => value);
  }

  Future<List<Expense>> getAllExpenses() async {
    return await ExpenseRepository().getAllObjects().then((value) => value);
  }

  Future<String> getPath() async {
    Directory appDir = await getApplicationCacheDirectory();
    return appDir.path;
  }

  Future<List<Receipts>> getAllReceipts() async {
    return await ReceiptsRepository().getAllObjects();
  }

  Future<void> clearData() async {
    return await ExpenseRepository().clearData();
  }

  Future<double> getTotalExpenses() async {
    return await ExpenseRepository().totalExpenses();
  }

  Future<List<double>> subByCategory() async {
    List<double> total = [];
    for (var value in CategoryEnum.values) {
      double sum = await ExpenseRepository().getSumForCategory(value);
      total.add(sum);
    }
    return total;
  }

  Future<List<Expense>> expensesByCategory(CategoryEnum value) async {
    List<Expense> expenses = [];

    await ExpenseRepository().getObjectsByCategory(value).then((value) {
      expenses = value;
    });
    return expenses;
  }

  Future<List<Expense>> expensesByAmountRange(double low, double high) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsByAmountRange(low, high)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByAmountGreaterThan(double amount) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsWithAmountGreaterThan(amount)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByAmountLessThan(double amount) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsWithAmountLessThan(amount)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByCategoryAndAmount(
      CategoryEnum value, double amountHighValue) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsByOptions(value, amountHighValue)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByNotOthersCategory() async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsNotOthersCategory()
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByGroupFilter(
      String searchText, DateTime dateTime) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsByGroupFilter(searchText, dateTime)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByPaymentMethod(String searchText) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectBySearchText(searchText)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByUsingAny(
      List<CategoryEnum> categories) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsUsingAnyOf(categories)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByUsingAll(
      List<CategoryEnum> categories) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsUsingAllOf(categories)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByTags(int tags) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectWithTags(tags)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByTagName(String subCategory) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectBySubCategory(subCategory)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByReceipts(String receiptName) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsByReceipts(receiptName)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByPagination(int offset) async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getObjectsAndPaginate(offset)
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByFindFirst() async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .getOnlyFirstObject()
        .then((value) => expenses = value);

    return expenses;
  }

  Future<List<Expense>> expensesByDeleteFirst() async {
    List<Expense> expenses = [];

    await ExpenseRepository()
        .deleteOnlyFirstObject()
        .then((value) => expenses = value);

    return expenses;
  }

  Future<int> expensesByCount() async {
    return await ExpenseRepository().getTotalObjects();
  }

  Future<List<Expense>> expensesByFullTextSearch(String searchText) async {
    List<Expense> expenses = [];

    await ExpenseRepository().fullTExtSearch(searchText).then((value) {
      expenses = value;
    });

    return expenses;
  }

  Future<List<Expense>> deleteItem(Expense collection) async {
    List<Expense> expenses = [];

    await ExpenseRepository().deleteObject(collection).then((value) {
      expenses = value;
    });

    return expenses;
  }

  Future<void> clearGallery(List<Receipts> receipts) async {
    await ReceiptsRepository().clearGallery(receipts);
  }
}
