import 'package:flutter/material.dart';
import 'package:my_finance/providers/category_provider.dart';
import 'package:provider/provider.dart';
// import 'package:my_finance/services/notification_service.dart'; //
import '../service/notification_service.dart';
import '../models/transactions.dart';
import '../providers/transaction_provider.dart';

class TransactionForm extends StatefulWidget {
  final Transactions? transaction;

  TransactionForm({this.transaction});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedType = 'income';
  String _selectedCategory = 'Salary';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _selectedType = widget.transaction!.type;
      _selectedCategory = widget.transaction!.category;
      _selectedDate = widget.transaction!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null
            ? 'Add Transaction'
            : 'Edit Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField(
                value: _selectedType,
                items: ['income', 'expense'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedType = value.toString()),
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: Provider.of<CategoryProvider>(context)
                    .categories
                    .map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value.toString()),
              ),
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
                child: Text('Select Date'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final transaction = Transactions(
                      id: widget.transaction?.id ?? DateTime.now().toString(),
                      title: _titleController.text,
                      amount: double.parse(_amountController.text),
                      type: _selectedType,
                      category: _selectedCategory,
                      date: _selectedDate,
                    );

                    if (widget.transaction == null) {
                      Provider.of<TransactionProvider>(context, listen: false)
                          .addTransaction(transaction);

                      // Schedule a notification for recurring payments
                      if (_selectedType == 'expense') {
                        await NotificationService().scheduleNotification(
                          title: 'Payment Due',
                          body:
                              'Your payment for ${_titleController.text} is due today.',
                          scheduledDate: _selectedDate,
                        );
                      }
                    } else {
                      Provider.of<TransactionProvider>(context, listen: false)
                          .editTransaction(transaction.id, transaction);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
