import 'package:flutter/material.dart';
import 'package:spendee/models/category/category_model.dart';

class AddTransactionProvider extends ChangeNotifier {
  CategoryModel? selectedCategoryModel;
  //CategoryType? selectedCategoryType = CategoryType.income;
  DateTime selectedDateTime = DateTime.now();
  int value = 0;
  String? categoryId;
  notifyListeners();

  /* incomeChoiceChip() {
    value = 0;
    //selectedCategoryType = CategoryType.income;
    categoryId = null;
    notifyListeners();
  }

  expenseChoiceChip() {
    value = 1;
    //selectedCategoryType = CategoryType.expense;
    categoryId = null;
    notifyListeners();
  } */

  dateSelection(DateTime? selectedTempDate) {
    ('$selectedTempDate');
    if (selectedTempDate == null) {
      selectedDateTime = DateTime.now();
      notifyListeners();
    } else {
      selectedDateTime = selectedTempDate;
      notifyListeners();
    }
    notifyListeners();
  }
}
