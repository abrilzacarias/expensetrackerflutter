import 'package:expense_repository/expense_repository.dart';
import 'package:expensetrackerflutter/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expensetrackerflutter/screens/add_expense/blocs/get_categories/get_categories_bloc.dart';
import 'package:expensetrackerflutter/screens/add_expense/views/add_category_expense.dart';
import 'package:expensetrackerflutter/screens/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool isLoading = false;
  late Expense expense;

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
  }

  void _onCategorySelected(Category category) {
    setState(() {
      expense.category = category;
      categoryController.text = category.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          Navigator.pop(context, expense);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = !isLoading;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Add Expense',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      _buildAmountField(),
                      const SizedBox(height: 32),
                      _buildCategoryField(state),
                      _buildCategoryList(state.categories),
                      const SizedBox(height: 16),
                      _buildDateField(),
                      const SizedBox(height: 32),
                      _buildSaveButton(),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: amountController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(CupertinoIcons.money_dollar, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          hintText: 'Amount',
        ),
      ),
    );
  }

  Widget _buildCategoryField(GetCategoriesSuccess state) {
    return TextFormField(
      readOnly: true,
      controller: categoryController,
      decoration: InputDecoration(
        filled: true,
        fillColor: expense.category == Category.empty ? Colors.white : getColorFromHex(expense.category.color),
        prefixIcon: expense.category == Category.empty
            ? const Icon(CupertinoIcons.list_number, color: Colors.grey)
            : Icon(getCupertinoIcon(expense.category.icon)),
        suffixIcon: IconButton(
          onPressed: () async {
            var newCategory = await addCategoryDialog(context);
            if (newCategory != null) {
              setState(() {
                state.categories.insert(0, newCategory);
              });
            }
          },
          icon: const Icon(CupertinoIcons.plus, color: Colors.grey),
        ),
        border: const OutlineInputBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12)), borderSide: BorderSide.none),
        hintText: 'Category',
      ),
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, int i) {
            return Card(
              child: ListTile(
                onTap: () => _onCategorySelected(categories[i]),
                leading: Icon(getCupertinoIcon(categories[i].icon), size: 24),
                title: Text(categories[i].name),
                tileColor: getColorFromHex(categories[i].color),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          },
        ),
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
          initialDate: expense.date,
          firstDate: DateTime.now().subtract(const Duration(days: 45)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (newDate != null) {
          setState(() {
            dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
            expense.date = newDate;
          });
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(CupertinoIcons.calendar_today, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        hintText: 'Date',
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
                  expense.amount = int.parse(amountController.text);
                });

                context.read<CreateExpenseBloc>().add(CreateExpense(expense));
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
            ),
    );
  }
}
