import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_income_event.dart';
part 'get_income_state.dart';

class GetIncomeBloc extends Bloc<GetIncomeEvent, GetIncomeState> {
  GetIncomeBloc() : super(GetIncomeInitial()) {
    on<GetIncomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
