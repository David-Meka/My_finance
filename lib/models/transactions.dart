import 'package:hive/hive.dart';

part 'transactions.g.dart'; // This will be generated

@HiveType(typeId: 0) // Unique typeId for Hive
class Transactions {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String type; // 'income' or 'expense'

  @HiveField(4)
  final String category;

  @HiveField(5)
  final DateTime date;

  Transactions({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });
}
