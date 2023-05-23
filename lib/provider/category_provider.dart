import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendee/models/category/category_model.dart';

const categoryDBName = 'category-database';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> categoryProvider = [];

  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDBName);
    await categoryDB.put(value.categoryid, value);
    refreshUI();
  }

  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDBName);
    notifyListeners();
    return categoryDB.values.toList().reversed.toList();
  }

  Future<void> deleteCategory(String categoryID) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDBName);
    await categoryDB.delete(categoryID);
    refreshUI();
  }

  Future<void> refreshUI() async {
    final allCategories = await getCategories();
    categoryProvider.clear();

    await Future.forEach(
      allCategories,
      (CategoryModel category) {
        categoryProvider.add(category);
        //categoryProvider().addListener(() {category});
      },
    );
    notifyListeners();
  }
}
