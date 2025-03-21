import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:my_finance/firebase_options.dart';
import 'package:my_finance/models/transactions.dart';
import 'package:my_finance/providers/auth_provider.dart';
import 'package:my_finance/providers/category_provider.dart';
import 'package:my_finance/providers/transaction_provider.dart';
import 'package:my_finance/screens/dashboard.dart';
import 'package:my_finance/screens/home_screen.dart';
import 'package:my_finance/screens/login_screen.dart';
import 'package:my_finance/screens/signup_screen.dart';
import 'package:my_finance/screens/transaction_form.dart';
import 'package:my_finance/service/notification_service.dart';
import 'package:provider/provider.dart';
// import 'package:my_finance/services/notification_service.dart'; // Import the NotificationService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionsAdapter());
  await Hive.openBox<Transactions>('transactions');

  // Initialize Notifications
  await NotificationService().init(); // Initialize the notification service

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        title: 'MyFinance',
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/home': (context) => HomeScreen(),
          '/dashboard': (context) => Dashboard(),
          '/transaction_form': (context) => TransactionForm(),
        },
      ),
    );
  }
}
