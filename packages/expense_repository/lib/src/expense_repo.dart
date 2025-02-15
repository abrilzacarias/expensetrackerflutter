
import 'package:expense_repository/expense_repository.dart';

abstract class ExpenseRepository {
  
  Future<void> createCategory(Category category);

  Future<List<Category>> getCategories();

  Future<void> createExpense(Expense expense);

  Future<List<Expense>> getExpenses();

  Future<void> createIncome(Income income);

  Future<List<Income>> getIncome();
}