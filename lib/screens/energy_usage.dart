// Portion 1: Imports and State Initialization

import 'package:ekawi/screens/monthly_energy_usage_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/meter_reading.dart';
import 'package:intl/intl.dart';
import 'weekly_comparison.dart';
import 'monthly_comparison.dart';

class EnergyUsageGraph extends StatefulWidget {
  const EnergyUsageGraph({super.key});

  @override
  State<EnergyUsageGraph> createState() => _EnergyUsageGraphState();
}

class _EnergyUsageGraphState extends State<EnergyUsageGraph> {
  final _dio = Dio();
  String? selectedHostel;
  String selectedGraphType = 'Weekly';
  String selectedWeek = 'Week 1';

  @override
  void initState() {
    super.initState();
    selectedHostel = 'Hostel H & J'; // Initial hostel selection
  }

  // Portion 2: Data Fetching and Parsing

  Future<List<MeterReading>> _fetchMeterReadings() async {
    const url =
        'https://beverline-5ddb2-default-rtdb.firebaseio.com/meterReadings.json';
    try {
      final response = await _dio.get(url);
      final extractedData = response.data as Map<String, dynamic>?;

      if (extractedData == null) {
        return [];
      }

      List<MeterReading> loadedData = [];
      extractedData.forEach((key, value) {
        try {
          final meterReading = MeterReading(
            date: DateTime.parse(value['date']),
            hostel: value['hostel'],
            reading: double.parse(value['meterReading']),
          );
          if (selectedHostel == null || meterReading.hostel == selectedHostel) {
            loadedData.add(meterReading);
          }
        } catch (e) {
          print('Error parsing entry: $e, value: $value');
        }
      });
      return loadedData;
    } catch (error) {
      print('Error fetching data: $error');
      return [];
    }
  }

// Portion 3: Weekly Data Calculation
List<FlSpot> _calculateWeeklySpots(List<MeterReading> meterReadings) {
  if (meterReadings.isEmpty) {
    return [];
  }

  Map<int, double> dailyTotals = {
    0: 0.0,
    1: 0.0,
    2: 0.0,
    3: 0.0,
    4: 0.0,
    5: 0.0,
    6: 0.0
  };

  int weekNumber = int.parse(selectedWeek.split(' ')[1]);
  DateTime firstEntryDate = meterReadings
      .map((e) => e.date)
      .reduce((a, b) => a.isBefore(b) ? a : b);

  DateTime startOfWeek = firstEntryDate.add(Duration(days: (weekNumber - 1) * 7));
  DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

  List<MeterReading> weeklyReadings = meterReadings.where((entry) =>
      entry.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
      entry.date.isBefore(endOfWeek.add(const Duration(days: 1)))).toList();

  weeklyReadings.sort((a, b) => a.date.compareTo(b.date));

  for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
    DateTime currentDay = startOfWeek.add(Duration(days: dayIndex));
    double dailyUsage = 0.0;

    for (int i = 0; i < weeklyReadings.length; i++) {
      var entry = weeklyReadings[i];
      if (entry.date.year == currentDay.year &&
          entry.date.month == currentDay.month &&
          entry.date.day == currentDay.day) {
        if (i > 0) {
          int previousDayIndex = dayIndex -1;
          if(previousDayIndex < 0){
            previousDayIndex = 6;
          }
          DateTime previousDay = startOfWeek.add(Duration(days: previousDayIndex));
          MeterReading? previousReading;
          for(int j = 0; j < weeklyReadings.length; j++){
            if(weeklyReadings[j].date.year == previousDay.year && weeklyReadings[j].date.month == previousDay.month && weeklyReadings[j].date.day == previousDay.day){
              previousReading = weeklyReadings[j];
            }
          }

          if(previousReading != null){
            dailyUsage = entry.reading - previousReading.reading;
          } else {
            dailyUsage = entry.reading - weeklyReadings.first.reading;
          }

        } else {
          dailyUsage = entry.reading - weeklyReadings.first.reading;

        }
        dailyTotals[dayIndex] = dailyUsage;
        break;
      }
    }
  }

