import 'package:flutter/material.dart';
import 'package:my_finance/models/transactions.dart';

class TransactionProvider with ChangeNotifier {
  List<Transactions> _transactions = [];

  List<Transactions> get transactions => _transactions;

  void addTransaction(Transactions transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void editTransaction(String id, Transactions updatedTransaction) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
