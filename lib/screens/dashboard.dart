import 'package:flutter/material.dart';
import 'package:my_finance/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import '../providers/transaction_provider.dart';
import '../models/transactions.dart'; // Import your Transactions model

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;

    // Calculate total spending per category
    final Map<String, double> categorySpendingMap = {};
    for (var transaction in transactions) {
      if (transaction.type == 'expense') {
        categorySpendingMap.update(
          transaction.category,
          (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }
    }

    // Convert the map to a list of Transactions objects for the chart
    final List<Transactions> categorySpendingList = categorySpendingMap.entries
        .map((entry) => Transactions(
              id: DateTime.now().toString(), // Generate a unique ID
              title: entry.key, // Use category as title
              amount: entry.value, // Total spending for the category
              type: 'expense', // Since we're tracking expenses
              category: entry.key, // Category name
              date: DateTime.now(), // Use current date (or any date)
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
                'Total Income: \$${_calculateTotalIncome(transactions).toStringAsFixed(2)}'),
            Text(
                'Total Expense: \$${_calculateTotalExpense(transactions).toStringAsFixed(2)}'),
            Text(
                'Net Balance: \$${_calculateNetBalance(transactions).toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <ChartSeries>[
                  BarSeries<Transactions, String>(
                    dataSource: categorySpendingList,
                    xValueMapper: (Transactions transaction, _) =>
                        transaction.category,
                    yValueMapper: (Transactions transaction, _) =>
                        transaction.amount,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalIncome(List<Transactions> transactions) {
    return transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateTotalExpense(List<Transactions> transactions) {
    return transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateNetBalance(List<Transactions> transactions) {
    return _calculateTotalIncome(transactions) -
        _calculateTotalExpense(transactions);
  }
}
