import 'package:ekawi/providers/energy_mgmt_provider.dart';
import 'package:ekawi/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class UsageAnalyticsScreen extends StatefulWidget {
  const UsageAnalyticsScreen({super.key});

  @override
  State<UsageAnalyticsScreen> createState() => _UsageAnalyticsScreenState();
}

class _UsageAnalyticsScreenState extends State<UsageAnalyticsScreen> {
  String? selectedHostel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usage Data Analytics.'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedHostel,
              hint: const Text('Filter Data By Hostel'),
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
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<EnergyManagementProvider>(context, listen: false)
            .getEnergyData(hostelFilter: selectedHostel),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.white, size: 40));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading data.Are you online?',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          } else {
            final energyData = snapshot.data!;
            return PieChartWidget(energyData);
          }
        },
      ),
    );
  }
}
