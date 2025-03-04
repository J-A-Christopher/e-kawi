import 'package:ekawi/models/form_model.dart';
import 'package:ekawi/providers/energy_mgmt_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class EnergyUsagePieChart extends StatefulWidget {
  const EnergyUsagePieChart({super.key});

  @override
  State<EnergyUsagePieChart> createState() => _EnergyUsagePieChartState();
}

class _EnergyUsagePieChartState extends State<EnergyUsagePieChart> {
  int touchedIndex = -1;
  String? selectedHostel;

  Future<List<FormModel>> _fetchEnergyData() async {
    final provider = Provider.of<EnergyManagementProvider>(context, listen: false);
    return await provider.getEnergyData(hostelFilter: selectedHostel);
  }

  List<PieChartSectionData> _calculatePieData(List<FormModel> energyData) {
    // Group data by day of week
    Map<String, double> dailyTotals = {
      'Sun': 0.0,
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
    };

    for (var entry in energyData) {
      String day = [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat'
      ][entry.dateFilled.weekday % 7];
      dailyTotals[day] = (dailyTotals[day] ?? 0.0) + entry.kwh;
    }

    // Create pie sections
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.yellow,
      Colors.teal,
    ];

    return dailyTotals.entries.map((entry) {
      final index = dailyTotals.keys.toList().indexOf(entry.key);
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;

      return PieChartSectionData(
        color: colors[index],
        value: entry.value,
        title: '${entry.key}\n${entry.value.toStringAsFixed(1)}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daily Energy Distribution',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedHostel,
                    hint: const Text('Hostel'),
                    items: const [
                      DropdownMenuItem(
                        value: 'HOSTEL H',
                        child: Text('HOSTEL H'),
                      ),
                      DropdownMenuItem(
                        value: 'HOSTEL J',
                        child: Text('HOSTEL J'),
                      ),
                    ],
                    onChanged: (String? newValue) async {
                      setState(() {
                        selectedHostel = newValue;
                      });
                      await Provider.of<EnergyManagementProvider>(context,
                              listen: false)
                          .getEnergyData(hostelFilter: selectedHostel);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<FormModel>>(
                  future: _fetchEnergyData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: LoadingAnimationWidget.threeRotatingDots(
                              color: Colors.white, size: 40));
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error loading energy data are you online?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error)),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No energy data available'),
                      );
                    }

                    return PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                        sections: _calculatePieData(snapshot.data!),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}