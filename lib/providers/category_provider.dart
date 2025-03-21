import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<String> _categories = ['Salary', 'Groceris', 'Rent', 'Entertainment'];

  List<String> get categories => _categories;

  void addCategory(String category) {
    _categories.add(category);
    notifyListeners();
  }

  void deleteCategory(String category) {
    _categories.remove(category);
    notifyListeners();
  }
}
