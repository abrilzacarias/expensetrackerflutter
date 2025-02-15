part of 'get_income_bloc.dart';

sealed class GetIncomeState extends Equatable {
  const GetIncomeState();
  
  @override
  List<Object> get props => [];
}

final class GetIncomeInitial extends GetIncomeState {}
