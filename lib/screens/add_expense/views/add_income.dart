import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../blocs/create_income_bloc/create_income_bloc.dart';

class AddIncomeView extends StatefulWidget {
  const AddIncomeView({super.key});

  @override
  State<AddIncomeView> createState() => _AddIncomeViewState();
}

class _AddIncomeViewState extends State<AddIncomeView> {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  bool isLoading = false;
  late Income income;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    income = Income(
      incomeId: const Uuid().v1(),
      amount: 0,
      date: DateTime.now(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateIncomeBloc, CreateIncomeState>(
      listener: (context, state) {
        if (state is CreateIncomeSuccess) {
          Navigator.pop(context, income);
        } else if (state is CreateIncomeLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Add Income',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildAmountField(),
            const SizedBox(height: 32),
            _buildDateField(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(CupertinoIcons.money_dollar, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        hintText: 'Enter amount',
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: income.date,
          firstDate: DateTime.now().subtract(const Duration(days: 45)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (newDate != null) {
          setState(() {
            dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
            income.date = newDate;
          });
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(CupertinoIcons.calendar_today, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        hintText: 'Select Date',
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: kToolbarHeight,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TextButton(
              onPressed: () {
                setState(() {
                  income.amount = int.parse(amountController.text);
                });

                context.read<CreateIncomeBloc>().add(CreateIncome(income));
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green, // Diferenciar ingresos de gastos
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
            ),
    );
  }
}
