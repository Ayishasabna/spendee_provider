import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendee/models/transactions/transaction_model.dart';

import 'income_expence.dart';

String transactionDbName = 'Transaction-database';

class ProviderTransaction extends ChangeNotifier {
  double incomeTotal = 0;
  double expenseTotal = 0;
  double totalBalance = 0;
  //String transactionDbName = 'Transaction-database';
  String showCategory = ("All");
  String dateFilterTitle = "All";
  List<TransactionModel> transactionListProvider = [];
  List<TransactionModel> overviewGraphTransactions = [];
  List<TransactionModel> overviewTransactions = [];

  set setOverviewTransactions(List<TransactionModel> overViewNewList) {
    overviewTransactions = overViewNewList;

    notifyListeners();
  }

  set setOverViewGraphTransactions(
      List<TransactionModel> overViewGraphTransactionsNewList) {
    overviewGraphTransactions = overViewGraphTransactionsNewList;

    notifyListeners();
  }

  set setDateFilterTitle(String dateFilterTitleNewList) {
    dateFilterTitle = dateFilterTitleNewList;

    notifyListeners();
  }

  set setShowCategory(String overShowCategory) {
    showCategory = overShowCategory;
    notifyListeners();
  }

  set setTransactionListNotifier(List<TransactionModel> transactionNewList) {
    transactionListProvider = transactionNewList;

    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel obj) async {
    final transactionDb =
        await Hive.openBox<TransactionModel>(transactionDbName);

    await transactionDb.put(obj.id, obj);
    refreshUi();
  }

  Future<void> deleteTransaction(TransactionModel obj) async {
    final transactionDb =
        await Hive.openBox<TransactionModel>(transactionDbName);

    await transactionDb.delete(obj.id);
    refreshUi();
  }

  Future<void> editTransaction(TransactionModel value) async {
    final transactionDb =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDb.put(value.id, value);

    refreshUi();
  }

  Future<List<TransactionModel>> getAllTransaction() async {
    final transactionDb =
        await Hive.openBox<TransactionModel>(transactionDbName);
    return transactionDb.values.toList().reversed.toList();
  }

  Future<void> refreshUi() async {
    final list = await getAllTransaction();
    //here we use sorting to make the current transaction to be shown first
    list.sort(((firstDate, secondDate) =>
        secondDate.datetime.compareTo(firstDate.datetime)));
    transactionListProvider.clear();
    transactionListProvider.addAll(list);

    overviewTransactions = transactionListProvider;
    overviewGraphTransactions = transactionListProvider;
    (transactionListProvider.toString());
    incomeAndExpense();
    notifyListeners();
  }

  void incomeAndExpense() async {
    await Hive.openBox<TransactionModel>(transactionDbName);
    incomeTotal = 0;
    expenseTotal = 0;
    totalBalance = 0;

    final List<TransactionModel> value = transactionListProvider;

    int total() {
      var history2 = transactionDB.values.toList();
      List a = [0, 0];
      for (var i = 0; i < history2.length; i++) {
        a.add(history2[i].finanace == 'income'
            ? int.parse(history2[i].amount)
            : int.parse(history2[i].amount) * -1);
      }
      totalBalance = a.reduce((value, element) => value + element);
      print("incomeTotal::::::::::$totalBalance");
      return totals;
    }

    int income() {
      var history2 = transactionDB.values.toList();
      List a = [0, 0];
      for (var i = 0; i < history2.length; i++) {
        a.add(history2[i].finanace == 'income'
            ? int.parse(history2[i].amount)
            : 0);
      }
      totals = a.reduce((value, element) => value + element);
      return totals;
    }

    int expense() {
      var history2 = transactionDB.values.toList();
      List a = [0, 0];
      for (var i = 0; i < history2.length; i++) {
        a.add(history2[i].finanace == 'income'
            ? 0
            : int.parse(history2[i].amount));
      }
      totals = a.reduce((value, element) => value + element);
      return totals;
    }

    /*    for (int i = 0; i < value.length; i++) {
      if (CategoryType.income == value[i].category.name) {
        incomeTotal = incomeTotal + value[i].amount;
      } else {
        expenseTotal = expenseTotal + value[i].amount;
      }
    }
    totalBalance = incomeTotal - expenseTotal; */

    notifyListeners();
  }
}
