import 'package:ekawi/models/form_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final List<FormModel> energyData;
  const PieChartWidget(this.energyData, {super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryTotals = _computeCategoryTotals(energyData);
    final size = MediaQuery.of(context).size;
    List<PieChartSectionData> sections =
        _generateChartSections(categoryTotals, size);

    return Container(
      width: double.infinity,
      height:
          MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sections: sections,
          borderData: FlBorderData(show: false),
          sectionsSpace: 3,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
  Map<String, double> _computeCategoryTotals(List<FormModel> energyData) {
    Map<String, double> categoryTotals = {
      'Lighting': 0.0,
      'Cooking': 0.0,
      'Charging': 0.0,
      'Heating':0.0
    };

    for (var item in energyData) {
      String category = _categorizeAppliance(item.applianceName);
      categoryTotals[category] = (categoryTotals[category] ?? 0) + item.kwh;
    }

    return categoryTotals;
  }
  String _categorizeAppliance(String appliance) {
    if (appliance.toLowerCase().contains('light')) return 'Lighting';
    if (appliance.toLowerCase().contains('cook')) return 'Cooking';
    if (appliance.toLowerCase().contains('charge')) return 'Charging';
    if (appliance.toLowerCase().contains('kettle')) return 'Heating';

    return 'Others';
  }

  List<PieChartSectionData> _generateChartSections(
      Map<String, double> categoryTotals, Size size) {
    double totalKwh = categoryTotals.values.fold(0, (sum, kwh) => sum + kwh);
    List<Color> colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.cyan
    ];

    return categoryTotals.entries.map((entry) {
      final index = categoryTotals.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / totalKwh) * 100;

      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n${percentage.toStringAsFixed(2)}%',
        color: colors[index % colors.length],
        radius: size.width * 0.4,
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }
}