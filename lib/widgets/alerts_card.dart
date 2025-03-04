import 'package:flutter/material.dart';

class AlertsCard extends StatelessWidget {
  const AlertsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        'title': 'High Usage Alert',
        'description': 'Floor 3 showing unusual consumption',
        'time': '2 hours ago',
        'priority': 'high'
      },
      {
        'title': 'Maintenance Due',
        'description': 'AC units need scheduled check',
        'time': '1 day ago',
        'priority': 'medium'
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Alerts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return ListTile(
                  leading: Icon(
                    Icons.warning,
                    color: _getPriorityColor(alert['priority']!),
                  ),
                  title: Text(alert['title']!),
                  subtitle: Text(alert['description']!),
                  trailing: Text(
                    alert['time']!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}