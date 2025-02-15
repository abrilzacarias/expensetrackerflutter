import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final FirebaseExpenseRepository _expenseRepository = FirebaseExpenseRepository();
  Map<String, double> _groupedExpenses = {}; // Mapa para agrupar los gastos por fecha

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    try {
      List<Expense> expenses = await _expenseRepository.getExpenses();

      // Agrupar gastos por fecha (formateada como dd/MM)
      Map<String, double> groupedData = {};
      for (var expense in expenses) {
        String dateKey = DateFormat('dd/MM').format(expense.date);
        groupedData.update(dateKey, (value) => value + expense.amount.toDouble(), ifAbsent: () => expense.amount.toDouble());
      }

      // Ordenar por fecha (de menos reciente a más reciente)
      var sortedEntries = groupedData.entries.toList()
        ..sort((a, b) => DateFormat('dd/MM').parse(a.key).compareTo(DateFormat('dd/MM').parse(b.key)));

      setState(() {
        _groupedExpenses = Map.fromEntries(sortedEntries);
      });
    } catch (e) {
      print("Error obteniendo gastos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_groupedExpenses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Monthly Expenses",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false), // ❌ Ocultar números a la derecha
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false), // ❌ Ocultar números sobre las barras
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getTitles,
                      reservedSize: 22,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitles,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                barGroups: _groupedExpenses.entries.map((entry) {
                  int index = _groupedExpenses.keys.toList().indexOf(entry.key);
                  return makeGroupData(index, entry.value);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blueAccent,
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: _groupedExpenses.values.reduce((a, b) => a > b ? a : b),
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final int index = value.toInt();
    if (index < 0 || index >= _groupedExpenses.length) return Container();

    String formattedDate = _groupedExpenses.keys.elementAt(index);

    return SideTitleWidget(
      space: 8,
      meta: meta,
      angle: -0.3, // Inclina los títulos para mejor lectura
      child: Text(
        formattedDate,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value % 100 != 0) return Container(); // Solo mostrar valores múltiplos de 100

    return SideTitleWidget(
      space: 8,
      meta: meta,
      child: Text(
        "\$${value.toInt()}",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
