import 'dart:math';

import 'package:expensetrackerflutter/screens/home/blocs/get_expenses/get_expenses_bloc.dart';
import 'package:expensetrackerflutter/screens/home/views/main_screen.dart';
import 'package:expensetrackerflutter/screens/stats/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import '../../add_expense/blocs/create_category/create_category_bloc.dart';
import '../../add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import '../../add_expense/blocs/create_income_bloc/create_income_bloc.dart';
import '../../add_expense/blocs/get_categories/get_categories_bloc.dart';
import '../../add_expense/views/add_transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //if adding more screens in the future, here
  //var widgetList = [MainScreen(), StatsScreen()];

  int index = 0;
  late Color selectedItem = Colors.black;
  Color unselectedItem = Colors.grey.shade500;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if ( state is GetExpensesSuccess) {
          return Scaffold(
            appBar: AppBar(),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                setState(() {
                  index = value;
                });
              },
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 3,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.home,
                      color: index == 0 ? selectedItem : unselectedItem,
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.graph_square_fill,
                      color: index == 1 ? selectedItem : unselectedItem,
                    ),
                    label: 'Stats')
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                var newExpense = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                        MultiBlocProvider(providers: [
                          BlocProvider(
                              create: (context) => CreateCategoryBloc(
                                  FirebaseExpenseRepository())),
                          BlocProvider(
                              create: (context) => GetCategoriesBloc(
                                  FirebaseExpenseRepository())
                                ..add(GetCategories())),
                          BlocProvider(
                              create: (context) => CreateExpenseBloc(
                                  FirebaseExpenseRepository())),
                          BlocProvider(
                              create: (context) => CreateIncomeBloc(
                                  FirebaseExpenseRepository())),
                                
                        ], child: const AddTransaction())));

                if(newExpense != null) {
                  setState(() {
                    state.expenses.insert(0, newExpense);
                  });
                }
              },
              shape: CircleBorder(),
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.tertiary,
                      ], transform: const GradientRotation(pi / 4))),
                  child: const Icon(CupertinoIcons.add)),
            ),
            body: index == 0 
            ? MainScreen(state.expenses) 
            : StatsScreen(),
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),)
          );
        }
        
      },
    );
  }
}
