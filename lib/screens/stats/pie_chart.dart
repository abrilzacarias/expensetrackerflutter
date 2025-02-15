import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_repository/expense_repository.dart';

import '../utils/utils.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  final FirebaseExpenseRepository _expenseRepository = FirebaseExpenseRepository();
  Map<String, double> _categoryData = {};
  Map<String, String> _categoryColors = {}; 
  String? _selectedCategory; 

  @override
  void initState() {
    super.initState();
    _fetchCategoryData();
  }

  Future<void> _fetchCategoryData() async {
    try {
      List<Expense> expenses = await _expenseRepository.getExpenses();
      Map<String, double> categoryTotals = {};
      Map<String, String> categoryColorMap = {}; 

      for (var expense in expenses) {
        categoryTotals.update(
          expense.category.name,
          (value) => value + expense.amount.toDouble(),
          ifAbsent: () => expense.amount.toDouble(),
        );

        categoryColorMap.putIfAbsent(expense.category.name, () => expense.category.color);
      }

      setState(() {
        _categoryData = categoryTotals;
        _categoryColors = categoryColorMap;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_categoryData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const Text(
          "Expenses by Category",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 1.7,
          child: PieChart(
            PieChartData(
              sections: _generatePieChartSections(),
              centerSpaceRadius: 40,
              sectionsSpace: 3,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (pieTouchResponse != null &&
                        pieTouchResponse.touchedSection != null &&
                        pieTouchResponse.touchedSection!.touchedSectionIndex >= 0) {
                      // ✅ Solo acceder a la categoría si el índice es válido
                      _selectedCategory = _categoryData.keys.elementAt(
                          pieTouchResponse.touchedSection!.touchedSectionIndex);
                    } else {
                      // ✅ Si el índice no es válido, deseleccionar
                      _selectedCategory = null;
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generatePieChartSections() {
    if (_categoryData.isEmpty) return [];

    return _categoryData.entries.map((entry) {
      final double percentage = (entry.value / _categoryData.values.reduce((a, b) => a + b)) * 100;
      final bool isSelected = entry.key == _selectedCategory;

      return PieChartSectionData(
        color: getColorFromHex(_categoryColors[entry.key] ?? "#CCCCCC"), 
        value: entry.value,
        title: '${entry.key} \n${percentage.toStringAsFixed(1)}%',
        radius: isSelected ? 60 : 50, 
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black), 
      );
    }).toList();
  }
}
