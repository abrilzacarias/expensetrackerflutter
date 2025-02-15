import '../entities/entities.dart';

class Income {
  String incomeId;
  //Category category;
  DateTime date;
  int amount;

  Income({
    required this.incomeId,
    required this.date,
    required this.amount
  });

  static final empty = Income(
    incomeId: '',
    date: DateTime.now(),
    amount: 0,
  );

  IncomeEntity toEntity() {
    return IncomeEntity(
      incomeId: incomeId,
      date: date,
      amount: amount
    );
  }

  static Income fromEntity(IncomeEntity entity) {
    return Income(
      incomeId: entity.incomeId,
      date: entity.date,
      amount: entity.amount
    );
  }
}