  return dailyTotals.entries
      .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
      .toList();
}

 // Portion 4: Comparison Popup Functions

  void _showHostelComparisonPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hostel Comparisons'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showWeeklyComparisonPopup(context);
                },
                child: const Text('Weekly Comparison'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showMonthlyComparisonPopup(context);
                },
                child: const Text('Monthly Comparison'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWeeklyComparisonPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(''),
          ),
          body: const WeeklyComparison(),
        );
      },
    );
  }

  void _showMonthlyComparisonPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(''),
          ),
          body: const MonthlyComparison(),
        );
      },
    );
  }

  // Portion 5: Building the UI (Dropdowns and Graph Display)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumption Graph'),
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () => _showHostelComparisonPopup(context),
              child: const Text("Hostel Comparison"),
            ),
          ),
        ],
      ),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: selectedGraphType,
                      items: const [
                        DropdownMenuItem(
                            value: 'Weekly',
                            child: Text('Weekly Consumption (kwh)')),
                        DropdownMenuItem(
                            value: 'Monthly',
                            child: Text('Monthly Consumption (kwh)')),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGraphType = newValue!;
                        });
                      },
                    ),
                    if (selectedGraphType == 'Weekly')
                      DropdownButton<String>(
                        value: selectedWeek,
                        items: const [
                          DropdownMenuItem(
                              value: 'Week 1', child: Text('Week 1')),
                          DropdownMenuItem(
                              value: 'Week 2', child: Text('Week 2')),
                          DropdownMenuItem(
                              value: 'Week 3', child: Text('Week 3')),
                          DropdownMenuItem(
                              value: 'Week 4', child: Text('Week 4')),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedWeek = newValue!;
                          });
                        },
                      ),
                    DropdownButton<String>(
                      value: selectedHostel,
                      hint: const Text('Hostel'),
                      items: const [
                        DropdownMenuItem(
                            value: 'Hostel H & J', child: Text('Hostel H & J')),
                        DropdownMenuItem(value: 'Soweto', child: Text('Soweto')),
                        DropdownMenuItem(
                            value: 'Students\' center',
                            child: Text('Students\' center')),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedHostel = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: selectedGraphType == 'Weekly'
                    ? (selectedHostel != null && selectedWeek != null)
                        ? FutureBuilder<List<MeterReading>>(
                            future: _fetchMeterReadings(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No meter readings available.'));
                              }

                              final weeklySpots =
                                  _calculateWeeklySpots(snapshot.data!);

                              if (weeklySpots.isEmpty) {
                                return const Center(
                                    child: Text(
                                        "No data for the selected week."));
                              }

                              return LineChart(
                                LineChartData(
                                  gridData: const FlGridData(
                                      show: true, drawVerticalLine: true),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          switch (value.toInt()) {
                                            case 0:
                                              return const Text('Sun');
                                            case 1:
                                              return const Text('Mon');
                                            case 2:
                                              return const Text('Tue');
                                            case 3:
                                              return const Text('Wed');
                                            case 4:
                                              return const Text('Thu');
                                            case 5:
                                              return const Text('Fri');
                                            case 6:
                                              return const Text('Sat');
                                            default:
                                              return const Text('');
                                          }
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        interval: 5000000,
                                        getTitlesWidget: (value, meta) {
                                          return Text('${value.toInt()}');
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(
                                          color: Colors.grey.shade300)),
                                  minX: 0,
                                  maxX: 6,
                                  minY: 0,
                                  maxY: 30000000,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: weeklySpots,
                                      isCurved: true,
                                      color: Colors.blue,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: true),
                                      belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.blue.withOpacity(0.2)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('Select a hostel and week.'))
                    : MonthlyEnergyUsageGraph(selectedHostel: selectedHostel!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}