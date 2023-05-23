import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendee/models/transactions/transaction_model.dart';
import 'package:spendee/provider/transaction_provider.dart';

import '../db/income_expence.dart';
import '../db/transaction_db.dart';
import '../models/category/category_model.dart';
import 'category_provider.dart';

int totals = 0;
final transactionDB = Hive.box<TransactionModel>(transactionDbName);
final categoryDB = Hive.box<CategoryModel>(categoryDBName);

class IncomeAndExpence extends ChangeNotifier {
  int total() {
    var history2 = transactionDB.values.toList();
    List a = [0, 0];
    for (var i = 0; i < history2.length; i++) {
      a.add(history2[i].finanace == 'income'
          ? int.parse(history2[i].amount)
          : int.parse(history2[i].amount) * -1);
    }
    totals = a.reduce((value, element) => value + element);
    return totals;
  }

  int income() {
    var history2 = transactionDB.values.toList();
    List a = [0, 0];
    for (var i = 0; i < history2.length; i++) {
      a.add(
          history2[i].finanace == 'income' ? int.parse(history2[i].amount) : 0);
    }
    totals = a.reduce((value, element) => value + element);
    return totals;
  }

  int expense() {
    var history2 = transactionDB.values.toList();
    List a = [0, 0];
    for (var i = 0; i < history2.length; i++) {
      a.add(
          history2[i].finanace == 'income' ? 0 : int.parse(history2[i].amount));
    }
    totals = a.reduce((value, element) => value + element);
    return totals;
  }

  notifyListeners();
}
