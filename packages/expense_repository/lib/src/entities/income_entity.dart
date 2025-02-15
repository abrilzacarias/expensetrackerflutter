import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeEntity {
  String incomeId;
  DateTime date;
  int amount;

  IncomeEntity({
    required this.incomeId,
    required this.date,
    required this.amount
  });

  Map<String, dynamic> toDocument() { 
    return {
      'incomeId': incomeId,
      'date': date,
      'amount': amount
    };
  }

  static IncomeEntity fromDocument(Map<String, dynamic> doc) { 
    return IncomeEntity(
      incomeId: doc['incomeId'],
      date: (doc['date'] as Timestamp).toDate(), 
      amount: doc['amount'],
    );
  }
}