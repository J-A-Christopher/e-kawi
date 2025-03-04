import 'package:ekawi/models/hostel_data_model.dart';
import 'package:flutter/material.dart';

class PeakUsageCard extends StatelessWidget {
  final HostelData hostelData;

  const PeakUsageCard({super.key, required this.hostelData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Peak Usage Analysis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Morning Peak'),
              subtitle: const Text('6 AM - 9 AM'),
              trailing: Text(
                  '${(hostelData.currentUsage * 0.3).toStringAsFixed(1)} kWh'),
            ),
            ListTile(
              title: const Text('Evening Peak'),
              subtitle: const Text('6 PM - 10 PM'),
              trailing: Text(
                  '${(hostelData.currentUsage * 0.5).toStringAsFixed(1)} kWh'),
            ),
          ],
        ),
      ),
    );
  }
}