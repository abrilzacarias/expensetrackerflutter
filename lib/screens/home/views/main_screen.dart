import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:expensetrackerflutter/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expensetrackerflutter/screens/home/blocs/get_expenses/get_expenses_bloc.dart';
import 'package:expensetrackerflutter/screens/add_expense/blocs/get_income/get_income_bloc.dart';
import 'package:expensetrackerflutter/screens/utils/utils.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow[700],
                          ),
                        ),
                        Icon(
                          CupertinoIcons.person_fill,
                          color: Colors.yellow[900],
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const Text(
                          'name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      AuthService().signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Cerrar sesión'),
                    ),
                  ],
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildBalanceCard(context),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  double _totalExpenses(BuildContext context) {
    final expensesState = context.watch<GetExpensesBloc>().state;
    return (expensesState is GetExpensesSuccess)
        ? expensesState.expenses.fold(0, (sum, e) => sum + e.amount)
        : 0;
  }

  double _totalIncome(BuildContext context) {
    final incomeState = context.watch<GetIncomeBloc>().state;
    return (incomeState is GetIncomeSuccess)
        ? incomeState.income.fold(0, (sum, i) => sum + i.amount)
        : 0;
  }

  double _totalBalance(BuildContext context) {
    return _totalIncome(context) - _totalExpenses(context);
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          transform: const GradientRotation(pi / 4),
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Text(
            "\$ ${_totalBalance(context).toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIncomeExpenseWidget(
                  icon: CupertinoIcons.arrow_down,
                  color: Colors.greenAccent,
                  label: 'Income',
                  amount: _totalIncome(context),
                ),
                _buildIncomeExpenseWidget(
                  icon: CupertinoIcons.arrow_up,
                  color: Colors.redAccent,
                  label: 'Expenses',
                  amount: _totalExpenses(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseWidget({required IconData icon, required Color color, required String label, required double amount}) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white30),
          child: Icon(icon, color: color, size: 12),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400)),
            Text("\$ ${amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }


Widget _buildTransactionList() {
  return BlocBuilder<GetExpensesBloc, GetExpensesState>(
    builder: (context, expenseState) {
      return BlocBuilder<GetIncomeBloc, GetIncomeState>(
        builder: (context, incomeState) {
          List<dynamic> transactions = [];

          if (expenseState is GetExpensesSuccess) {
            transactions.addAll(expenseState.expenses);
          }
          if (incomeState is GetIncomeSuccess) {
            transactions.addAll(incomeState.income);
          }

          transactions.sort((a, b) => b.date.compareTo(a.date));

          if (transactions.isEmpty) {
            return const Center(child: Text("No transactions available"));
          }

          return Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, i) {
                final transaction = transactions[i];
                final isExpense = transaction is Expense;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    height: 90, // Aumentamos altura para agregar la fecha
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isExpense
                                          ? getColorFromHex(transaction.category.color)
                                          : Colors.greenAccent, // 💰 Ingresos en verde
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Icon(
                                    isExpense
                                        ? getCupertinoIcon(transaction.category.icon)
                                        : CupertinoIcons.money_dollar_circle, // Ícono de ingresos
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isExpense ? transaction.category.name : "Income",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(transaction.date), 
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600], 
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${isExpense ? "- " : "+ "}\$${transaction.amount}.00",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isExpense ? Colors.redAccent : Colors.greenAccent, // 🔴 Gastos en rojo, 🟢 Ingresos en verde
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                isExpense ? "Expense" : "Income", // 🏷️ Mostrar tipo de transacción
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600], // Color gris para la etiqueta
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}

}