import 'package:flutter/material.dart';

class ReportsListCard extends StatelessWidget {
  const ReportsListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = [
      {'title': 'Monthly Energy Report', 'date': 'Feb 2024', 'type': 'PDF'},
      {'title': 'Quarterly Comparison', 'date': 'Q1 2024', 'type': 'Excel'},
      {'title': 'Annual Summary 2023', 'date': 'Jan 2024', 'type': 'PDF'},
    ];

    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Available Reports',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ])));
  }
}
