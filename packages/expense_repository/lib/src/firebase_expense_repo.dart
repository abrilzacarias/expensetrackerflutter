import 'package:expense_repository/expense_repository.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExpenseRepository implements ExpenseRepository {
  final categoryCollection = FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  

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
        (e) => Category.fromEntity(CategoryEntity.fromDocument(e.data() as Map<String, Object>))).toList()
      );

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

}