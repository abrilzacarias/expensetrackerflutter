import 'package:expense_repository/expense_repository.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExpenseRepository implements ExpenseRepository {
  final categoryCollection = FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');
  final incomeCollection = FirebaseFirestore.instance.collection('income');

  @override
  Future<void> createCategory(Category category) async {
    try {
      return await categoryCollection
      .doc(category.categoryId)
      .set(category.toEntity().toDocument());

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      return await categoryCollection
      .get()
      .then((value) => value.docs.map(
        (e) => Category.fromEntity(CategoryEntity.fromDocument(e.data()))).toList()
      );

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    try {
      return await expenseCollection
      .doc(expense.expenseId)
      .set(expense.toEntity().toDocument());

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      return await expenseCollection
      .get()
      .then((value) => value.docs.map(
        (e) => Expense.fromEntity(ExpenseEntity.fromDocument(e.data()))).toList()
      );

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Future<void> createIncome(Income income) async {
    try {
      return await incomeCollection
      .doc(income.incomeId)
      .set(income.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Future<List<Income>> getIncome() async {
    try {
      return await incomeCollection
      .get()
      .then((value) => value.docs.map(
        (e) => Income.fromEntity(IncomeEntity.fromDocument(e.data()))).toList()
      );

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}