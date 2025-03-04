import 'package:flutter/material.dart';

class MaintenanceScheduleCard extends StatelessWidget {
  const MaintenanceScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final schedules = [
      {'device': 'Air Conditioners', 'date': '2024-02-15', 'status': 'Pending'},
      {'device': 'Water Heaters', 'date': '2024-02-20', 'status': 'Scheduled'},
      {'device': 'Lighting', 'date': '2024-02-25', 'status': 'Completed'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Maintenance Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return ListTile(
                  title: Text(schedule['device']!),
                  subtitle: Text('Date: ${schedule['date']}'),
                  trailing: Chip(
                    label: Text(schedule['status']!),
                    backgroundColor: _getStatusColor(schedule['status']!),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.shade100;
      case 'pending':
        return Colors.orange.shade100;
      case 'scheduled':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}