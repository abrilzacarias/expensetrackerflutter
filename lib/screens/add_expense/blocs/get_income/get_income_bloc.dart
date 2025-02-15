import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_income_event.dart';
part 'get_income_state.dart';

class GetIncomeBloc extends Bloc<GetIncomeEvent, GetIncomeState> {
  ExpenseRepository expenseRepository;

  GetIncomeBloc(this.expenseRepository) : super(GetIncomeInitial()) {
    on<GetIncome>((event, emit) async {
      emit(GetIncomeLoading());

      try {
        List<Income> income =  await expenseRepository.getIncome();
        emit(GetIncomeSuccess(income));
      } catch (e) {
        emit(GetIncomeFailure());
      }
    });
  }
}
