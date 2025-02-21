import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/add_expense/blocs/get_income/get_income_bloc.dart';
import 'screens/home/blocs/get_expenses/get_expenses_bloc.dart';
import 'screens/home/views/home_screen.dart';
import 'screens/login/views/login_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          primary: const Color(0xFF00B2E7),
          secondary: const Color(0xFFE064F7),
          tertiary: const Color(0xFFFF8D6C),
          outline: Colors.grey,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        GetExpensesBloc(FirebaseExpenseRepository())..add(GetExpenses()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetIncomeBloc(FirebaseExpenseRepository())..add(GetIncome()),
                  ),
                ],
                child: const HomeScreen(),
              );
            } else {
              return const LoginScreen();
            }
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
